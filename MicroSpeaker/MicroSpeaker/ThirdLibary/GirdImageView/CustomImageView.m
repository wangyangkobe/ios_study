//
//  CustomImageView.m
//  GridImageView
//
//  Created by wy on 13-12-17.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "CustomImageView.h"


@interface CustomImageView()

@property (nonatomic, assign) CGPoint pointOrigin;
@property (strong, nonatomic) UIView* parentView;
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) NSString* imageUrl;
@property (nonatomic, assign) PhotoType type;

@end

#define kPhotoSize 75.

@implementation CustomImageView

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, kPhotoSize, kPhotoSize)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.layer.cornerRadius = 12;
        self.imageView.layer.masksToBounds = YES;
        
        self.parentView = [[UIView alloc] initWithFrame:self.bounds];
        self.parentView.alpha = 0.6;
        self.parentView.backgroundColor = [UIColor whiteColor];
        self.parentView.layer.cornerRadius = 11;
        self.parentView.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        
        [self addSubview:self.imageView];
        [self addSubview:self.parentView];
        [self addGestureRecognizer:tapRecognizer];
        self.parentView.hidden = YES;
    }
    return self;
}

- (void)setPhotoType:(PhotoType)type
{
    self.type = type;
    if (type == PhotoTypeAdd) {
        self.imageView.image = [UIImage imageNamed:@"addPhoto"];
    }
}
- (PhotoType)getPhotoType
{
    return self.type;
}

- (void)moveToPosition:(CGPoint)point
{
    if (self.type == PhotoTypeImage)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
        } completion:nil];
    }
    else
    {
        self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    }
}

- (void)setEditModel:(BOOL)edit
{
    if (self.type == PhotoTypeImage) {
        UILongPressGestureRecognizer *longPressreRecognizer = [[UILongPressGestureRecognizer alloc]
                                                               initWithTarget:self
                                                               action:@selector(handleLongPress:)];
        longPressreRecognizer.delegate = self;
        [self addGestureRecognizer:longPressreRecognizer];
        
    }
}

#pragma mark - UIGestureRecognizer

- (void)tapPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imageViewTaped:)]) {
        [self.delegate imageViewTaped:self];
    }
}

- (void)handleLongPress:(id)sender
{
    UILongPressGestureRecognizer *recognizer = sender;
    CGPoint point = [recognizer locationInView:self];
    
    CGFloat diffx = 0.;
    CGFloat diffy = 0.;
    
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        self.parentView.hidden = NO;
        self.pointOrigin = point;
        [self.superview bringSubviewToFront:self];
    }
    else if (UIGestureRecognizerStateEnded == recognizer.state)
    {
        self.parentView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(imageViewMoveFinished:)])
        {
            [self.delegate imageViewMoveFinished:self];
        }
    }
    else
    {
        diffx = point.x - self.pointOrigin.x;
        diffy = point.y - self.pointOrigin.y;
    }
    
    CGFloat originx = self.frame.origin.x +diffx;
    CGFloat originy = self.frame.origin.y +diffy;
    
    self.frame = CGRectMake(originx, originy, self.frame.size.width, self.frame.size.height);
}
@end
