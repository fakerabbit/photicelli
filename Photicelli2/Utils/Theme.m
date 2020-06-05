//
//  Theme.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "Theme.h"

@implementation Theme

#pragma mark - Colors

/**
 * Returns the dark color used in the background view.
 */
+ (UIColor*)backgroundColor {
    CGFloat red = 51.f/255.f;
    CGFloat green = 51.f/255.f;
    CGFloat blue = 53.f/255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

/**
* Returns the main cyan color.
*/
+ (UIColor*)cyanColor {
    CGFloat red = 84.f/255.f;
    CGFloat green = 210.f/255.f;
    CGFloat blue = 210.f/255.f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark - Images

NSString * const kImageLogo = @"logo";

@end
