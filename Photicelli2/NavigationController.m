//
//  NavigationController.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/6/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menuController = [[ViewController alloc] init];
    [self setViewControllers:[NSArray arrayWithObject:_menuController] animated:NO];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

@end
