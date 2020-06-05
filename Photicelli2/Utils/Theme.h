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

@interface Theme : NSObject

/**
 * Theme colors.
*/

+ (UIColor*)backgroundColor;
+ (UIColor*)cyanColor;

/**
 * Theme images.
*/

extern NSString * const kImageLogo;

@end

NS_ASSUME_NONNULL_END
