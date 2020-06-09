//
//  CameraController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "CameraController.h"
#import "NavigationController.h"

@interface CameraController ()

@end

@implementation CameraController

- (void)loadView {
    [super loadView];
    _cameraView = [[CameraView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _cameraView.delegate = self;
    self.view = _cameraView;
    [_cameraView build];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _cameraView.iOrientation = [[UIDevice currentDevice] orientation];
    [_cameraView stopCapture:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_cameraView stopCapture:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    _cameraView.iOrientation = [[UIDevice currentDevice] orientation];
}

#pragma mark - ICameraViewDelegate methods

- (void)onGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTakePic:(UIImage *)pPhoto {
    NavigationController *navigationController = (NavigationController*) self.navigationController;
    [navigationController goToEditor:pPhoto];
}

@end
