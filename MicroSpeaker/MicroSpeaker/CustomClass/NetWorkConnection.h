//
//  NetWorkConnection.h
//  MicroSpeaker
//
//  Created by wy on 13-12-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MacroDefination.h"
#import "AreaModel.h"
#import "UserInfoModel.h"
#import "MessageModel.h"
#import "CommentModel.h"
@interface NetWorkConnection : NSObject

+(id)sharedInstance;

-(NSArray*)getArea; //获取社区
-(UserInfoModel*)showSelfUserInfo; //获取自己的用户信息

//根据社区获取消息和活动
-(NSArray*)getMessageByAreaID:(long)areaId sinceID:(long)sinceId;
-(NSArray*)getMessageByAreaID:(long)areaId PageSize:(int)pageSize Page:(int)page;

-(BOOL)cancelAttendActivity:(long)activityID; //取消参加活动
-(BOOL)attendActivity:(long)activityID attendInfo:(NSString*)infoStr; //参加活动
-(NSString*)checkAttendActivity:(long)activityID; //检查用户是否参加活动

-(BOOL)checkUser:(NSString*)weiboID; //检查用户是否存在

//根据messageID获取评论b
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize;

//评论一条消息
-(void)createCommentWithText:(NSString*)text messageID:(int)messageId replyCommentID:(int)replyCommentId;
@end
