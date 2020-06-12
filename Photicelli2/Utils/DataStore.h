//
//  DataStore.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/12/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Photo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataStore : NSObject {
@private
    Photo *_photo;
}

-(void)storePhoto:(NSString*)path withOrientation:(UIImageOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
