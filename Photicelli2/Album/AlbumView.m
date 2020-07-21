//
//  AlbumView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "AlbumView.h"
#import "AlbumCell.h"
#import "Theme.h"

@interface AlbumView (IBActions)
-(IBAction)onGoBack:(id)sender;
-(void)onUsePhoto:(id)sender;
@end

@implementation AlbumView

@synthesize delegate;

#define kAlbumViewBtnH 36.f
#define kAlbumViewTopPad 10.f
#define kAlbumViewCancelBtnW 80.f
#define kAlbumViewUsePhotoBtnW 120.f
#define kAlbumViewCVH 200.f

static NSString * const CellIdentifier = @"Cell";

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _fetchResult = [PHFetchResult new];
        _imageManager = [PHImageManager defaultManager];
        _previousPreheatRect = CGRectZero;
        _selectedIndex = 0;
        
        _imageView = [[UIImageView alloc] initWithFrame: CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview: _imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [_imageView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_imageView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundImage:[UIImage systemImageNamed:@"arrow.left"] forState:UIControlStateNormal];
        [_cancelButton setTintColor:[Theme cyanColor]];
        [_cancelButton addTarget:self action:@selector(onGoBack:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_cancelButton.widthAnchor constraintEqualToConstant:50].active = YES;
        [_cancelButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_cancelButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_cancelButton.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10.0].active = YES;
        
        _usePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_usePhotoButton setBackgroundImage:[UIImage systemImageNamed:@"checkmark.circle"] forState:UIControlStateNormal];
        [_usePhotoButton setTintColor:[Theme cyanColor]];
        [_usePhotoButton addTarget:self action:@selector(onUsePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_usePhotoButton];
        _usePhotoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_usePhotoButton.widthAnchor constraintEqualToConstant:50].active = YES;
        [_usePhotoButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_usePhotoButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_usePhotoButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(70, 70)];
        [_layout setScrollDirection: UICollectionViewScrollDirectionVertical];
        _layout.minimumInteritemSpacing = 2.0f;
        
        _photosCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _photosCV.delegate = self;
        _photosCV.dataSource = self;
        _photosCV.showsHorizontalScrollIndicator = NO;
        _photosCV.showsVerticalScrollIndicator = NO;
        _photosCV.alwaysBounceVertical = YES;
        _photosCV.backgroundColor = [Theme backgroundColor];
        [_photosCV registerClass:[AlbumCell class] forCellWithReuseIdentifier: CellIdentifier];
        [self addSubview:_photosCV];
        _photosCV.translatesAutoresizingMaskIntoConstraints = NO;
        [_photosCV.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_photosCV.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.5].active = YES;
        [_photosCV.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    }
    return self;
}

- (void)build {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = _layout.itemSize;
    _thumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO],
    ];
    _fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    [_photosCV reloadData];
    // Pick first asset by default
    PHAsset *asset = [_fetchResult objectAtIndex: 0];
    [_imageManager requestImageForAsset:asset targetSize:_imageView.bounds.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *image, NSDictionary *info) {
        [self->_imageView setImage: image];
    }];
}

#pragma mark - IBActions

- (IBAction)onGoBack:(id)sender {
    [delegate onGoBack];
}

- (IBAction)onUsePhoto:(id)sender {
    [delegate onUsePhoto: [_imageView.image copy]];
}

#pragma mark -
#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section { //Rows
    return [_fetchResult count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView { //Columns
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier forIndexPath:indexPath];
    PHAsset *asset = [_fetchResult objectAtIndex: indexPath.item];
    cell.representedAssetIdentifier = asset.localIdentifier;
    [_imageManager requestImageForAsset:asset targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *image, NSDictionary *info) {
        cell.photo = image;
        if (!self->_imageView.image) {
            self->_imageView.image = image;
        }
    }];
    
    return cell;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = indexPath.row;
    PHAsset *asset = [_fetchResult objectAtIndex: indexPath.item];
    [_imageManager requestImageForAsset:asset targetSize:_imageView.bounds.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *image, NSDictionary *info) {
        [self->_imageView setImage: image];
    }];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: CellIdentifier forIndexPath:indexPath];
    cell.selected = YES;
}

@end
