//
//  AlbumCell.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCell : UICollectionViewCell {
@private
    UIImageView *_imageView;
}

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *representedAssetIdentifier;

@end

NS_ASSUME_NONNULL_END
