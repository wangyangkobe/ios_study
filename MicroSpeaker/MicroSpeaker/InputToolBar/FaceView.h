//
//  FacialView.h
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticons.h"
#import "Emoji.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@protocol FaceViewDelegate

-(void)selectedFacialView:(NSString*)str;

@end

@interface FaceView: UIView
{
	NSArray *faces;
}

@property(nonatomic,weak) id<FaceViewDelegate>delegate;

-(void)loadFaceView:(int)page size:(CGSize)size;

@end
