//
//  FilterCell.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 7/24/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.layer.cornerRadius = kCameraViewFiltersScrollViewHeight/4;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor constant:0.0].active = YES;
        [_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor constant:0.0].active = YES;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [Theme cyanColor];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_nameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    }
    return self;
}

- (void)setType:(kVideoFilterType)type {
    _type = type;
    switch (_type) {
        case FILTER_BACK:
            _nameLabel.text = NSLocalizedString(@"<-", @"");
            break;
        case FILTER_EFFECTS:
            break;
        case FILTER_ENHANCE:
            break;
            
        default:
            break;
    }
    [_nameLabel sizeToFit];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _nameLabel.text = NSLocalizedString(_title, @"");
    [_nameLabel sizeToFit];
}

@end
