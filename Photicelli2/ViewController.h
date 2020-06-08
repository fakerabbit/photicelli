//
//  ViewController.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "CameraController.h"

@interface ViewController : UIViewController <IMenuViewDelegate> {
@private
    MenuView *_menuView;
    CameraController *_cameraController;
}


@end

