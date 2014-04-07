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
    
    NSLog(@"get area: %@", [request responseString]);
    for (id area in jsonArray)
    {
        [result addObject:[[AreaModel alloc] initWithDictionary:area error:nil]];
    }
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
    [request setUseCookiePersistence: YES];
    [request startSynchronous];
    
    NSLog(@"requset cookoies = %@, selfUserInfo = %@, cookies = %@", [request requestCookies], [request responseString], [request responseCookies]);
    
    NSError* error;
    UserInfoModel* selfUserInfo = [[UserInfoModel alloc] initWithString:[request responseString] error:&error];
    if (error != nil) {
        NSLog(@"showSelfUserInfo Error = %@", [error localizedDescription]);
    }
    
    NSLog(@"selfUserInfo = %@", [selfUserInfo description]);
    return selfUserInfo;
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
    NSLog(@"getMessageByAreaID result = %@", [request responseString]);
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    //    for (id entry in [jsonArray reverseObjectEnumerator])
    //    {
    //        [result insertObject:[[MessageModel alloc] initWithDictionary:entry error:nil] atIndex:0];
    //    }
    for (id entry in jsonArray)
    {
        MessageModel* message = [[MessageModel alloc] initWithDictionary:entry error:nil];
        if (message)
            [result addObject:message];
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
    // NSLog(@"result = %@", [request responseString]);
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id entry in jsonArray)
    {
        MessageModel* message = [[MessageModel alloc] initWithDictionary:entry error:nil];
        if (message)
            [result addObject:message];
    }
    return result;
}
////////////////////////////////////////////////////////
-(NSArray*)getMessageByAreaID:(long)areaId PageSize:(int)pageSize maxID:(long)maxId
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* requestURL = [NSString stringWithFormat:@"%@/message/getByArea?areaID=%ld&maxID=%ld&num=%d", HOME_PAGE, areaId, maxId, pageSize];
    NSLog(@"URL = %@", requestURL);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    //  NSLog(@"getMessageByAreaID result = %@", [request responseString]);
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id entry in [jsonArray reverseObjectEnumerator])
    {
        MessageModel* message = [[MessageModel alloc] initWithDictionary:entry error:nil];
        if (message)
            [result insertObject:message atIndex:0];
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
    NSLog(@"cancelAttendActivity result: %@", [request responseString]);
    
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
    NSString* requestUrl = [NSString stringWithFormat:@"%@/user/checkUser", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:weiboID forKey:@"weiboID"];
    [request setUseCookiePersistence: YES];
    [request startSynchronous];
    
    NSLog(@"check user result:%@", [request responseString]);
    
    NSString* result = [request responseString];
    if ([result isEqualToString:@"true"])
        return YES; //yes
    else
        return NO;
}
////////////////////////////////////////////////////////
-(BOOL)checkUserQQ:(NSString *)openID
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/user/checkUserQQ", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:openID forKey:@"openID"];
    [request setUseCookiePersistence: YES];
    [request startSynchronous];
    
    NSLog(@"check user result:%@", [request responseString]);
    
    NSString* result = [request responseString];
    if ([result isEqualToString:@"true"])
        return YES; //yes
    else
        return NO;
}
////////////////////////////////////////////////////////
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize
{
    return [self getCommentsByMessageID:messsageId PageSize:pageSize MaxID:-1];
}

