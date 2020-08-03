//
//  Filters.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 8/3/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "Filters.h"

@implementation Filters

/**
 * Returns the kVideoFilterType  for a given name string.
 */
+ (kVideoFilterType)typeForFilter:(NSString*)name {
    kVideoFilterType type = FILTER_NONE;
    NSString *lowecaseName = [name lowercaseString];
    
    if ([lowecaseName isEqualToString:@"miya"])
        type = GPUIMAGE_THRESHOLD;
    else if ([lowecaseName isEqualToString:@"akira"])
        type = GPUIMAGE_SOBELEDGEDETECTION;
    else if ([lowecaseName isEqualToString:@"vinci"])
        type = GPUIMAGE_SKETCH;
    else if ([lowecaseName isEqualToString:@"walt"])
        type = GPUIMAGE_TOON;
    else if ([lowecaseName isEqualToString:@"amiga"])
        type = GPUIMAGE_CGA;
    else if ([lowecaseName isEqualToString:@"goethe"])
        type = GPUIMAGE_PINCH;
    else if ([lowecaseName isEqualToString:@"quino"])
        type = GPUIMAGE_EROSION;
    else if ([lowecaseName isEqualToString:@"victoria"])
        type = GPUIMAGE_CUSTOM;
    else if ([lowecaseName isEqualToString:@"rose"])
        type = GPUIMAGE_AMATORKA;
    else if ([lowecaseName isEqualToString:@"missetikate"])
        type = GPUIMAGE_MISSETIKATE;
    else if ([lowecaseName isEqualToString:@"burton"])
        type = GPUIMAGE_SOFTELEGANCE;
    else if ([lowecaseName isEqualToString:@"giger"])
        type = GPUIMAGE_CUSTOM2;
    else if ([lowecaseName isEqualToString:@"invertor"])
        type = GPUIMAGE_COLORINVERT;
    else if ([lowecaseName isEqualToString:@"smooth"])
        type = GPUIMAGE_SMOOTH;
    else if ([lowecaseName isEqualToString:@"back"])
        type = FILTER_BACK;
    
    
    return type;
}

