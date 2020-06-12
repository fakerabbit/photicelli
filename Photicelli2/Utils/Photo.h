//
//  Photo.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/12/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject {
@private
    CIImage *_ciImage;
    UIImage *_uiImage;
    UIImage *_processedImage;
    CIContext *_context;
    UIImageOrientation _orientation;
}

- (void)setImage:(UIImage*)image withOrientation:(UIImageOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
