//
//  EditorView.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/8/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "EditorView.h"
#import "Theme.h"
#import "FilterCell.h"

@interface EditorView (IBActions)
-(IBAction)onGoBack:(id)sender;
-(IBAction)onShare:(id)sender;
@end

@implementation EditorView

@synthesize delegate;

static NSString * const CellIdentifier = @"Cell";
static NSString * const Type = @"type";
static NSString * const Name = @"title";
static NSString * const Back = @"Back";

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [Theme backgroundColor];
        
        _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
        [_loading startAnimating];
        [self addSubview:_loading];
        _loading.translatesAutoresizingMaskIntoConstraints = NO;
        [_loading.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [_loading.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        
        _photoView = [[PhotoView alloc] initWithFrame:CGRectZero];
        _photoView.delegate = self;
        _photoView.minimumZoomScale = 0.2f;
        _photoView.maximumZoomScale = 4.0;
        _photoView.zoomScale = 1.0f;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
        _photoView.translatesAutoresizingMaskIntoConstraints = NO;
        [_photoView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_photoView.heightAnchor constraintEqualToAnchor:self.heightAnchor].active = YES;
        
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
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage systemImageNamed:@"arrow.up.square"] forState:UIControlStateNormal];
        [_shareButton setTintColor:[Theme cyanColor]];
        [_shareButton addTarget:self action:@selector(onShare:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_shareButton];
        _shareButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_shareButton.widthAnchor constraintEqualToConstant:50].active = YES;
        [_shareButton.heightAnchor constraintEqualToConstant:50].active = YES;
        [_shareButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:50.0].active = YES;
        [_shareButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = CGSizeMake(100, 80);
        layout.sectionInset = UIEdgeInsetsMake(2.0, 20.0, 20.0, 20.0);
        _filtersView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _filtersView.delegate = self;
        _filtersView.dataSource = self;
        _filtersView.backgroundColor = [UIColor clearColor];
        [_filtersView registerClass:[FilterCell class] forCellWithReuseIdentifier:CellIdentifier];
        [self addSubview:_filtersView];
        _filtersView.translatesAutoresizingMaskIntoConstraints = NO;
        [_filtersView.widthAnchor constraintEqualToAnchor:self.widthAnchor].active = YES;
        [_filtersView.heightAnchor constraintEqualToConstant:110].active = YES;
        [_filtersView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0.0].active = YES;
    }
    return self;
}

#pragma mark - Public Methods

- (void)build {
    //_photoView.frame = self.frame;
    //_photoView.dataStore = _dataStore;
    [_photoView loadImage:_image];
    [self setupFilters];
}

- (void)clearFilters {
    if ([_filtersArray count] > 0) {
        [_filtersArray removeAllObjects];
    }
    _filtersArray = nil;
    _filtersArray = [NSMutableArray array];
}

- (void)setupFilters {
    [self clearFilters];
    
    kVideoFilterType effects = FILTER_EFFECTS;
    kVideoFilterType enhance = FILTER_ENHANCE;
    NSDictionary *effectsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:effects], Type, @"Effects", Name, nil];
    NSDictionary *enhanceDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:enhance], Type, @"Enhance", Name, nil];
    [_filtersArray addObject: effectsDict];
    [_filtersArray addObject: enhanceDict];
    [_filtersView reloadData];
}

- (void)updateFilters:(NSInteger)index {
    NSDictionary *dict = [_filtersArray objectAtIndex:index];
    kVideoFilterType type = [[dict objectForKey:Type] intValue];
    switch (type) {
        case FILTER_EFFECTS:
            [self setupEffects];
            break;
        case FILTER_ENHANCE:
            [self setupEnhance];
            break;
            
        default:
            [self setupFilters];
            break;
    }
}

- (void)setupEffects {
    [self clearFilters];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CaptureFilters" ofType:@"plist"];
    NSDictionary *contentDictionary = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *filters = [NSArray arrayWithArray:[contentDictionary allKeys]];
    NSArray *names = [NSArray arrayWithArray:[contentDictionary allValues]];
    for (int i = 0; i < [filters count]; i++) {
        NSString *name = [names objectAtIndex:i];
        kVideoFilterType type = [Filters typeForFilter:name];
        if (type != FILTER_NONE) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type], Type, name, Name, nil];
            [_filtersArray addObject: dict];
        }
    }
    kVideoFilterType type = FILTER_BACK;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type], Type, Back, Name, nil];
    [_filtersArray insertObject:dict atIndex:0];
    [_filtersView reloadData];
}

- (void)setupEnhance {
}

#pragma mark - IBActions

- (IBAction)onGoBack:(id)sender {
    [delegate onGoBack];
}

- (IBAction)onShare:(id)sender {
    [delegate onShare:_image];
}

#pragma mark - UIScrollViewDelegate methods

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoView.imageView;
}

#pragma mark - UICollectionView Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_filtersArray count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCell *cell = [cv dequeueReusableCellWithReuseIdentifier: CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [_filtersArray objectAtIndex:indexPath.item];
    cell.title = [dict objectForKey:Name];
    cell.type = [[dict objectForKey:Type] intValue];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateFilters:indexPath.item];
}

@end
