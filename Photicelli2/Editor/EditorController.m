//
//  EditorController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "EditorController.h"
#import "UIImage+Resize.h"

@interface EditorController ()
- (void)processPhoto:(UIImageOrientation)orientation;
@end

@implementation EditorController

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _dataStore = [[DataStore alloc] init];
    }
    return self;
}

#pragma mark - View methods

- (void)loadView {
    [super loadView];
    _editorView = [[EditorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _editorView.delegate = self;
    
    // Create image for editing...
    float w = 0;
    float h = 0;
    float ds = 0;
    float desiredWidth = 800.0f;
    float desiredHeight = 800.0f;
    if (_photo.size.width > _photo.size.height) {
        w = desiredWidth;
        ds = (desiredWidth * 100)/_photo.size.width;
        //NSLog(@"ds: %f", ds);
        h = (ds*_photo.size.height)/100;
    }
    else {
        h = desiredHeight;
        ds = (desiredHeight *100)/_photo.size.height;
        //NSLog(@"ds: %f", ds);
        w = (ds*_photo.size.width)/100;
    }
    
    CGSize desiredSize = CGSizeMake(h, w);
    //NSLog(@"desiredSize w: %f, h: %f", desiredSize.width, desiredSize.height);
    
    UIImage* scaledImage = [[UIImage alloc] initWithCGImage:[_photo resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:desiredSize interpolationQuality:kCGInterpolationHigh].CGImage];
    //NSLog(@"scaled image w: %f, h: %f", scaledImage.size.width, scaledImage.size.height);
    
    _editorView.image = scaledImage;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        [self processPhoto: self->_photo.imageOrientation];
    });
    
    //NSLog(@"scaledImage orientation: %ld", scaledImage.imageOrientation);
    
    self.view = _editorView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Private Methods

- (void)processPhoto:(UIImageOrientation)orientation {
    // Delete test picture just in case
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent: [NSString stringWithFormat:@"test.png"]];
    [fileManager removeItemAtPath:filePath error:NULL];
    
    // Store original image
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(_photo)];
    [data writeToFile: pngFilePath atomically: YES];
    [_dataStore storePhoto: pngFilePath withOrientation: orientation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_editorView build];
        self->_photo = nil;
    });
}

#pragma mark - IEditorViewDelegate methods

- (void)onGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onShare:(UIImage *)image {
    NSArray *activityItems = [NSArray arrayWithObjects:image, nil];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion: nil];
    [activityController setCompletionWithItemsHandler:^(UIActivityType _Nullable activityType, BOOL completed, NSArray *_Nullable returnedItems, NSError * _Nullable activityError) {
        if (activityType != nil) {
            //NSLog(@"activityType: %@", activityType);
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your picture was shared" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {}];

            [alertController addAction:defaultAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
