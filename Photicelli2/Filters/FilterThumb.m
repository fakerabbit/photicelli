//
//  FilterThumb.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/14/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "FilterThumb.h"

@interface FilterThumb (IBActions)
-(IBAction)onTouch:(id)sender;
@end

@implementation FilterThumb

@synthesize delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.layer.cornerRadius = kCameraViewFiltersScrollViewHeight/4;
        _imageView.layer.masksToBounds = YES;
        [self addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        
        _selectedView = [[UIView alloc] initWithFrame:frame];
        _selectedView.layer.borderColor = [Theme cyanColor].CGColor;
        _selectedView.layer.borderWidth = 4;
        _selectedView.layer.cornerRadius = kCameraViewFiltersScrollViewHeight/4;
        _selectedView.hidden = YES;
        [self addSubview:_selectedView];
        _selectedView.translatesAutoresizingMaskIntoConstraints = NO;
        [_selectedView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_selectedView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;

        // Create the name label
        _nameLabel = [[UILabel alloc] initWithFrame: CGRectZero];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [Theme titleFontWithSize:18.f];
        _nameLabel.minimumScaleFactor = 8.f;
        [self addSubview:_nameLabel];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_nameLabel.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:15].active = YES;
        [_nameLabel.heightAnchor constraintEqualToConstant:30].active = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)setType:(NSString *)type {
    _type = type;
    [_nameLabel setText:type];
}

#pragma mark - Public Methods

- (void)build {
    [_imageView setImage: [UIImage imageNamed: [_type lowercaseString]]];
}

- (void)setSelected:(BOOL)selected {
    _selectedView.hidden = !selected;
}

#pragma mark - IBActions

- (IBAction)onTouch:(id)sender {
    kVideoFilterType fType = [Filters typeForFilter:_type];
    [delegate onTouch:fType withFilter:_type];
}

@end
