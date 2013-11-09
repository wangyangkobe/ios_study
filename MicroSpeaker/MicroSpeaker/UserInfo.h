//
//  UserInfo.h
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    NSString* userName;
    NSString* userHeaPic;
    NSInteger userId;
    BOOL      userGender; //true for boy
}

@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* userHeadPic;
@property(nonatomic, assign) NSInteger userId;
@property(nonatomic, assign) BOOL userGender;

-(id)initWithName:(NSString*)userName headpic:(NSString*)headPic user_id:(NSInteger)userId gender:(BOOL) userGender;

@end
