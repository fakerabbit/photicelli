//
//  AlbumController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "AlbumController.h"
#import "NavigationController.h"

@interface AlbumController ()

@end

@implementation AlbumController

#pragma mark - View methods

- (void)loadView {
    [super loadView];
    _albumView = [[AlbumView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _albumView.delegate = self;
    self.view = _albumView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_albumView build];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - IAlbumViewDelegate methods

- (void)onGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onUsePhoto:(UIImage *)photo {
    NavigationController *navigationController = (NavigationController*) self.navigationController;
    [navigationController goToEditor:photo];
}

@end
