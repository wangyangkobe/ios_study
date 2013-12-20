//
//  NetWorkConnection.m
//  MicroSpeaker
//
//  Created by wy on 13-12-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "NetWorkConnection.h"

@implementation NetWorkConnection

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
//////////////////////////////////////////////////////
-(NSArray*)getArea
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* requstURL = [NSString stringWithFormat:@"%@/area", HOME_PAGE];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requstURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                              options:NSJSONReadingMutableContainers
                                                                error:nil];
    
    NSLog(@"%@", [request responseString]);
    for (id area in jsonArray)
    {
        [result addObject:[[AreaModel alloc] initWithDictionary:area error:nil]];
    }
    NSLog(@"%d", [result count]);
    return result;
}
//////////////////////////////////////////////////////
-(UserInfoModel*)showSelfUserInfo
{
    NSString* requstURL = [NSString stringWithFormat:@"%@/user/show", HOME_PAGE];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requstURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                              options:NSJSONReadingMutableContainers
                                                                error:nil];
    return [[UserInfoModel alloc] initWithDictionary:jsonArray error:nil];
}
////////////////////////////////////////////////////////
-(NSArray*)getMessageByAreaID:(long)areaId sinceID:(long)sinceId
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* requestURL = [NSString stringWithFormat:@"%@/message/getByArea?areaID=%ld&sinceID=%ld", HOME_PAGE, areaId, sinceId];
    NSLog(@"URL = %@", requestURL);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    NSLog(@"result = %@", [request responseString]);
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id entry in [jsonArray reverseObjectEnumerator])
    {
        [result insertObject:[[MessageModel alloc] initWithDictionary:entry error:nil] atIndex:0];
    }
    return result;
}
////////////////////////////////////////////////////////
-(NSArray*)getMessageByAreaID:(long)areaId PageSize:(int)pageSize Page:(int)page
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* pageUrl = [NSString stringWithFormat:@"%@/message/getByArea?areaID=%ld&page=%d&num=%d",
                         HOME_PAGE, areaId, page, pageSize];
    NSLog(@"requst URL = %@", pageUrl);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
                               [NSURL URLWithString:pageUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    //NSLog(@"result = %@", [request responseString]);
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id entry in jsonArray)
    {
        [result addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
    }
    return result;
}
////////////////////////////////////////////////////////
-(BOOL)cancelAttendActivity:(long)activityID
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/cancel", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSString stringWithFormat:@"%ld", activityID] forKey:@"activityID"];
    [request startSynchronous];
    NSLog(@"cancel result: %@", [request responseString]);
    
    NSError* error = [request error];
    if (!error) {
        return YES;
    }
    return NO;
}
////////////////////////////////////////////////////////
-(BOOL)attendActivity:(long)activityID attendInfo:(NSString *)infoStr
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/attend", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSString stringWithFormat:@"%ld", activityID] forKey:@"activityID"];
    if (infoStr != nil){
        [request setPostValue:infoStr forKey:@"text"];
    }
    [request startSynchronous];
    
    NSLog(@"参加活动:%@", [request responseString]);
    NSError* error = [request error];
    
    if (!error) {
        return YES;
    }
    return NO;
}
////////////////////////////////////////////////////////
-(NSString*)checkAttendActivity:(long)activityID
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/checkAttend?activityID=%ld", HOME_PAGE, activityID];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    NSLog(@"check activity:%@", [request responseString]);
    return [NSString stringWithString:[request responseString]]; //"false"表示未参加，“2013-10-16 00:01:21”表示参加
}
////////////////////////////////////////////////////////
-(BOOL)checkUser:(NSString *)weiboID
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
                                   [NSURL URLWithString:@"http://101.78.230.95:8082/microbroadcastDEV/user/checkUser"]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"1989424925" forKey:@"weiboID"];
    [request startSynchronous];
    NSLog(@"headers:%@", [request responseHeaders]);
    NSLog(@"response:%@", [request responseString]);
    
    NSString* result = [request responseString];
    if ([result isEqualToString:@"true"]) {
        return YES;
    }
    else
        return NO;
}
////////////////////////////////////////////////////////
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* requestStr = [NSString stringWithFormat:@"%@/comment/show?messageID=%ld&num=%d", HOME_PAGE, messsageId, pageSize];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestStr]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id comment in jsonArray)
    {
        [result addObject:[[CommentModel alloc] initWithDictionary:comment error:nil]];
    }
    return result;
}
////////////////////////////////////////////////////////
-(void)createCommentWithText:(NSString *)text messageID:(int)messageId replyCommentID:(int)replyCommentId
{
    NSString* requestURL = [NSString stringWithFormat:@"%@/comment/create", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:text forKey:@"text"];
    [request setPostValue:[NSString stringWithFormat:@"%d", messageId] forKey:@"messageID"];
    
    if (replyCommentId > 0)
        [request setPostValue:[NSString stringWithFormat:@"%d", replyCommentId] forKey:@"replyCommentID"];
    
    [request startSynchronous];
    NSLog(@"create comment result:%@", [request responseString]);
}
@end