////////////////////////////////////////////////////////
-(NSArray*)getCommentsByMessageID:(long)messsageId PageSize:(int)pageSize MaxID:(long)maxId
{
    NSMutableArray* result = [NSMutableArray array];
    NSString* requestStr = nil;
    if (maxId == -1)
    {
        requestStr = [NSString stringWithFormat:@"%@/comment/show?messageID=%ld&num=%d", HOME_PAGE, messsageId, pageSize];
    }
    else
    {
        requestStr = [NSString stringWithFormat:@"%@/comment/show?messageID=%ld&num=%d&maxID=%ld", HOME_PAGE, messsageId, pageSize, maxId];
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestStr]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id element in jsonArray)
    {
        CommentModel* comment = [[CommentModel alloc] initWithDictionary:element error:nil];
        if (comment)
            [result addObject:comment];
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

////////////////////////////////////////////////////////
-(void)publishMessage:(int)MessageType fromTime:(NSString *)FromTime toTime:(NSString *)ToTime theme:(NSString *)Theme activityAddress:(NSString *)ActivityAddress tel:(NSString *)Tel price:(NSString *)Price commerceType:(NSString *)CommerceType text:(NSString *)Text areaID:(long)AreaID lat:(double)Lat long:(double)Long address:(NSString *)Address locationDescription:(NSString *)LocationDescription city:(NSString *)City province:(NSString *)Province country:(NSString *)Country url:(NSString *)Url pushNum:(int)PushNum
{
    NSString* requestURL = [NSString stringWithFormat:@"%@/message/createImageURL", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:[NSString stringWithFormat:@"%d", MessageType] forKey:@"messageType"];
    
    if (2 == MessageType)
    {
        [request setPostValue:FromTime forKey:@"fromTime"];
        [request setPostValue:ToTime   forKey:@"toTime"];
        [request setPostValue:Address  forKey:@"activityAddress"];
        [request setPostValue:Theme  forKey:@"theme"];
    }
    
    if (MessageType != 1) {
        [request setPostValue:Tel forKey:@"tel"];
    }
    
    if (3 == MessageType || 4 == MessageType) {
        [request setPostValue:Price forKey:@"price"];
        [request setPostValue:CommerceType forKey:@"commerceType"];
        [request setPostValue:Theme  forKey:@"theme"];
    }
    [request setPostValue:Text forKey:@"text"];
    [request setPostValue:[NSString stringWithFormat:@"%ld", AreaID] forKey:@"areaID"];
    [request setPostValue:[NSString stringWithFormat:@"%f", Lat] forKey:@"lat"];
    [request setPostValue:[NSString stringWithFormat:@"%f", Long] forKey:@"Long"];
    [request setPostValue:Address forKey:@"address"];
    
    if (LocationDescription != nil) //为nil表示采用默认值
        [request setPostValue:LocationDescription forKey:@"locationDescription"];
    [request setPostValue:City forKey:@"city"];
    [request setPostValue:Province forKey:@"province"];
    
    if(Country != nil)
        [request setPostValue:Country forKey:@"country"];
    else
        [request setPostValue:@"中国" forKey:@"country"];
    
    if (Url != nil)
        [request setPostValue:Url forKey:@"url"];
    
    [request setPostValue:[NSString stringWithFormat:@"%d", PushNum] forKey:@"pushNum"];
    
    [request startSynchronous];
    NSLog(@"publis message result: %@", [request responseString]);
}

////////////////////////////////////////////////////////
-(NSArray*)getCommerceType
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/message/commerceType", HOME_PAGE];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    NSMutableArray* result = [NSMutableArray array];
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id element in jsonArray)
    {
        CommerceTypeModel* commerceType = [[CommerceTypeModel alloc] initWithDictionary:element error:nil];
        if (commerceType)
            [result addObject:commerceType];
    }
    return result;
}

////////////////////////////////////////////////////////
-(NSArray*) searchMessageByToken:(NSString *)Token type:(int)Type{
    NSString* requestUrl;
    if (0 == Type) {
        requestUrl = [NSString stringWithFormat:@"%@/message/search?token=%@&num=%d", HOME_PAGE, Token, 1000];
    }else{
        requestUrl = [NSString stringWithFormat:@"%@/message/search?token=%@&type=%d&num=%d", HOME_PAGE, Token, Type, 1000];
    }
    //对url进行编码，因为url含有汉字
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    NSMutableArray* result = [NSMutableArray array];
    for (id message in jsonArray)
    {
        MessageModel* messageModel = [[MessageModel alloc] initWithDictionary:message error:nil];
        if (messageModel)
            [result addObject:messageModel];
    }
    return result;
}

////////////////////////////////////////////////////////
- (BOOL)userRegister:(LogInMethod)Method name:(NSString *)Name gender:(int)Gender description:(NSString *)Description areaID:(long)AreaID registerKeyID:(NSString *)RegKeyID province:(NSString *)Province city:(NSString *)City country:(NSString *)Country headPic:(NSString *)HeadPic
{
    NSLog(@"Method = %d", Method);
    NSString* requestURL;
    if (Method == kSinaWeiBoLogIn)
        requestURL = [NSString stringWithFormat:@"%@/user/register", HOME_PAGE];
    else
        requestURL = [NSString stringWithFormat:@"%@/user/registerQQ", HOME_PAGE];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    
    [request setPostValue:Name forKey:@"name"];
    [request setPostValue:[NSNumber numberWithInt:Gender] forKey:@"gender"];
    [request setPostValue:Description forKey:@"description"];
    [request setPostValue:[NSNumber numberWithLong:AreaID] forKey:@"areaID"];
    if (Method == kSinaWeiBoLogIn)
    {
        [request setPostValue:RegKeyID forKey:@"weiboID"];
    }
    else
    {
        [request setPostValue:RegKeyID forKey:@"openID"];
    }
    
    if(Province != nil)
        [request setPostValue:Province forKey:@"province"];
    if(City != nil)
        [request setPostValue:City forKey:@"city"];
    if(Country != nil)
        [request setPostValue:Country forKey:@"country"];
    if(HeadPic != nil)
        [request setPostValue:HeadPic forKey:@"headPic"];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error)
    {
        NSLog(@"publish message result: %@", [request responseString]);
        return YES;
    }
    return NO;
}

