//
//  AlbumView.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IAlbumViewDelegate <NSObject>
-(void)onGoBack;
-(void)onUsePhoto:(UIImage*)photo;
@end

@interface AlbumView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
@private
    /**
     * UI
     */
    UIButton *_cancelButton;
    UIButton *_usePhotoButton;
    UIImageView *_imageView;
    UICollectionView *_photosCV;
    UICollectionViewFlowLayout *_layout;
    PHFetchResult *_fetchResult;
    PHImageManager *_imageManager;
    CGSize _thumbnailSize;
    CGRect _previousPreheatRect;
    NSInteger _selectedIndex;
}

@property (nonatomic, weak) id <IAlbumViewDelegate> delegate;

-(void)build;

@end

NS_ASSUME_NONNULL_END
