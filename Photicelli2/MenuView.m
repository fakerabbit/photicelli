//
//  MenuView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "MenuView.h"
#import "Theme.h"

@implementation MenuView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [Theme backgroundColor];
        
        // Create buttons
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setBackgroundImage:[UIImage systemImageNamed:@"camera"] forState:UIControlStateNormal];
        [_cameraBtn setTintColor:[Theme cyanColor]];
       //[_cameraBtn addTarget:self action:@selector(onCamera:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraBtn];
        _cameraBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_cameraBtn.widthAnchor constraintEqualToConstant:100].active = YES;
        [_cameraBtn.heightAnchor constraintEqualToConstant:80].active = YES;
        [_cameraBtn.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_cameraBtn.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:-40.0].active = YES;
        
        _libraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_libraryBtn setBackgroundImage:[UIImage systemImageNamed:@"folder"] forState:UIControlStateNormal];
        [_libraryBtn setTintColor:[Theme cyanColor]];
        //[_libraryBtn addTarget:self action:@selector(onRoll:) forControlEvents:UIControlEventTouchUpInside];
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

@end
