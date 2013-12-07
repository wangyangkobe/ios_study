//
//  User.m
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize Gender = _Gender;
@synthesize HeadPic = _HeadPic;
@synthesize UserID = _UserID;
@synthesize UserName = _UserName;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_Gender forKey:@"Gender"];
    [aCoder encodeInt:_UserID forKey:@"UserID"];
    
    [aCoder encodeObject:_HeadPic forKey:@"HeadPic"];
    [aCoder encodeObject:_HeadPicOriginal forKey:@"HeadPicOriginal"];
    [aCoder encodeObject:_UserName forKey:@"UserName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Gender = [aDecoder decodeIntForKey:@"Gender"];
        _UserID = [aDecoder decodeIntForKey:@"UserID"];
        
        _HeadPic = [aDecoder decodeObjectForKey:@"HeadPic"];
        _HeadPicOriginal = [aDecoder decodeObjectForKey:@"HeadPicOriginal"];
        _UserName = [aDecoder decodeObjectForKey:@"UserName"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    UserModel* copy = [[UserModel allocWithZone:zone] init];
    
    copy.UserName = [self.UserName copyWithZone:zone];
    copy.HeadPic = [self.HeadPic copyWithZone:zone];
    copy.HeadPicOriginal = [self.HeadPicOriginal copyWithZone:zone];
    
    copy.UserID = self.UserID;
    copy.Gender = self.Gender;
    return copy;
}

@end
