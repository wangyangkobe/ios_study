//
//  Message.h
//  JSON
//
//  Created by yang on 13-11-9.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSDictionary* activityDict;
    NSDictionary* areaDict;
    NSArray*      commentsList;
    NSInteger     commentsCount;
    NSString*     createTimeStr;
    NSDictionary* locationDict;
    NSInteger     messageId;
    NSArray*      photoThumbList;
    NSArray*      photoList;
    NSString*     photoStr;
    NSString*     photoThumbStr;
    NSString*     textStr;
    NSInteger     messageType;
    NSDictionary* userDict;
}

@property(nonatomic, retain) NSDictionary* activityDict;
@property(nonatomic, retain) NSDictionary* areaDict;
@property(nonatomic, retain) NSArray*      commentsList;
@property(nonatomic, retain) NSDictionary* locationDict;
@property(nonatomic, retain) NSArray*      photoThumbList;
@property(nonatomic, retain) NSArray*      photoList;
@property(nonatomic, retain) NSDictionary* userDict;

@property(nonatomic, assign) NSInteger     commentsCount;
@property(nonatomic, assign) NSInteger     messageId;
@property(nonatomic, assign) NSInteger     messageType;

@property(nonatomic, copy)   NSString*     textStr;
@property(nonatomic, copy)   NSString*     createTimeStr;
@property(nonatomic, copy)   NSString*     photoStr;
@property(nonatomic, copy)   NSString*     photoThumbStr;


-(id)initWithMessageDict:(NSDictionary*)messageDict;
@end
