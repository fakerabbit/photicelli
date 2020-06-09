//
//  NavigationController.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/6/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "EditorController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NavigationController : UINavigationController {
@private
    ViewController *_menuController;
    EditorController *_editorController;
}

- (void)goToEditor:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
