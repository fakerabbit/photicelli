//
//  MenuView.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMenuViewDelegate <NSObject>
-(void)onCamera;
-(void)onLibrary;
@end

@interface MenuView : UIView {
@private
    UIButton *_cameraBtn;
    UIButton *_libraryBtn;
}

@property (nonatomic, weak) id <IMenuViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
