//
//  ViewController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View methods

- (void)loadView {
    [super loadView];
    _menuView = [[MenuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _menuView.delegate = self;
    self.view = _menuView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MenuView Delegate methods

- (void)onCamera {
    _cameraController = [[CameraController alloc] init];
    [self.navigationController pushViewController:self->_cameraController animated:YES];
}

- (void)onLibrary {
}

@end
