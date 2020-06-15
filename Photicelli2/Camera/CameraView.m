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
    [_stillCamera startCameraCapture];
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
    
    BOOL needsSecondImage = NO;
    _filterType = videoFilterType;
    
    switch (videoFilterType) {
        case GPUIMAGE_SEPIA:
        {
            _filter = [[GPUImageSepiaFilter alloc] init];
        }
            break;
        case GPUIMAGE_PIXELLATE:
        {
            _filter = [[GPUImagePixellateFilter alloc] init];
        }
            break;
        case GPUIMAGE_POLARPIXELLATE:
        {
            _filter = [[GPUImagePolarPixellateFilter alloc] init];
        }
            break;
        case GPUIMAGE_CROSSHATCH:
        {
            _filter = [[GPUImageCrosshatchFilter alloc] init];
            [(GPUImageCrosshatchFilter *)_filter setCrossHatchSpacing:0.01];
            
        }
            break;
        case GPUIMAGE_COLORINVERT:
        {
            _filter = [[GPUImageColorInvertFilter alloc] init];
        }
            break;
        case GPUIMAGE_GRAYSCALE:
        {
            _filter = [[GPUImageGrayscaleFilter alloc] init];
        }
            break;
        case GPUIMAGE_SATURATION:
        {
            _filter = [[GPUImageSaturationFilter alloc] init];
        }
            break;
        case GPUIMAGE_CONTRAST:
        {
            _filter = [[GPUImageContrastFilter alloc] init];
        }
            break;
        case GPUIMAGE_BRIGHTNESS:
        {
            _filter = [[GPUImageBrightnessFilter alloc] init];
        }
            break;
        case GPUIMAGE_RGB:
        {
            _filter = [[GPUImageRGBFilter alloc] init];
        }
            break;
        case GPUIMAGE_EXPOSURE:
        {
            _filter = [[GPUImageExposureFilter alloc] init];
            [(GPUImageExposureFilter *)_filter setExposure:2.467];
            
        }
            break;
        case GPUIMAGE_SHARPEN:
        {
            _filter = [[GPUImageSharpenFilter alloc] init];
        }
            break;
        case GPUIMAGE_UNSHARPMASK:
        {
            _filter = [[GPUImageUnsharpMaskFilter alloc] init];
            
            //            [(GPUImageUnsharpMaskFilter *)_filter setIntensity:3.0];
        }
            break;
        case GPUIMAGE_GAMMA:
        {
            _filter = [[GPUImageGammaFilter alloc] init];
        }
            break;
        case GPUIMAGE_TONECURVE:
        {
            _filter = [[GPUImageToneCurveFilter alloc] init];
            [(GPUImageToneCurveFilter *)_filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
        }
            break;
        case GPUIMAGE_HAZE:
        {
            _filter = [[GPUImageHazeFilter alloc] init];
        }
            break;
        case GPUIMAGE_HISTOGRAM:
        {
            _filter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
        }
            break;
        case GPUIMAGE_THRESHOLD:
        {
            _filter = [[GPUImageLuminanceThresholdFilter alloc] init];
            [(GPUImageLuminanceThresholdFilter *)_filter setThreshold:0.34];
            
        }
            break;
        case GPUIMAGE_ADAPTIVETHRESHOLD:
        {
            _filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        }
            break;
        case GPUIMAGE_CROP:
        {
            _filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
        }
            break;
        case GPUIMAGE_MASK:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageMaskFilter alloc] init];
            
            [(GPUImageFilter*)_filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
        }
            break;
        case GPUIMAGE_TRANSFORM:
        {
            _filter = [[GPUImageTransformFilter alloc] init];
            [(GPUImageTransformFilter *)_filter setAffineTransform:CGAffineTransformMakeRotation(2.0)];
            //            [(GPUImageTransformFilter *)_filter setIgnoreAspectRatio:YES];
        }
            break;
        case GPUIMAGE_TRANSFORM3D:
        {
            _filter = [[GPUImageTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *)_filter setTransform3D:perspectiveTransform];
        }
            break;
        case GPUIMAGE_SOBELEDGEDETECTION:
        {
            _filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
        }
            break;
        case GPUIMAGE_XYGRADIENT:
        {
            _filter = [[GPUImageXYDerivativeFilter alloc] init];
        }
            break;
        case GPUIMAGE_HARRISCORNERDETECTION:
        {
            _filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
            [(GPUImageHarrisCornerDetectionFilter *)_filter setThreshold:0.20];
        }
            break;
        case GPUIMAGE_PREWITTEDGEDETECTION:
        {
            _filter = [[GPUImagePrewittEdgeDetectionFilter alloc] init];
        }
            break;
        case GPUIMAGE_CANNYEDGEDETECTION:
        {
            _filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
            [(GPUImageCannyEdgeDetectionFilter *)_filter setBlurRadiusInPixels:0.5];
        }
            break;
        case GPUIMAGE_SKETCH:
        {
            _filter = [[GPUImageSketchFilter alloc] init];
        }
            break;
        case GPUIMAGE_TOON:
        {
            _filter = [[GPUImageToonFilter alloc] init];
        }
            break;
        case GPUIMAGE_SMOOTHTOON:
        {
            _filter = [[GPUImageSmoothToonFilter alloc] init];
        }
            break;
        case GPUIMAGE_TILTSHIFT:
        {
            _filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter *)_filter setTopFocusLevel:0.4];
            [(GPUImageTiltShiftFilter *)_filter setBottomFocusLevel:0.6];
            [(GPUImageTiltShiftFilter *)_filter setFocusFallOffRate:0.2];
            
        }
            break;
        case GPUIMAGE_CGA:
        {
            _filter = [[GPUImageCGAColorspaceFilter alloc] init];
        }
            break;
        case GPUIMAGE_CONVOLUTION:
        {
            _filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            //            [(GPUImage3x3ConvolutionFilter *)_filter setConvolutionKernel:(GPUMatrix3x3){
            //                {-2.0f, -1.0f, 0.0f},
            //                {-1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 2.0f}
            //            }];
            [(GPUImage3x3ConvolutionFilter *)_filter setConvolutionKernel:(GPUMatrix3x3){
                {-1.0f,  0.0f, 1.0f},
                {-2.0f, 0.0f, 2.0f},
                {-1.0f,  0.0f, 1.0f}
            }];
            
            //            [(GPUImage3x3ConvolutionFilter *)_filter setConvolutionKernel:(GPUMatrix3x3){
            //                {1.0f,  1.0f, 1.0f},
            //                {1.0f, -8.0f, 1.0f},
            //                {1.0f,  1.0f, 1.0f}
            //            }];
            //            [(GPUImage3x3ConvolutionFilter *)_filter setConvolutionKernel:(GPUMatrix3x3){
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f},
            //                { 0.11f,  0.11f, 0.11f}
            //            }];
        }
            break;
        case GPUIMAGE_EMBOSS:
        {
            _filter = [[GPUImageEmbossFilter alloc] init];
            [(GPUImageEmbossFilter *)_filter setIntensity:2.98];
            
        }
            break;
        case GPUIMAGE_POSTERIZE:
        {
            _filter = [[GPUImagePosterizeFilter alloc] init];
            [(GPUImagePosterizeFilter *)_filter setColorLevels:round(2.2375)];
            
        }
            break;
        case GPUIMAGE_SWIRL:
        {
            _filter = [[GPUImageSwirlFilter alloc] init];
        }
            break;
        case GPUIMAGE_BULGE:
        {
            _filter = [[GPUImageBulgeDistortionFilter alloc] init];
        }
            break;
        case GPUIMAGE_PINCH:
        {
            _filter = [[GPUImagePinchDistortionFilter alloc] init];
            [(GPUImagePinchDistortionFilter *)_filter setScale:1.8f];
        }
            break;
        case GPUIMAGE_STRETCH:
        {
            _filter = [[GPUImageStretchDistortionFilter alloc] init];
        }
            break;
        case GPUIMAGE_PERLINNOISE:
        {
            _filter = [[GPUImagePerlinNoiseFilter alloc] init];
        }
            break;
        case GPUIMAGE_VORONI:
        {
            GPUImageJFAVoronoiFilter *jfa = [[GPUImageJFAVoronoiFilter alloc] init];
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            _sourcePicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"voroni_points2.png"]];
            
            [_sourcePicture addTarget:jfa];
            
            _filter = [[GPUImageVoronoiConsumerFilter alloc] init];
            
            [jfa setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            [(GPUImageVoronoiConsumerFilter *)_filter setSizeInPixels:CGSizeMake(1024.0, 1024.0)];
            
            [_stillCamera addTarget:_filter];
            [jfa addTarget:_filter];
            [_sourcePicture processImage];
        }
            break;
        case GPUIMAGE_MOSAIC:
        {
            _filter = [[GPUImageMosaicFilter alloc] init];
            [(GPUImageMosaicFilter *)_filter setTileSet:@"squares.png"];
            [(GPUImageMosaicFilter *)_filter setColorOn:NO];
            [(GPUImageMosaicFilter *)_filter setDisplayTileSize:CGSizeMake(0.012483, 0.012483)];//0.02-0.5
            
            //[(GPUImageMosaicFilter *)_filter setTileSet:@"dotletterstiles.png"];
            //[(GPUImageMosaicFilter *)_filter setTileSet:@"curvies.png"];
            
            [_filter setInputRotation:kGPUImageRotateRight atIndex:0];
            
        }
            break;
        case GPUIMAGE_CHROMAKEY:
        {
            needsSecondImage = YES;
            _filter = [[GPUImageChromaKeyBlendFilter alloc] init];
            [(GPUImageChromaKeyBlendFilter *)_filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
        }
            break;
        case GPUIMAGE_MULTIPLY:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageMultiplyBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_OVERLAY:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageOverlayBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_LIGHTEN:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageLightenBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_DARKEN:
        {
            needsSecondImage = YES;
            _filter = [[GPUImageDarkenBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_DISSOLVE:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageDissolveBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_SCREENBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageScreenBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_COLORBURN:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageColorBurnBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_COLORDODGE:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageColorDodgeBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_EXCLUSIONBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageExclusionBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_DIFFERENCEBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageDifferenceBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_SUBTRACTBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageSubtractBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_HARDLIGHTBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageHardLightBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_SOFTLIGHTBLEND:
        {
            needsSecondImage = YES;
            
            _filter = [[GPUImageSoftLightBlendFilter alloc] init];
        }
            break;
        case GPUIMAGE_CUSTOM:
        {
            _filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
        }
            break;
        case GPUIMAGE_CUSTOM2:
        {
            _filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter2"];
        }
            break;
        case GPUIMAGE_KUWAHARA:
        {
            _filter = [[GPUImageKuwaharaFilter alloc] init];
        }
            break;
            
        case GPUIMAGE_VIGNETTE:
        {
            _filter = [[GPUImageVignetteFilter alloc] init];
            [(GPUImageVignetteFilter *)_filter setVignetteEnd:0.5];
        }
            break;
        case GPUIMAGE_GAUSSIAN:
        {
            _filter = [[GPUImageGaussianBlurFilter alloc] init];
        }
            break;
        case GPUIMAGE_FASTBLUR:
        {
            _filter = [[GPUImageGaussianBlurFilter alloc] init];
        }
            break;
        case GPUIMAGE_BOXBLUR:
        {
            _filter = [[GPUImageBoxBlurFilter alloc] init];
        }
            break;
        case GPUIMAGE_MEDIAN:
        {
            _filter = [[GPUImageMedianFilter alloc] init];
        }
            break;
        case GPUIMAGE_GAUSSIAN_SELECTIVE:
        {
            _filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
            [(GPUImageGaussianSelectiveBlurFilter*)_filter setExcludeCircleRadius:40.0/320.0];
        }
            break;
        case GPUIMAGE_BILATERAL:
        {
            _filter = [[GPUImageBilateralFilter alloc] init];
        }
            break;
        case GPUIMAGE_FILTERGROUP:
        {
            _filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageFilterGroup *)_filter addFilter:sepiaFilter];
            
            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImageFilterGroup *)_filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(GPUImageFilterGroup *)_filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(GPUImageFilterGroup *)_filter setTerminalFilter:pixellateFilter];
        }
            break;
        case GPUIMAGE_EROSION:
        {
            _filter = [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
        }
            break;
        case GPUIMAGE_CLOSING:
        {
            _filter = [[GPUImageRGBClosingFilter alloc] initWithRadius:4];
        }
            break;
        case GPUIMAGE_OPENING:
        {
            _filter = [[GPUImageRGBOpeningFilter alloc] initWithRadius:4];
        }
            break;
        case GPUIMAGE_SOFTELEGANCE:
        {
            _filter = [[GPUImageSoftEleganceFilter alloc] init];
        }
            break;
        case GPUIMAGE_MISSETIKATE:
        {
            _filter = [[GPUImageMissEtikateFilter alloc] init];
        }
            break;
        case GPUIMAGE_AMATORKA:
        {
            _filter = [[GPUImageAmatorkaFilter alloc] init];
        }
            break;
        case GPUIMAGE_DILATION:
        {
            _filter = [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
        }
            break;
        case GPUIMAGE_HIGHPASS:
        {
            _filter = [[GPUImageHighPassFilter alloc] init];
            [(GPUImageHighPassFilter *)_filter setFilterStrength:1.0];
        }
            break;
        case GPUIMAGE_LOWPASS:
        {
            _filter = [[GPUImageLowPassFilter alloc] init];
            [(GPUImageLowPassFilter *)_filter setFilterStrength:0.5];
        }
            break;
            
        default:
            _filter = [[GPUImageSepiaFilter alloc] init];
            break;
    }
    
    if (videoFilterType == GPUIMAGE_FILECONFIG) {
        //self.title = @"File Configuration";
        _pipeline = [[GPUImageFilterPipeline alloc] initWithConfigurationFile:[[NSBundle mainBundle] URLForResource:@"SampleConfiguration" withExtension:@"plist"]
                                                                       input:_stillCamera output:(GPUImageView*)self];
        
        //        [pipeline addFilter:rotationFilter atIndex:0];
    }
    else {
        
        if (videoFilterType != GPUIMAGE_VORONI) {
            //[_filter prepareForImageCapture];
            [_stillCamera addTarget:_filter];
        }
        
        _stillCamera.runBenchmark = NO;
        
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
            
            
            _sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
            [_sourcePicture addTarget:_filter];
            
            [_sourcePicture processImage];
            
        }
        
        GPUImageView *filterView = (GPUImageView *)self;
        
        if (videoFilterType == GPUIMAGE_HISTOGRAM) {
            // I'm adding an intermediary filter because glReadPixels() requires something to be rendered for its glReadPixels() operation to work
            [_stillCamera removeTarget:_filter];
            GPUImageGammaFilter *gammaFilter = [[GPUImageGammaFilter alloc] init];
            [_stillCamera addTarget:gammaFilter];
            [gammaFilter addTarget:_filter];
            
            GPUImageHistogramGenerator *histogramGraph = [[GPUImageHistogramGenerator alloc] init];
            
            [histogramGraph forceProcessingAtSize:CGSizeMake(256.0, 330.0)];
            [_filter addTarget:histogramGraph];
            
            GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
            blendFilter.mix = 0.75;
            
            [_stillCamera addTarget:blendFilter];
            [histogramGraph addTarget:blendFilter];
            _stillCamera.targetToIgnoreForUpdates = blendFilter; // Avoid double-updating the blend
            
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
            [_stillCamera addTarget:gammaFilter];
            [gammaFilter addTarget:blendFilter];
            gammaFilter.targetToIgnoreForUpdates = blendFilter;
            
            [crosshairGenerator addTarget:blendFilter];
            
            [blendFilter addTarget:filterView];
            //[blendFilter addTarget:movieWriter];
        }
        
        else {
            [_filter addTarget:filterView];
            //[_filter addTarget:movieWriter];
        }
    }
    
    [_stillCamera startCameraCapture];
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

#pragma mark - UIScrollViewDelegate methods

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
        
        //[t setNeedsDisplay];
    }
}

@end
