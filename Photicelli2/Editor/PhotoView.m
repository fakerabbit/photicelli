//
//  PhotoView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        //NSLog(@"frame's width is smaller than bound's width...");
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    }
    else {
        //NSLog(@"frame's width is bigger or equal than bound's width...");
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        //NSLog(@"frame's height is smaller than bound's height...");
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    }
    else {
        //NSLog(@"frame's height is bigger or equal than bound's height...");
        frameToCenter.origin.y = 0;
    }
    
    _imageView.frame = frameToCenter;
}

- (void)loadImage:(UIImage *)photo {
    _image = [photo copy];
    _workingImage = _image;
    CGRect frame = self.frame;
    _imageView = [[UIImageView alloc] initWithFrame:frame];
    [_imageView setImage: _image];
    [_imageView sizeToFit];
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageView];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    CGSize screenSize = self.frame.size;
    CGFloat widthRatio = screenSize.width / _image.size.width;
    CGFloat heightRatio = screenSize.height / _image.size.height;
    CGFloat initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    self.minimumZoomScale = initialZoom;
    self.maximumZoomScale = 4.0;
    CGSize contentSize = CGSizeMake(_imageView.bounds.size.width, _imageView.bounds.size.height);
    [self setContentSize: contentSize];
    self.zoomScale = 0; //initialZoom;
}

@end
