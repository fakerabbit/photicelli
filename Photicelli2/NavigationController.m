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

#pragma mark - View Methods

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

#pragma mark - Navigation methods

- (void)goToEditor:(UIImage *)image {
    _editorController = [[EditorController alloc] init];
    _editorController.photo = image;
    [self popViewControllerAnimated:YES];
    [self pushViewController:_editorController animated:YES];
}

@end
