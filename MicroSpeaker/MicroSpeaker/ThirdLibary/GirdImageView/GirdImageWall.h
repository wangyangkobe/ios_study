//
//  GirdImageWall.h
//  GridImageView
//
//  Created by wy on 13-12-17.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GirdImageWallDelegate <NSObject>

- (void)girdImageTaped:(NSUInteger)index;
- (void)girdImageMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)girdImageAddAction;
- (void)girdImageAddFinish;
- (void)girdImageDeleteFinish;

@end

@interface GirdImageWall : UIView

@property (assign) id<GirdImageWallDelegate> delegate;

- (void)setImages:(NSArray*)images;
- (void)addImage:(NSString*)imageUrl;
- (void)deleteImageAtIndex:(NSUInteger)index;

@end
