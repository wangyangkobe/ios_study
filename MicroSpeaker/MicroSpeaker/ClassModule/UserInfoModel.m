//
//  UserInfoModel.m
//  MicroSpeaker
//
//  Created by wy on 13-12-14.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_Gender forKey:@"Gender"];
    [aCoder encodeInt:_UserID forKey:@"UserID"];
    
    [aCoder encodeObject:_Area forKey:@"Area"];
    [aCoder encodeObject:_CreateAt forKey:@"CreateAt"];
    [aCoder encodeObject:_Province forKey:@"Province"];
    [aCoder encodeObject:_City forKey:@"City"];
    [aCoder encodeObject:_ModifiedAt forKey:@"ModifiedAt"];
    [aCoder encodeObject:_QQ forKey:@"QQ"];
    [aCoder encodeObject:_WeiboID forKey:@"WeiboID"];
    [aCoder encodeObject:_HeadPic forKey:@"HeadPic"];
    [aCoder encodeObject:_HeadPicOriginal forKey:@"HeadPicOriginal"];
    [aCoder encodeObject:_Country forKey:@"Country"];
    [aCoder encodeObject:_Description forKey:@"Description"];
    [aCoder encodeObject:_UserName forKey:@"UserName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Gender = [aDecoder decodeIntForKey:@"Gender"];
        _UserID = [aDecoder decodeIntForKey:@"UserID"];
        
        _Area = [aDecoder decodeObjectForKey:@"Area"];
        _CreateAt = [aDecoder decodeObjectForKey:@"CreateAt"];
        _Province = [aDecoder decodeObjectForKey:@"Province"];
        _City = [aDecoder decodeObjectForKey:@"City"];
        _ModifiedAt = [aDecoder decodeObjectForKey:@"ModifiedAt"];
        _QQ = [aDecoder decodeObjectForKey:@"QQ"];
        _WeiboID = [aDecoder decodeObjectForKey:@"WeiboID"];
        _HeadPic = [aDecoder decodeObjectForKey:@"HeadPic"];
        _HeadPicOriginal = [aDecoder decodeObjectForKey:@"HeadPicOriginal"];
        _Country = [aDecoder decodeObjectForKey:@"Country"];
        _Description = [aDecoder decodeObjectForKey:@"Description"];
        _UserName = [aDecoder decodeObjectForKey:@"UserName"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    UserInfoModel* copy = [[UserInfoModel allocWithZone:zone] init];

    copy.Gender = self.Gender;
    copy.UserID = self.UserID;
    
    copy.Area = [self.Area copyWithZone:zone];
    copy.CreateAt = [self.CreateAt copyWithZone:zone];
    copy.Province = [self.Province copyWithZone:zone];
    copy.City = [self.City copyWithZone:zone];
    copy.ModifiedAt = [self.ModifiedAt copyWithZone:zone];
    copy.QQ = [self.QQ copyWithZone:zone];
    copy.WeiboID = [self.WeiboID copyWithZone:zone];
    copy.HeadPic = [self.HeadPic copyWithZone:zone];
    copy.HeadPicOriginal = [self.HeadPicOriginal copyWithZone:zone];
    copy.Country = [self.Country copyWithZone:zone];
    copy.Description = [self.Description copyWithZone:zone];
    copy.UserName = [self.UserName copyWithZone:zone];
    return copy;
}

@end