////////////////////////////////////////////////////////
-(BOOL)userLogOut
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/user/logout", HOME_PAGE];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    NSString* responseString = [request responseString];
    
    NSLog(@"user logout:%@", [request responseString]);
    if ([responseString rangeOfString:@"OK"].location == NSNotFound)
        return NO;
    else
        return YES; //yes
}

////////////////////////////////////////////////////////
-(void)getUserWeiBoInfo:(NSString *)wbToken UserID:(NSString *)userId
{
    NSString* showUserInfoUrl = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", wbToken, userId];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:showUserInfoUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSDictionary* userWBInfo = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    //NSLog(@"userInfo = %@", userWBInfo);
    
    [UserConfig shareInstance].headPic   = [userWBInfo objectForKey:@"avatar_large"];
    [UserConfig shareInstance].userName  = [userWBInfo objectForKey:@"screen_name"];
    [UserConfig shareInstance].signature = [userWBInfo objectForKey:@"description"];
    [UserConfig shareInstance].registerKey   = [userWBInfo objectForKey:@"id"];
    
    int proviceCode = (int)[[userWBInfo valueForKey:@"province"] integerValue];
    int cityCode    = (int)[[userWBInfo valueForKey:@"city"] integerValue];
    
    NSDictionary* provinceAndCity = [self decodeProvinceAndCity:proviceCode cityCode:cityCode];
    [UserConfig shareInstance].province = [provinceAndCity valueForKey:@"provinceName"];
    [UserConfig shareInstance].city = [provinceAndCity valueForKey:@"cityName"];
    
    NSString* gender = [userWBInfo objectForKey:@"gender"];
    if ([gender isEqualToString:@"m"])
        [UserConfig shareInstance].gender = kBoy; //男
    else if([gender isEqualToString:@"f"])
        [UserConfig shareInstance].gender = kGirl; //女
    else
        [UserConfig shareInstance].gender = kUnKnown; //未知
    
    [[UserConfig shareInstance] save];
    NSLog(@"UserConfig: %@", [[UserConfig shareInstance] description]);
}
////////////////////////////////////////////////////////
-(void)getUserQQInfo:(NSString *)accessToken OpenID:(NSString *)openId
{
    NSString* requestUrl = [NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=101049592&openid=%@", accessToken, openId];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSDictionary* userQQInfo = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
    
    NSLog(@"userQQInfo = %@", userQQInfo);
    
    [UserConfig shareInstance].headPic   = [userQQInfo objectForKey:@"figureurl_qq_2"];
    [UserConfig shareInstance].userName  = [userQQInfo objectForKey:@"nickname"];
    [UserConfig shareInstance].signature = nil;
    [UserConfig shareInstance].province  = @"上海市";
    [UserConfig shareInstance].city      = @"上海市";
    [UserConfig shareInstance].registerKey = openId;
    
    NSString* gender = [userQQInfo objectForKey:@"gender"];
    if ([gender isEqualToString:@"女"])
        [UserConfig shareInstance].gender = kGirl; //女
    else
        [UserConfig shareInstance].gender = kBoy; //未知
    
    [[UserConfig shareInstance] save];
    NSLog(@"UserConfig: %@", [[UserConfig shareInstance] description]);
    
}
////////////////////////////////////////////////////////
-(NSDictionary*)decodeProvinceAndCity:(int)provinceCode cityCode:(int)CityCode
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Provinces" ofType:@"plist"];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray* provinces = [data objectForKey:@"provinces"];
    
    NSString* provinceName;
    NSString* cityName;
    for (NSDictionary* element in provinces)
    {
        if (provinceCode == [[element valueForKey:@"id"] integerValue] )
        {
            provinceName = [element valueForKey:@"name"];
            
            if ([provinceName isEqualToString:@"上海市"]) {
                cityName = @"上海市";
                break;
            }
            NSArray* cities = [element valueForKey:@"citys"];
            for (NSDictionary* city in cities) {
                int cityId = (int)[[[city allKeys] objectAtIndex:0] integerValue];
                if (cityId == CityCode)
                {
                    cityName = [city valueForKey:[NSString stringWithFormat:@"%d", CityCode]];
                }
            }
        }
    }
    return [NSDictionary dictionaryWithObjectsAndKeys:provinceName, @"provinceName", cityName, @"cityName", nil];
}
////////////////////////////////////////////////////////
-(NSArray*)getLetterContacts
{
    NSString* requestUrl = [NSString stringWithFormat:@"%@/letter/contacts", HOME_PAGE];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    NSMutableArray* result = [NSMutableArray array];
    NSError* error;
    for (id letter in jsonArray)
    {
        LetterModel* letterModel = [[LetterModel alloc] initWithDictionary:letter error:&error];
        if (letterModel)
            [result addObject:letterModel];
        else
            NSLog(@"getLetterContacts error = %@", [error localizedDescription]);
    }
    return result;

}
@end
