//
//  UserConfig.m
//  MicroSpeaker
//
//  Created by wy on 14-3-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UserConfig.h"

@implementation UserConfig

+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-（id）init
{
    if(self = [super int])
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        _headPic   = [userDefaults stringForKey:@"us_headPic"];
        _userName  = [userDefaults stringForKey:@"us_userName"];
        _signature = [userDefaults stringForKey:@"us_signature"];
        _weiboID   = [userDefaults stringForKey:@"us_weiboID"];
              
        _gender = [userDefaults integerForKey:@"us_gender"];
        _areaId = [userDefaults integerForKey:@"us_areaId"];
    }
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _headPic   = [aDecoder decodeObjectForKey:@"us_headPic"];
        _userName  = [aDecoder decodeObjectForKey:@"us_userName"];
        _signature = [aDecoder decodeObjectForKey:@"us_signature"];
         _weiboID  = [aDecoder decodeObjectForKey:@"us_weiboID"];
         
        _gender = [[aDecoder decodeObjectForKey:@"us_gender"] intValue];
        _areaId = [[aDecoder decodeObjectForKey:@"us_areaId"] intValue];
        

    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_headPic forKey:@"us_headPic"];
    [aCoder encodeObject:_userName forKey:@"us_userName"];
    [aCoder encodeObject:_signature forKey:@"us_signature"];
    [aCoder encodeObject:_weiboID forKey:@"us_weiboID"];
    
    [aCoder encodeObject:[NSNumber numberWithInt:_gender] forKey:@"us_gender"];
    [aCoder encodeObject:[NSNumber numberWithInt:_areaId] forKey:@"us_areaId"];
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setAreaId:(int)areaId
{
    _areaId = areaId;
    [self save];
}
-(void)setLogIn:(BOOL)logIn
{
    _logIn = logIn;
    [self save];
}
-(BOOL)isLogIn
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"us_logIn"];
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"userName = %@, gender = %d, signature = %@, logIn = %d", _userName, _gender, _signature, self.isLogIn];
}
-(void)save
{
    NSLog(@"%s %d", __FUNCTION__, self.aaa);
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
   
    [userDefaults setBool:_logIn forKey:@"us_logIn"];
    
    [userDefaults setInteger:_gender forKey:@"us_gender"];
    [userDefaults setInteger:_areaId forKey:@"us_areaId"];
    
    [userDefaults setObject:_headPic   forKey:@"us_headPic"];
    [userDefaults setObject:_userName  forKey:@"us_userName"];
    [userDefaults setObject:_signature forKey:@"us_signature"];
    [userDefaults setObject:_weiboIDe  forKey:@"us_weiboID"];
    
    [userDefaults synchronize];
}
@end
