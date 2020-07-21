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
-(IBAction)onShare:(id)sender;
@end

@implementation EditorView

@synthesize delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [_loading startAnimating];
        [self addSubview:_loading];
        _loading.translatesAutoresizingMaskIntoConstraints = NO;
        [_loading.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_loading.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
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
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage systemImageNamed:@"arrow.up.square"] forState:UIControlStateNormal];
        [_shareButton setTintColor:[Theme cyanColor]];
        [_shareButton addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_shareButton.widthAnchor constraintEqualToConstant:50].active = YES;
        [_shareButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_shareButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_shareButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
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

- (IBAction)onShare:(id)sender {
    [delegate onShare:_image];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoView.imageView;
}

@end
