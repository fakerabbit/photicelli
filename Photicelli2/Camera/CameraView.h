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

#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ICameraViewDelegate <NSObject>
-(void)onGoBack;
@end

@interface CameraView : GPUImageView {
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
    UIButton *_cancelButton;
}

@property (nonatomic, weak) id <ICameraViewDelegate> delegate;
@property (nonatomic) UIDeviceOrientation iOrientation;

- (void)build;
- (void)stopCapture:(BOOL)pStop;

@end

NS_ASSUME_NONNULL_END
