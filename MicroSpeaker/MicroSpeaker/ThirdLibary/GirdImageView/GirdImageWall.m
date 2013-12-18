//
//  GirdImageWall.m
//  GridImageView
//
//  Created by wy on 13-12-17.
//  Copyright (c) 2013年 wy. All rights reserved.
//

#import "GirdImageWall.h"
#import "CustomImageView.h"

@interface GirdImageWall () <CustomImageViewDelegate>

@property (strong, nonatomic) NSArray *arrayPositions;
@property (strong, nonatomic) NSMutableArray *arrayImages;

@end

#define kFrameHeight 95.
#define kFrameHeight2x 175.

#define kImagePositionx @"positionx"
#define kImagePositiony @"positiony"

@implementation GirdImageWall

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blueColor];
        
        self.arrayPositions = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"4", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"83", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"162", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"241", kImagePositionx, @"10", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"4", kImagePositionx, @"90", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"83", kImagePositionx, @"90", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"162", kImagePositionx, @"90", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"241", kImagePositionx, @"90", kImagePositiony, nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"330", kImagePositionx, @"90", kImagePositiony, nil], nil];
        self.arrayImages = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)setImages:(NSArray*)images
{
    [self.arrayImages removeAllObjects];
    NSUInteger count = [images count];
    for (int i = 0; i < count; i++)
    {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        CustomImageView* tempImageView = [[CustomImageView alloc] initWithOrigin:CGPointMake(originx, originy)];
        tempImageView.delegate = self;
        [tempImageView setImageUrl:[images objectAtIndex:i]];
        [self addSubview:tempImageView];
        [self.arrayImages addObject:tempImageView];
    }
    
    NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:count];
    CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
    CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
    CustomImageView *addImageView = [[CustomImageView alloc] initWithOrigin:CGPointMake(originx, originy)];
    addImageView.delegate = self;
    [addImageView setPhotoType:PhotoTypeAdd];
    [self.arrayImages addObject:addImageView];
    [self addSubview:addImageView];
    
    CGFloat frameHeight = -1;
    if (count > 4)
    {
        frameHeight = kFrameHeight2x;
    } else
    {
        frameHeight = kFrameHeight;
    }
    self.frame = CGRectMake(0., 0., 320., frameHeight);
}

- (void)addImage:(NSString *)imageUrl
{
    NSUInteger index = [self.arrayImages count] - 1;
    NSDictionary* dictionaryTemp = [self.arrayPositions objectAtIndex:index];
    CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
    CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
    
    CustomImageView *imageView = [[CustomImageView alloc] initWithOrigin:CGPointMake(originx, originy)];
    imageView.delegate = self;
    [imageView setImageUrl:imageUrl];
    
    [self.arrayImages insertObject:imageView atIndex:index];
    [self addSubview:imageView];
    [self reloadPhotos:YES];
}
- (void)deleteImageAtIndex:(NSUInteger)index
{
    CustomImageView* imageView = [self.arrayImages objectAtIndex:index];
    [self.arrayImages removeObject:imageView];
    [imageView removeFromSuperview];
    [self reloadPhotos:YES];
}

#pragma mark - CustomImageView
- (void)photoTaped:(CustomImageView*)image
{
    NSUInteger type = [image getPhotoType];
    if (type == PhotoTypeAdd)
    {
        if ([self.delegate respondsToSelector:@selector(girdImageAddAction)])
        {
            [self.delegate girdImageAddAction];
        }
    }
    else if (type == PhotoTypeImage)
    {
        NSUInteger index = [self.arrayImages indexOfObject:image];
        if ([self.delegate respondsToSelector:@selector(imageViewTaped:)])
        {
            [self.delegate girdImageTaped:index];
        }
    }
}

- (void)photoMoveFinished:(CustomImageView*)image
{
    CGPoint pointPhoto = CGPointMake(image.frame.origin.x, image.frame.origin.y);
    CGFloat space = -1;
    NSUInteger oldIndex = [self.arrayImages indexOfObject:image];
    NSUInteger newIndex = -1;
    
    NSUInteger count = [self.arrayImages count] - 1;
    for (int i = 0; i < count; i++)
    {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        CGPoint pointTemp = CGPointMake(originx, originy);
        CGFloat spaceTemp = [self spaceToPoint:pointPhoto FromPoint:pointTemp];
        if (space < 0)
        {
            space = spaceTemp;
            newIndex = i;
        }
        else
        {
            if (spaceTemp < space)
            {
                space = spaceTemp;
                newIndex = i;
            }
        }
    }
    
    [self.arrayImages removeObject:image];
    [self.arrayImages insertObject:image atIndex:newIndex];
    
    [self reloadPhotos:NO];
    
    if ([self.delegate respondsToSelector:@selector(girdImageMovePhotoFromIndex:toIndex:)]) {
        [self.delegate girdImageMovePhotoFromIndex:oldIndex toIndex:newIndex];
    }
}

- (void)reloadPhotos:(BOOL)add
{
    NSUInteger count = -1;
    if (add) {
        count = [self.arrayImages count];
    } else {
        count = [self.arrayImages count] - 1;
    }
    for (int i=0; i<count; i++) {
        NSDictionary *dictionaryTemp = [self.arrayPositions objectAtIndex:i];
        CGFloat originx = [[dictionaryTemp objectForKey:kImagePositionx] floatValue];
        CGFloat originy = [[dictionaryTemp objectForKey:kImagePositiony] floatValue];
        
        CustomImageView *photoTemp = [self.arrayImages objectAtIndex:i];
        [photoTemp moveToPosition:CGPointMake(originx, originy)];
    }
    
    CGFloat frameHeight = -1;
    NSUInteger imageCount = [self.arrayImages count];
    
    if (imageCount > 4) {
        frameHeight = kFrameHeight2x + 20.;
    } else {
        frameHeight = kFrameHeight + 20.;
    }
    
    self.frame = CGRectMake(0., 0., 320., frameHeight);
}

- (CGFloat)spaceToPoint:(CGPoint)point FromPoint:(CGPoint)otherPoint
{
    float x = point.x - otherPoint.x;
    float y = point.y - otherPoint.y;
    return sqrt(x * x + y * y);
}
@end
