//
//  CameraView.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImageFramework.h>

#import "FilterThumb.h"
#import "Filters.h"
#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ICameraViewDelegate <NSObject>
-(void)onGoBack;
-(void)onTakePic:(UIImage*)pPhoto;
@end

@interface CameraView : GPUImageView <UIScrollViewDelegate, IFilterThumbDelegate> {
@private
    /**
     * GPUImage
     */
    GPUImageStillCamera *_stillCamera;
    kVideoFilterType _filterType;
    GPUImageOutput<GPUImageInput> *_filter;
    GPUImagePicture *_sourcePicture;
    GPUImageFilterPipeline *_pipeline;
    /**
     * UI
     */
    UIActivityIndicatorView *_loading;
    UIButton *_cancelButton;
    UIButton *_flipCameraButton;
    BOOL _frontCamera;
    BOOL _cameraReady;
    UIButton *_takePictureButton;
    UIScrollView *_filtersSV;
    NSArray *_filtersArray;
}

@property (nonatomic, weak) id <ICameraViewDelegate> delegate;
@property (nonatomic) UIDeviceOrientation iOrientation;

- (void)build;
- (void)stopCapture:(BOOL)pStop;

@end

NS_ASSUME_NONNULL_END
