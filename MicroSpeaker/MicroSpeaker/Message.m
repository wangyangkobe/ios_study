//
//  Message.m
//  JSON
//
//  Created by yang on 13-11-9.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize activityDict;
@synthesize areaDict;
@synthesize commentsList;
@synthesize commentsCount;
@synthesize createTimeStr;
@synthesize locationDict;
@synthesize messageId;
@synthesize photoThumbList;
@synthesize photoList;
@synthesize photoStr;
@synthesize photoThumbStr;
@synthesize textStr;
@synthesize messageType;
@synthesize userDict;

-(id)initWithMessageDict:(NSDictionary*)messageDict
{
    if (self = [super init]) {
        activityDict  = [messageDict objectForKey:@"Activity"];
        areaDict      = [messageDict objectForKey:@"Area"];
        commentsList  = [messageDict objectForKey:@"Comments"];
        commentsCount = [[messageDict objectForKey:@"CommentsCount"] integerValue];
        createTimeStr = [messageDict objectForKey:@"CreateAt"];
        locationDict  = [messageDict objectForKey:@"Location"];
        messageId     = [[messageDict objectForKey:@"MessageID"] integerValue];
        photoList     = [messageDict objectForKey:@"Photos"];
        photoThumbList = [messageDict objectForKey:@"PhotoThumbnails"];
        photoStr      = [messageDict objectForKey:@"Photo"];
        photoThumbStr = [messageDict objectForKey:@"PhotoThumbnail"];
        textStr       = [messageDict objectForKey:@"Text"];
        messageType   = [[messageDict objectForKey:@"Type"] integerValue];
        userDict      = [messageDict objectForKey:@"User"];
    }
    return self;
}
@end
