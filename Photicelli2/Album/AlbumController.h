//
//  AlbumController.h
//  Photicelli2
//
//  Created by Mirko Justiniano on 6/17/20.
//  Copyright © 2020 idevcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumView.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumController : UIViewController <IAlbumViewDelegate> {
@private
    AlbumView *_albumView;
}

@end

NS_ASSUME_NONNULL_END
