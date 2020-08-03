//
//  CameraView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "CameraView.h"

@interface CameraView (IBActions)
-(IBAction)onGoBack:(id)sender;
-(IBAction)onFlipCamera:(id)sender;
-(IBAction)onTakePicture:(id)sender;
@end

@implementation CameraView

@synthesize delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage systemImageNamed:@"arrow.left"] forState:UIControlStateNormal];
        [_cancelButton setTintColor:[Theme cyanColor]];
        [_cancelButton addTarget:self action:@selector(onGoBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton.widthAnchor constraintEqualToConstant:50].active = YES;
        [_cancelButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_cancelButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_cancelButton.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10.0].active = YES;
        
        _flipCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flipCameraButton setBackgroundImage:[UIImage systemImageNamed:@"camera"] forState:UIControlStateNormal];
        [_flipCameraButton setTintColor:[Theme cyanColor]];
        [_flipCameraButton addTarget:self action:@selector(onFlipCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_flipCameraButton];
        _flipCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_flipCameraButton.widthAnchor constraintEqualToConstant:60].active = YES;
        [_flipCameraButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_flipCameraButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_flipCameraButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
        
        _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePictureButton setBackgroundImage:[UIImage systemImageNamed:@"circle"] forState:UIControlStateNormal];
        [_takePictureButton setTintColor:[Theme cyanColor]];
        [_takePictureButton addTarget:self action:@selector(onTakePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_takePictureButton];
        _takePictureButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_takePictureButton.widthAnchor constraintEqualToConstant:100].active = YES;
        [_takePictureButton.heightAnchor constraintEqualToConstant:100].active = YES;
        [_takePictureButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-(kCameraViewFiltersScrollViewHeight + 70.0)].active = YES;
        [_takePictureButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        
        _filtersSV = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _filtersSV.delegate = self;
        _filtersSV.scrollEnabled = YES;
        _filtersSV.pagingEnabled = YES;
        _filtersSV.clipsToBounds = YES;
        _filtersSV.userInteractionEnabled = YES;
        _filtersSV.bounces = YES;
        _filtersSV.showsHorizontalScrollIndicator = NO;
        _filtersSV.showsVerticalScrollIndicator = NO;
        _filtersSV.backgroundColor = [Theme transparentColor];
        [self addSubview:_filtersSV];
        _filtersSV.translatesAutoresizingMaskIntoConstraints = NO;
        [_filtersSV.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
         [_filtersSV.heightAnchor constraintEqualToConstant:kCameraViewFiltersScrollViewHeight].active = YES;
        [_filtersSV.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-kCameraViewFiltersScrollViewHeight].active = YES;
        
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        _loading.hidesWhenStopped = YES;
        [self addSubview:_loading];
        _loading.translatesAutoresizingMaskIntoConstraints = NO;
        [_loading.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_loading.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        _cameraReady = YES;
    }
    return self;
}

- (void)build {
    _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
    _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //[_stillCamera.inputCamera lockForConfiguration:nil];
    //[_stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOff];
    //[_stillCamera.inputCamera unlockForConfiguration];
    
    [self setupFilter:GPUIMAGE_SATURATION];
    [self setupFilters];
    //[_stillCamera startCameraCapture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_iOrientation == UIDeviceOrientationPortrait)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    else if (_iOrientation == UIDeviceOrientationLandscapeLeft)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    else if (_iOrientation == UIDeviceOrientationLandscapeRight)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
    else
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
}

#pragma mark - Filters

- (void)setupFilter:(kVideoFilterType)videoFilterType {
    [_loading startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL needsSecondImage = NO;
        self->_filterType = videoFilterType;
        self->_filter = [Filters initializeFilter:self->_filterType];
        
        if (
            videoFilterType == GPUIMAGE_MASK ||
            videoFilterType == GPUIMAGE_CHROMAKEY ||
            videoFilterType == GPUIMAGE_MULTIPLY ||
            videoFilterType == GPUIMAGE_OVERLAY ||
            videoFilterType == GPUIMAGE_LIGHTEN ||
            videoFilterType == GPUIMAGE_DARKEN ||
            videoFilterType == GPUIMAGE_DISSOLVE ||
            videoFilterType == GPUIMAGE_SCREENBLEND ||
            videoFilterType == GPUIMAGE_COLORBURN ||
            videoFilterType == GPUIMAGE_COLORDODGE ||
            videoFilterType == GPUIMAGE_EXCLUSIONBLEND ||
            videoFilterType == GPUIMAGE_DIFFERENCEBLEND ||
            videoFilterType == GPUIMAGE_SUBTRACTBLEND ||
            videoFilterType == GPUIMAGE_HARDLIGHTBLEND ||
            videoFilterType == GPUIMAGE_SOFTLIGHTBLEND
        ) {
            needsSecondImage = YES;
        } else if (videoFilterType == GPUIMAGE_VORONI) {
            GPUImageJFAVoronoiFilter *jfa = [[GPUImageJFAVoronoiFilter alloc] init];
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            self->_sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"voroni_points2.png"]];
            
            [self->_sourcePicture addTarget:jfa];
            
            self->_filter = [[GPUImageVoronoiConsumerFilter alloc] init];
            
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            [(GPUImageVoronoiConsumerFilter *)self->_filter setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            [self->_stillCamera addTarget:self->_filter];
            [jfa addTarget:self->_filter];
            [self->_sourcePicture processImage];
        }
        else if (videoFilterType == GPUIMAGE_FILECONFIG) {
            //self.title = @"File Configuration";
            self->_pipeline = [[GPUImageFilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]
                                                                                  input:self->_stillCamera output:(GPUImageView*)self];
            
            //        [pipeline addFilter:rotationFilter atIndex:0];
        }
        else {
            
            if (videoFilterType != GPUIMAGE_VORONI) {
                //[_filter prepareForImageCapture];
                [self->_stillCamera addTarget:self->_filter];
            }
            
            self->_stillCamera.runBenchmark = NO;
            
            if (needsSecondImage) {
                UIImage *inputImage;
                
                if (videoFilterType == GPUIMAGE_MASK)
                {
                    inputImage = [UIImage imageNamed:@"mask"];
                }
                /*
                 else if (videoFilterType == GPUIMAGE_VORONI) {
                 inputImage = [UIImage imageNamed:@"voroni_points.png"];
                 }*/
                else {
                    // The picture is only used for two-image blend filters
                    inputImage = [UIImage imageNamed:@"WID-small.jpg"];
                }
                
                
                self->_sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
                [self->_sourcePicture addTarget:self->_filter];
                
                [self->_sourcePicture processImage];
                
            }
            
            GPUImageView *filterView = (GPUImageView *)self;
            
            if (videoFilterType == GPUIMAGE_HISTOGRAM) {
                // I'm adding an intermediary filter because glReadPixels() requires something to be rendered for its glReadPixels() operation to work
                [self->_stillCamera removeTarget:self->_filter];
                GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
                [self->_stillCamera addTarget:gammaFilter];
                [gammaFilter addTarget:self->_filter];
                
                GPUImageHistogramGenerator *histogramGraph = [[GPUImageHistogramGenerator alloc] init];
                
                [histogramGraph forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
                [self->_filter addTarget:histogramGraph];
                
                GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
                blendFilter.mix = 0.75;
                
                [self->_stillCamera addTarget:blendFilter];
                [histogramGraph addTarget:blendFilter];
                self->_stillCamera.targetToIgnoreForUpdates = blendFilter; // Avoid double-updating the blend
                
                [blendFilter addTarget:filterView];
                //[blendFilter addTarget:movieWriter];
            }
            else if (videoFilterType == GPUIMAGE_HARRISCORNERDETECTION) {
                GPUImageCrosshairGenerator *crosshairGenerator = [[GPUImageCrosshairGenerator alloc] init];
                crosshairGenerator.crosshairWidth = 15.0;
                [crosshairGenerator forceProcessingAtSize:CGSizeMake(480.0, 640.0)];
                
                // [(GPUImageHarrisCornerDetectionFilter *)_filter setCornersDetectedBlock:^(GLfloat* cornerArray, NSUInteger cornersDetected) {
                //   [crosshairGenerator renderCrosshairsFromArray:cornerArray count:cornersDetected];
                //}];
                
                GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
                GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
                [self->_stillCamera addTarget:gammaFilter];
                [gammaFilter addTarget:blendFilter];
                gammaFilter.targetToIgnoreForUpdates = blendFilter;
                
                [crosshairGenerator addTarget:blendFilter];
                
                [blendFilter addTarget:filterView];
                //[blendFilter addTarget:movieWriter];
            }
            
            else {
                [self->_filter addTarget:filterView];
                //[_filter addTarget:movieWriter];
            }
        }
        
        [self->_stillCamera startCameraCapture];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self->_loading stopAnimating];
        });
    });
}

