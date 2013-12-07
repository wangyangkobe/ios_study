//
//  CommentModel.h
//  MicroSpeaker
//
//  Created by wy on 13-12-6.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
#import "UserModel.h"
#import "JSONModel.h"

@interface CommentModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, assign) int CommentID;
@property(nonatomic, assign) int MessageID;
@property(nonatomic, assign) int ReplyCommentID;

@property(nonatomic, copy) NSString* CreateAt;
@property(nonatomic, copy) UserModel* UserBasic;

@property(nonatomic, copy) MessageModel* Message;
@property(nonatomic, copy) NSString* Text;


@end
