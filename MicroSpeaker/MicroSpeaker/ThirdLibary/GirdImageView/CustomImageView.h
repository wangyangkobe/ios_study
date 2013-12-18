//
//  CustomImageView.h
//  GridImageView
//
//  Created by wy on 13-12-17.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomImageView;


@protocol CustomImageViewDelegate <NSObject>
@optional
-(void)imageViewTaped:(CustomImageView*) imageView;
-(void)imageViewMoveFinished:(CustomImageView*)photo;

@end

typedef NS_ENUM(NSInteger, PhotoType) {
    PhotoTypeImage  = 0, //Default
    PhotoTypeAdd    = 1,
};

@interface CustomImageView : UIView<UIGestureRecognizerDelegate>


@property(nonatomic, assign) id<CustomImageViewDelegate> delegate;

- (id)initWithOrigin:(CGPoint)origin;
- (void)moveToPosition:(CGPoint)point;

- (void)setPhotoType:(PhotoType)type;
- (PhotoType)getPhotoType;

- (void)setImageUrl:(NSString*)imageUrl;

@end
