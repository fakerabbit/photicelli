//
//  MenuView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "MenuView.h"
#import "Theme.h"

@interface MenuView (IBActions)
-(IBAction)onCamera:(id)sender;
-(IBAction)onLibrary:(id)sender;
@end

@implementation MenuView

@synthesize delegate;

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [Theme backgroundColor];
        gradient = [[CAGradientLayer alloc] init];
        gradientSet = [NSMutableArray array];
        currentGradient = 0;
        colorOne = [UIColor redColor].CGColor;
        colorTwo = [UIColor blueColor].CGColor;
        colorThree = [UIColor greenColor].CGColor;
        
        // Create buttons
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setBackgroundImage:[UIImage systemImageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraBtn setTintColor:[Theme whiteColor]];
        [_cameraBtn addTarget:self action:@selector(onCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraBtn];
        _cameraBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_cameraBtn.widthAnchor constraintEqualToConstant:100].active = YES;
        [_cameraBtn.heightAnchor constraintEqualToConstant:80].active = YES;
        [_cameraBtn.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_cameraBtn.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-40.0].active = YES;
        
        _libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_libraryBtn setBackgroundImage:[UIImage systemImageNamed:@"folder"] forState:UIControlStateNormal];
        [_libraryBtn setTintColor:[Theme whiteColor]];
        [_libraryBtn addTarget:self action:@selector(onLibrary:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_libraryBtn];
        _libraryBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_libraryBtn.widthAnchor constraintEqualToConstant:100].active = YES;
        [_libraryBtn.heightAnchor constraintEqualToConstant:80].active = YES;
        [_libraryBtn.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_libraryBtn.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:80.0].active = YES;
        
        UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:kImageLogo]];
        [self addSubview:logo];
        logo.translatesAutoresizingMaskIntoConstraints = NO;
        [logo.widthAnchor constraintEqualToConstant:240].active = YES;
        [logo.heightAnchor constraintEqualToConstant:140].active = YES;
        [logo.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    }
    
    return self;
}

- (void)createGradientView {
    [gradientSet addObject: [NSArray arrayWithObjects: (__bridge id)colorOne, (__bridge id)colorTwo, nil]];
    [gradientSet addObject: [NSArray arrayWithObjects: (__bridge id)colorTwo, (__bridge id)colorThree, nil]];
    [gradientSet addObject: [NSArray arrayWithObjects: (__bridge id)colorThree, (__bridge id)colorOne, nil]];
    gradient.frame = self.bounds;
    gradient.colors = gradientSet[currentGradient];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    gradient.drawsAsynchronously = YES;
    [self.layer insertSublayer:gradient atIndex:0];
    [self animateGradient];
}

- (void)animateGradient {
    if (currentGradient < (gradientSet.count - 1)) {
        currentGradient += 1;
    } else {
        currentGradient = 0;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.duration = 3;
    animation.toValue = gradientSet[currentGradient];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [gradient addAnimation:animation forKey:@"gradientAnimation"];
}

#pragma mark - IBActions

- (IBAction)onCamera:(id)sender {
    [delegate onCamera];
}

-(IBAction)onLibrary:(id)sender {
    [delegate onLibrary];
}

#pragma mark - CAAnimationDelegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        gradient.colors = gradientSet[currentGradient];
        [self animateGradient];
    }
}

@end