- (void)setupFilters {
    CGFloat cx = kCameraViewFiltersScrollViewLeftPadding;
    CGFloat y = kCameraViewFiltersScrollViewTopPadding;
    int numpages = 0;
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"CaptureFilters.plist"];
    NSDictionary *filters = [NSDictionary dictionaryWithContentsOfFile:path];
    
    int numberOfThumbs = (int)[filters count];
    
    CGFloat width = self.frame.size.width;
    CGFloat thumbWidth = (width/5.f) - kCameraViewFiltersScrollViewPadding;
    CGFloat thumbHeight = kCameraViewFiltersScrollViewHeight/2.f + kCameraViewFiltersScrollViewLabelHeight;
    CGRect thumbFrame = CGRectMake(0, 0, thumbWidth, thumbHeight);
    
    NSString *name = nil;
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<numberOfThumbs; i++) {
        FilterThumb *thumbView = [[FilterThumb alloc] initWithFrame:thumbFrame];
        thumbView.delegate = self;
        
        NSNumber* key = [NSNumber numberWithInt:i];
        name = [filters objectForKey:[key stringValue]];
        thumbView.type = [[NSString alloc] initWithString:name];
        
        CGRect rect = thumbView.frame;
        rect.origin.x = cx;
        rect.origin.y = y;
        thumbView.frame = rect;
        [_filtersSV addSubview:thumbView];
        [thumbView build];
        [tempArray addObject:thumbView];
        
        cx += thumbView.frame.size.width + kCameraViewFiltersScrollViewPadding;
        
        if (i==0)
            [thumbView setSelected: YES];
        
        numpages++;
    }
    
    if (numpages == 0)
        numpages = 1;
    
    [_filtersSV setContentSize:CGSizeMake((thumbWidth+kCameraViewFiltersScrollViewLeftPadding*2)*numpages, [_filtersSV bounds].size.height)];
    [_filtersSV scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    _filtersArray = [[NSArray alloc] initWithArray:tempArray];
}

