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

/**
 * Returns the  transparent color used in the filters' scrollview background.
 */
+ (UIColor*)transparentColor {
    return [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f];
}

/**
 * Returns the  main color used in the menu buttons.
 */
+ (UIColor*)whiteColor {
    return [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8f];
}

#pragma mark - Images

/**
 * Returns the main logo image.
*/
NSString * const kImageLogo = @"logo";

#pragma mark - Fonts

/**
 * Prints all system fonts
*/
+ (void)printSystemFonts {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
      
    for (NSString *family in familyNames) {
      NSLog(@"Family name: %@", family);

      NSArray *fontNames = [UIFont fontNamesForFamilyName: family];
      for (NSString *font in fontNames) {
        NSLog(@"    Font name: %@", font);
      }
    }
}

/**
 * Returns title font with given size
*/
+ (UIFont*)titleFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Hugtophia" size:size];
}

@end
