//
//  FilterCell.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 7/24/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filters.h"
#import "Theme.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterCell : UICollectionViewCell {
@private
    UILabel *_nameLabel;
    UIImageView* _imageView;
}

@property (nonatomic) kVideoFilterType type;
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
