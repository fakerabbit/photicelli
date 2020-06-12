//
//  Photo.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/12/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "Photo.h"

@implementation Photo

#pragma mark - Public Methods

- (void)setImage:(UIImage *)image withOrientation:(UIImageOrientation)orientation {
    //NSLog(@"orientation in util: %ld", orientation);
    _uiImage = image;
    _orientation = orientation;
    _ciImage = [CIImage imageWithCGImage: image.CGImage];
    _context = [CIContext contextWithOptions: nil];
    _processedImage = nil;
}

@end
