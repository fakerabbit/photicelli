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

@interface MenuView : UIView <CAAnimationDelegate> {
@private
    UIButton *_cameraBtn;
    UIButton *_libraryBtn;
    
    CAGradientLayer *gradient;
    NSMutableArray *gradientSet;
    NSInteger currentGradient;
    struct CGColor *colorOne;
    struct CGColor *colorTwo;
    struct CGColor *colorThree;
}

@property (nonatomic, weak) id <IMenuViewDelegate> delegate;

- (void)createGradientView;

@end

NS_ASSUME_NONNULL_END
