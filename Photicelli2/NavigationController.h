//
//  NavigationController.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/6/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NavigationController : UINavigationController {
@private
    ViewController *_menuController;
}

@end

NS_ASSUME_NONNULL_END