#pragma mark - IBActions

- (IBAction)onGoBack:(id)sender {
    [delegate onGoBack];
}

- (IBAction)onFlipCamera:(id)sender {
    [_stillCamera stopCameraCapture];
    [_stillCamera removeAllTargets];
    _stillCamera = nil;
    
    if (_frontCamera) {
        //_flashBtn.hidden = NO;
        //_flashBtn.enabled = YES;
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionBack];
        _frontCamera = FALSE;
    }
    else {
        //_flashBtn.hidden = YES;
        //_flashBtn.enabled = NO;
        _stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
        _frontCamera = TRUE;
    }
    _stillCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    if (_iOrientation == UIDeviceOrientationPortrait)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    else if (_iOrientation == UIDeviceOrientationLandscapeLeft)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
    else if (_iOrientation == UIDeviceOrientationLandscapeRight)
        _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
    else
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    [_stillCamera addTarget:_filter];
    [_stillCamera startCameraCapture];
}

- (IBAction)onTakePicture:(id)sender {
    if (_cameraReady) {
        _cameraReady = NO;
        
        [_stillCamera capturePhotoAsImageProcessedUpToFilter:_filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            self->_cameraReady = YES;
            //NSLog(@"processedImage w: %f, h: %f", processedImage.size.width, processedImage.size.height);
            
            //UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            // Create an UIImage from the CGImageRef object with scale = 1.0 and the orientation of the original image
            UIImage* correctedImage = [[UIImage alloc] initWithCGImage:processedImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
            [self->delegate onTakePic:correctedImage];
        }];
    }
}

#pragma mark - Capture

- (void)stopCapture:(BOOL)pStop {
    if (pStop)
        [_stillCamera stopCameraCapture];
    else {
        [_stillCamera startCameraCapture];
        
        if (_iOrientation == UIDeviceOrientationPortrait)
            _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        else if (_iOrientation == UIDeviceOrientationLandscapeLeft)
            _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeRight;
        else if (_iOrientation == UIDeviceOrientationLandscapeRight)
            _stillCamera.outputImageOrientation = UIInterfaceOrientationLandscapeLeft;
        else
            _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
}

#pragma mark - IFilterThumbDelegate methods

- (void)onTouch:(kVideoFilterType)filterType withFilter:(NSString *)name {
    [_stillCamera stopCameraCapture];
    [_stillCamera removeAllTargets];
    [self setupFilter:filterType];
    
    for (FilterThumb *t in _filtersArray) {
        if ([name isEqualToString:t.type])
            [t setSelected: YES];
        else
            [t setSelected: NO];
    }
}

@end
