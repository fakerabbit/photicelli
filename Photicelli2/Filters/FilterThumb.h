//
//  FilterThumb.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/14/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IFilterThumbDelegate <NSObject>
-(void)onTouch:(kVideoFilterType)filterType withFilter:(NSString*)name;
@end

@interface FilterThumb : UIView {
@private
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UIView *_selectedView;
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, weak) id <IFilterThumbDelegate> delegate;

- (void)build;
- (void)setSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
