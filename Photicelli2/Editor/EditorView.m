//
//  EditorView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "EditorView.h"
#import "Theme.h"

@interface EditorView (IBActions)
-(IBAction)onGoBack:(id)sender;
@end

@implementation EditorView

@synthesize delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _photoView = [[PhotoView alloc] initWithFrame:CGRectZero];
        _photoView.delegate = self;
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
    }
    return self;
}

- (void)build {
    //_photoView.frame = self.frame;
    //_photoView.dataStore = _dataStore;
    [_photoView loadImage:_image];
}

#pragma mark - IBActions

- (IBAction)onGoBack:(id)sender {
    [delegate onGoBack];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoView.imageView;
}

@end