/**
 * Allocate the filter according to the kVideoFilterType.
*/
+ (GPUImageOutput<GPUImageInput>*)initializeFilter:(kVideoFilterType)type {
    switch (type) {
        case GPUIMAGE_SEPIA:
            return [[GPUImageSepiaFilter alloc] init];
        case GPUIMAGE_PIXELLATE:
            return [[GPUImagePixellateFilter alloc] init];
        case GPUIMAGE_POLARPIXELLATE:
            return [[GPUImagePolarPixellateFilter alloc] init];
        case GPUIMAGE_CROSSHATCH: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageCrosshatchFilter alloc] init];
            [(GPUImageCrosshatchFilter *) filter setCrossHatchSpacing:0.01];
            return filter;
        }
        case GPUIMAGE_COLORINVERT:
            return [[GPUImageColorInvertFilter alloc] init];
        case GPUIMAGE_GRAYSCALE:
            return [[GPUImageGrayscaleFilter alloc] init];
        case GPUIMAGE_SATURATION:
            return [[GPUImageSaturationFilter alloc] init];
        case GPUIMAGE_CONTRAST:
            return [[GPUImageContrastFilter alloc] init];
        case GPUIMAGE_BRIGHTNESS:
            return [[GPUImageBrightnessFilter alloc] init];
        case GPUIMAGE_RGB:
            return [[GPUImageRGBFilter alloc] init];
        case GPUIMAGE_EXPOSURE: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageExposureFilter alloc] init];
            [(GPUImageExposureFilter *) filter setExposure:2.467];
            return filter;
        }
            break;
        case GPUIMAGE_SHARPEN:
            return [[GPUImageSharpenFilter alloc] init];
        case GPUIMAGE_UNSHARPMASK:
            return [[GPUImageUnsharpMaskFilter alloc] init];
            //[(GPUImageUnsharpMaskFilter *)_filter setIntensity:3.0];
        case GPUIMAGE_GAMMA:
            return [[GPUImageGammaFilter alloc] init];
        case GPUIMAGE_TONECURVE: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageToneCurveFilter alloc] init];
            [(GPUImageToneCurveFilter *) filter setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
            return filter;
        }
        case GPUIMAGE_HAZE:
            return [[GPUImageHazeFilter alloc] init];
        case GPUIMAGE_HISTOGRAM:
            return [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRGB];
        case GPUIMAGE_THRESHOLD: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageLuminanceThresholdFilter alloc] init];
            [(GPUImageLuminanceThresholdFilter *) filter setThreshold:0.34];
            return filter;
        }
        case GPUIMAGE_ADAPTIVETHRESHOLD:
            return [[GPUImageAdaptiveThresholdFilter alloc] init];
        case GPUIMAGE_CROP:
            return [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 0.0, 1.0, 0.25)];
        case GPUIMAGE_MASK: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageMaskFilter alloc] init];
            [(GPUImageFilter*) filter setBackgroundColorRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            return filter;
        }
        case GPUIMAGE_TRANSFORM: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageTransformFilter alloc] init];
            [(GPUImageTransformFilter *) filter setAffineTransform:CGAffineTransformMakeRotation(2.0)];
            //            [(GPUImageTransformFilter *)_filter setIgnoreAspectRatio:YES];
            return filter;
        }
            break;
        case GPUIMAGE_TRANSFORM3D: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageTransformFilter alloc] init];
            CATransform3D perspectiveTransform = CATransform3DIdentity;
            perspectiveTransform.m34 = 0.4;
            perspectiveTransform.m33 = 0.4;
            perspectiveTransform = CATransform3DScale(perspectiveTransform, 0.75, 0.75, 0.75);
            perspectiveTransform = CATransform3DRotate(perspectiveTransform, 0.75, 0.0, 1.0, 0.0);
            
            [(GPUImageTransformFilter *) filter setTransform3D:perspectiveTransform];
            return filter;
        }
            break;
        case GPUIMAGE_SOBELEDGEDETECTION:
            return [[GPUImageSobelEdgeDetectionFilter alloc] init];
        case GPUIMAGE_XYGRADIENT:
            return [[GPUImageXYDerivativeFilter alloc] init];
        case GPUIMAGE_HARRISCORNERDETECTION: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
            [(GPUImageHarrisCornerDetectionFilter *) filter setThreshold:0.20];
            return filter;
        }
        case GPUIMAGE_PREWITTEDGEDETECTION:
            return [[GPUImagePrewittEdgeDetectionFilter alloc] init];
        case GPUIMAGE_CANNYEDGEDETECTION: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageCannyEdgeDetectionFilter alloc] init];
            [(GPUImageCannyEdgeDetectionFilter *) filter setBlurRadiusInPixels:0.5];
            return filter;
        }
        case GPUIMAGE_SKETCH:
            return [[GPUImageSketchFilter alloc] init];
        case GPUIMAGE_TOON:
            return [[GPUImageToonFilter alloc] init];
        case GPUIMAGE_SMOOTHTOON:
            return [[GPUImageSmoothToonFilter alloc] init];
        case GPUIMAGE_TILTSHIFT: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter *) filter setTopFocusLevel:0.4];
            [(GPUImageTiltShiftFilter *) filter setBottomFocusLevel:0.6];
            [(GPUImageTiltShiftFilter *) filter setFocusFallOffRate:0.2];
            return filter;
        }
        case GPUIMAGE_CGA:
            return [[GPUImageCGAColorspaceFilter alloc] init];
        case GPUIMAGE_CONVOLUTION: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            //            [(GPUImage3x3ConvolutionFilter *)_filter setConvolutionKernel:(GPUMatrix3x3){
            //                {-2.0f, -1.0f, 0.0f},
            //                {-1.0f,  1.0f, 1.0f},
            //                { 0.0f,  1.0f, 2.0f}
            //            }];
            [(GPUImage3x3ConvolutionFilter *) filter setConvolutionKernel:(GPUMatrix3x3){
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
            return filter;
        }
        case GPUIMAGE_EMBOSS: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageEmbossFilter alloc] init];
            [(GPUImageEmbossFilter *) filter setIntensity:2.98];
            return filter;
        }
        case GPUIMAGE_POSTERIZE: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImagePosterizeFilter alloc] init];
            [(GPUImagePosterizeFilter *) filter setColorLevels:round(2.2375)];
            return filter;
        }
        case GPUIMAGE_SWIRL:
            return [[GPUImageSwirlFilter alloc] init];
        case GPUIMAGE_BULGE:
            return [[GPUImageBulgeDistortionFilter alloc] init];
        case GPUIMAGE_PINCH: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImagePinchDistortionFilter alloc] init];
            [(GPUImagePinchDistortionFilter *) filter setScale:1.8f];
            return filter;
        }
        case GPUIMAGE_STRETCH:
            return [[GPUImageStretchDistortionFilter alloc] init];
        case GPUIMAGE_PERLINNOISE:
            return [[GPUImagePerlinNoiseFilter alloc] init];
        case GPUIMAGE_MOSAIC: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageMosaicFilter alloc] init];
            [(GPUImageMosaicFilter *) filter setTileSet:@"squares.png"];
            [(GPUImageMosaicFilter *) filter setColorOn:NO];
            [(GPUImageMosaicFilter *) filter setDisplayTileSize:CGSizeMake(0.012483, 0.012483)];//0.02-0.5
            
            //[(GPUImageMosaicFilter *)_filter setTileSet:@"dotletterstiles.png"];
            //[(GPUImageMosaicFilter *)_filter setTileSet:@"curvies.png"];
            
            [filter setInputRotation:kGPUImageRotateRight atIndex:0];
            return filter;
        }
        case GPUIMAGE_CHROMAKEY: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageChromaKeyBlendFilter alloc] init];
            [(GPUImageChromaKeyBlendFilter *) filter setColorToReplaceRed:0.0 green:1.0 blue:0.0];
            return filter;
        }
        case GPUIMAGE_MULTIPLY:
            return [[GPUImageMultiplyBlendFilter alloc] init];
        case GPUIMAGE_OVERLAY:
            return [[GPUImageOverlayBlendFilter alloc] init];
        case GPUIMAGE_LIGHTEN:
            return [[GPUImageLightenBlendFilter alloc] init];
        case GPUIMAGE_DARKEN:
            return [[GPUImageDarkenBlendFilter alloc] init];
        case GPUIMAGE_DISSOLVE:
            return [[GPUImageDissolveBlendFilter alloc] init];
        case GPUIMAGE_SCREENBLEND:
            return [[GPUImageScreenBlendFilter alloc] init];
        case GPUIMAGE_COLORBURN:
            return [[GPUImageColorBurnBlendFilter alloc] init];
        case GPUIMAGE_COLORDODGE:
            return [[GPUImageColorDodgeBlendFilter alloc] init];
        case GPUIMAGE_EXCLUSIONBLEND:
            return [[GPUImageExclusionBlendFilter alloc] init];
        case GPUIMAGE_DIFFERENCEBLEND:
            return [[GPUImageDifferenceBlendFilter alloc] init];
        case GPUIMAGE_SUBTRACTBLEND:
            return [[GPUImageSubtractBlendFilter alloc] init];
        case GPUIMAGE_HARDLIGHTBLEND:
            return [[GPUImageHardLightBlendFilter alloc] init];
        case GPUIMAGE_SOFTLIGHTBLEND:
            return [[GPUImageSoftLightBlendFilter alloc] init];
        case GPUIMAGE_CUSTOM:
            return [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter"];
        case GPUIMAGE_CUSTOM2:
            return [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomFilter2"];
        case GPUIMAGE_KUWAHARA:
            return [[GPUImageKuwaharaFilter alloc] init];
        case GPUIMAGE_VIGNETTE: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageVignetteFilter alloc] init];
            [(GPUImageVignetteFilter *) filter setVignetteEnd:0.5];
            return filter;
        }
        case GPUIMAGE_GAUSSIAN:
            return [[GPUImageGaussianBlurFilter alloc] init];
        case GPUIMAGE_FASTBLUR:
            return [[GPUImageGaussianBlurFilter alloc] init];
        case GPUIMAGE_BOXBLUR:
            return [[GPUImageBoxBlurFilter alloc] init];
        case GPUIMAGE_MEDIAN:
            return [[GPUImageMedianFilter alloc] init];
        case GPUIMAGE_GAUSSIAN_SELECTIVE: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageGaussianSelectiveBlurFilter alloc] init];
            [(GPUImageGaussianSelectiveBlurFilter*) filter setExcludeCircleRadius:40.0/320.0];
            return filter;
        }
        case GPUIMAGE_BILATERAL:
            return [[GPUImageBilateralFilter alloc] init];
        case GPUIMAGE_FILTERGROUP: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageFilterGroup alloc] init];
            
            GPUImageSepiaFilter *sepiaFilter = [[GPUImageSepiaFilter alloc] init];
            [(GPUImageFilterGroup *) filter addFilter:sepiaFilter];
            
            GPUImagePixellateFilter *pixellateFilter = [[GPUImagePixellateFilter alloc] init];
            [(GPUImageFilterGroup *) filter addFilter:pixellateFilter];
            
            [sepiaFilter addTarget:pixellateFilter];
            [(GPUImageFilterGroup *) filter setInitialFilters:[NSArray arrayWithObject:sepiaFilter]];
            [(GPUImageFilterGroup *) filter setTerminalFilter:pixellateFilter];
            return filter;
        }
        case GPUIMAGE_EROSION:
            return [[GPUImageRGBErosionFilter alloc] initWithRadius:4];
        case GPUIMAGE_CLOSING:
            return [[GPUImageRGBClosingFilter alloc] initWithRadius:4];
        case GPUIMAGE_OPENING:
            return [[GPUImageRGBOpeningFilter alloc] initWithRadius:4];
        case GPUIMAGE_SOFTELEGANCE:
            return [[GPUImageSoftEleganceFilter alloc] init];
        case GPUIMAGE_MISSETIKATE:
            return [[GPUImageMissEtikateFilter alloc] init];
        case GPUIMAGE_AMATORKA:
            return [[GPUImageAmatorkaFilter alloc] init];
        case GPUIMAGE_DILATION:
            return [[GPUImageRGBDilationFilter alloc] initWithRadius:4];
        case GPUIMAGE_HIGHPASS: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageHighPassFilter alloc] init];
            [(GPUImageHighPassFilter *) filter setFilterStrength:1.0];
            return filter;
        }
        case GPUIMAGE_LOWPASS: {
            GPUImageOutput<GPUImageInput>* filter = [[GPUImageLowPassFilter alloc] init];
            [(GPUImageLowPassFilter *) filter setFilterStrength:0.5];
            return filter;
        }
        case GPUIMAGE_SMOOTH:
            return [[GPUImageSkinSmooth alloc] init];
        default:
            return [[GPUImageFilter alloc] init];
    }
}

@end
