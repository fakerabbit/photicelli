//
//  EditorView.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IEditorViewDelegate <NSObject>
-(void)onGoBack;
@end

@interface EditorView : UIView <UIScrollViewDelegate> {
@private
    PhotoView *_photoView;
    UIView *test;
    /**
     * UI
     */
    UIButton *_cancelButton;
}

@property (nonatomic, weak) id <IEditorViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

- (void)build;

@end

NS_ASSUME_NONNULL_END
