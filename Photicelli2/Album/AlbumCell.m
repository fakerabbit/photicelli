//
//  AlbumCell.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "AlbumCell.h"
#import "Theme.h"

@implementation AlbumCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame: frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview: _imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        _imageView.layer.borderColor = [Theme cyanColor].CGColor;
    }
    return self;
}

#pragma mark - Setup

- (void)setPhoto:(UIImage *)photo {
    _photo = photo;
    [_imageView setImage: _photo];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _imageView.layer.borderWidth = 2.0;
    } else {
        _imageView.layer.borderWidth = 0;
    }
}

@end
