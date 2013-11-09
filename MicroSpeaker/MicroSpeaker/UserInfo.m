//
//  UserInfo.m
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize userGender;
@synthesize userHeadPic;
@synthesize userId;
@synthesize userName;


-(id)initWithName:(NSString *)Name headpic:(NSString *)Pic user_id:(NSInteger)Id gender:(BOOL)Gender
{
    if (self = [super init])
    {
        self.userName = Name;
        self.userHeadPic = Pic;
        self.userId = Id;
        self.userGender = Gender;
    }
    return self;
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"name = %@, id = %d, gender = %d", userName, userId, userGender];
}
@end
