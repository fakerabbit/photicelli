//
//  PhotoView.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoView : UIScrollView {
@private
    UIImage* _image;
    UIImage* _workingImage;
}

@property (nonatomic, retain) UIImageView *imageView;

-(void)loadImage:(UIImage*)photo;

@end

NS_ASSUME_NONNULL_END
