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
#import "CommerceTypeModel.h"
#import "LetterModel.h"

@interface NetWorkConnection : NSObject

+(id)sharedInstance;

-(NSArray*)getArea; //获取社区
-(UserInfoModel*)showSelfUserInfo; //获取自己的用户信息

//根据社区获取消息和活动
-(NSArray*)getMessageByAreaID:(long)areaId sinceID:(long)sinceId;
-(NSArray*)getMessageByAreaID:(long)areaId PageSize:(int)pageSize Page:(int)page;
-(NSArray*)getMessageByAreaID:(long)areaId PageSize:(int)pageSize maxID:(long)maxId;

-(BOOL)cancelAttendActivity:(long)activityID; //取消参加活动
-(BOOL)attendActivity:(long)activityID attendInfo:(NSString*)infoStr; //参加活动
-(NSString*)checkAttendActivity:(long)activityID; //检查用户是否参加活动

//根据messageID获取评论
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize;
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize MaxID:(long)maxId;

//评论一条消息
-(void)createCommentWithText:(NSString*)text messageID:(int)messageId replyCommentID:(int)replyCommentId;
//获取我收到的评论
-(NSArray*)getCommentToMe:(long)SinceID maxID:(long)MaxID num:(int)Num page:(int)Page;


//发布各种消息
-(void)publishMessage:(int)MessageType fromTime:(NSString*)FromTime toTime:(NSString*)ToTime theme:(NSString*)Theme activityAddress:(NSString*)ActivityAddress
                  tel:(NSString*)Tel price:(NSString*)Price commerceType:(NSString*)CommerceType text:(NSString*)Text areaID:(long)AreaID lat:(double)Lat
                 long:(double)Long address:(NSString*)Address locationDescription:(NSString*)LocationDescription city:(NSString*)City
             province:(NSString*)Province country:(NSString*)Country url:(NSString*)Url pushNum:(int)PushNum;

//获取商品类别
-(NSArray*)getCommerceType;

//搜索消息
-(NSArray*)searchMessageByToken:(NSString*)Token type:(int)Type;

//检测用户时候存在
-(BOOL)checkUser:(NSString*)weiboID;
-(BOOL)checkUserQQ:(NSString*)openID;

//用户注册
-(BOOL)userRegister:(LogInMethod)Method name:(NSString*)Name gender:(int)Gender description:(NSString*)Description areaID:(long)AreaID registerKeyID:(NSString*)RegKeyID province:(NSString*)Province city:(NSString*)City country:(NSString*)Country headPic:(NSString*)HeadPic;


//获取用户的微博信息并保存到UserConfig中
-(void)getUserWeiBoInfo:(NSString*)wbToken UserID:(NSString*)userId;
-(void)getUserQQInfo:(NSString*)accessToken OpenID:(NSString*)openId;

//用户退出
-(BOOL)userLogOut;


//获得私信人列表
-(NSArray*)getLetterContacts;
//获得两人间的私信列表
//default value: SinceID = -1 MaxID = -1 Num = 3 Page = 1
-(NSArray*)getLetterBetweenTwo:(long)userID sinceID:(long)SinceID maxID:(long)MaxID num:(int)Num page:(int)Page;
//发送私信
-(BOOL)sendLetter:(long)UserID text:(NSString*)Text;

@end
