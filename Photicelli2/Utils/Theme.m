//
//  Theme.m
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/5/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import "Theme.h"

@implementation Theme

#pragma mark - Filters

/**
 * Returns the kVideoFilterType  for a given name string.
 */
+ (kVideoFilterType)typeForFilter:(NSString*)name {
    kVideoFilterType type = -1;
    NSString *lowecaseName = [name lowercaseString];
    
    if ([lowecaseName isEqualToString:@"none"])
        type = GPUIMAGE_SATURATION;
    else if ([lowecaseName isEqualToString:@"miya"])
        type = GPUIMAGE_THRESHOLD;
    else if ([lowecaseName isEqualToString:@"akira"])
        type = GPUIMAGE_SOBELEDGEDETECTION;
    else if ([lowecaseName isEqualToString:@"vinci"])
        type = GPUIMAGE_SKETCH;
    else if ([lowecaseName isEqualToString:@"walt"])
        type = GPUIMAGE_TOON;
    else if ([lowecaseName isEqualToString:@"amiga"])
        type = GPUIMAGE_CGA;
    else if ([lowecaseName isEqualToString:@"goethe"])
        type = GPUIMAGE_PINCH;
    else if ([lowecaseName isEqualToString:@"quino"])
        type = GPUIMAGE_EROSION;
    else if ([lowecaseName isEqualToString:@"victoria"])
        type = GPUIMAGE_CUSTOM;
    else if ([lowecaseName isEqualToString:@"rose"])
        type = GPUIMAGE_AMATORKA;
    else if ([lowecaseName isEqualToString:@"missetikate"])
        type = GPUIMAGE_MISSETIKATE;
    else if ([lowecaseName isEqualToString:@"burton"])
        type = GPUIMAGE_SOFTELEGANCE;
    else if ([lowecaseName isEqualToString:@"giger"])
        type = GPUIMAGE_CUSTOM2;
    else if ([lowecaseName isEqualToString:@"invertor"])
        type = GPUIMAGE_COLORINVERT;
    else if ([lowecaseName isEqualToString:@"smooth"])
        type = GPUIMAGE_SMOOTH;
    
    
    return type;
}

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
    return [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:1.f];//.7
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
