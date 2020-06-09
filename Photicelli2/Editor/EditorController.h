//
//  EditorController.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditorController : UIViewController {
@private
    EditorView *_editorView;
}

@property (nonatomic, retain) UIImage *photo;

@end

NS_ASSUME_NONNULL_END
