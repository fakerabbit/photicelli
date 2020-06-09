//
//  EditorView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "EditorView.h"
#import "Theme.h"

@implementation EditorView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _photoView = [[PhotoView alloc] initWithFrame:CGRectZero];
        //_photoView.delegate = self;
        _photoView.minimumZoomScale = 0.2f;
        _photoView.maximumZoomScale = 4.0;
        _photoView.zoomScale = 1.0f;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
        _photoView.translatesAutoresizingMaskIntoConstraints = NO;
        [_photoView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_photoView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        //[_photoView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        //[_photoView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        test = [[UIView alloc] initWithFrame:CGRectZero];
        test.backgroundColor = [UIColor redColor];
        //[self addSubview:test];
        //test.translatesAutoresizingMaskIntoConstraints = NO;
        //[test.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
        //[test.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
        //[test.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        //[test.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
    }
    return self;
}

- (void)build:(UIImage *)image {
    //_photoView.frame = self.frame;
    //_photoView.dataStore = _dataStore;
    [_photoView loadImage:image];
}

@end
