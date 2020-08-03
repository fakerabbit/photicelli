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
-(void)onShare:(UIImage*)image;
@end

@interface EditorView : UIView <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource> {
@private
    PhotoView *_photoView;
    /**
     * UI
     */
    UIButton *_cancelButton;
    UIButton *_shareButton;
    UIActivityIndicatorView *_loading;
    UICollectionView *_filtersView;
    NSMutableArray *_filtersArray;
}

@property (nonatomic, weak) id <IEditorViewDelegate> delegate;
@property (nonatomic, strong) UIImage *image;

- (void)build;

@end

NS_ASSUME_NONNULL_END
