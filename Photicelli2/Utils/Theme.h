//
//  Theme.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kCameraViewFiltersScrollViewHeight 70.f
#define kCameraViewFiltersScrollViewLeftPadding 5.f
#define kCameraViewFiltersScrollViewPadding 5.f
#define kCameraViewFiltersScrollViewTopPadding 5.f
#define kCameraViewFiltersScrollViewLabelHeight 20.f

@interface Theme : NSObject

/**
 * Theme colors.
*/

+ (UIColor*)backgroundColor;
+ (UIColor*)cyanColor;
+ (UIColor*)transparentColor;
+ (UIColor*)whiteColor;

/**
 * Theme images.
*/

extern NSString * const kImageLogo;

/**
 * Theme fonts.
*/

+ (void)printSystemFonts;
+ (UIFont*)titleFontWithSize:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
