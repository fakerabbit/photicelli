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

@interface EditorView : UIView {
@private
    PhotoView *_photoView;
    UIView *test;
}

- (void)build:(UIImage*)image;

@end

NS_ASSUME_NONNULL_END
