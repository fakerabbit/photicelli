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

@end

@implementation EditorController

#pragma mark - View methods

- (void)loadView {
    [super loadView];
    _editorView = [[EditorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
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
    
    //_editorView.image = scaledImage;
    [_editorView build:scaledImage];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        //[self processPhoto: _photo.imageOrientation];
        //[self->_editorView build:scaledImage];
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

@end
