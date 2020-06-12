//
//  DataStore.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/12/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

- (id)init {
    self = [super init];
    if (self) {
        _photo = [[Photo alloc] init];
    }
    return self;
}

#pragma mark - Public Methods

- (void)storePhoto:(NSString *)path withOrientation:(UIImageOrientation)orientation {
    //NSLog(@"storePhoto: %@", path);
    
    // Get original image
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/test.png",docDir];
    UIImage *photo = [UIImage imageWithContentsOfFile: pngFilePath];
    if (photo)
        [_photo setImage: photo withOrientation: orientation];
}

@end
