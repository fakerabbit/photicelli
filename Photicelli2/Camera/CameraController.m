//
//  CameraController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "CameraController.h"

@interface CameraController ()

@end

@implementation CameraController

- (void)loadView {
    [super loadView];
    _cameraView = [[CameraView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _cameraView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
