//
//  UserConfig.m
//  MicroSpeaker
//
//  Created by wy on 14-3-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UserConfig.h"

@implementation UserConfig

@synthesize logIn = _logIn;

+ (instancetype)shareInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(id)init
{
    if(self = [super init])
    {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        _headPic   = [userDefaults stringForKey:@"us_headPic"];
        _userName  = [userDefaults stringForKey:@"us_userName"];
        _signature = [userDefaults stringForKey:@"us_signature"];
        _registerKey   = [userDefaults stringForKey:@"us_registerKey"];
        _province  = [userDefaults stringForKey:@"us_province"];
        _city      = [userDefaults stringForKey:@"us_city"];
        
        _gender = (int)[userDefaults integerForKey:@"us_gender"];
        _areaID = (int)[userDefaults integerForKey:@"us_areaId"];
        _logIn  = [userDefaults boolForKey:@"us_login"];
        _logInMethod = [userDefaults integerForKey:@"us_logInMethod"];
        
        if (_areaID == 0)
        {
            _areaID = kHuaLi;  //默认社区
        }
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _headPic   = [aDecoder decodeObjectForKey:@"headPic"];
        _userName  = [aDecoder decodeObjectForKey:@"userName"];
        _signature = [aDecoder decodeObjectForKey:@"signature"];
        _registerKey   = [aDecoder decodeObjectForKey:@"registerKey"];
        _province  = [aDecoder decodeObjectForKey:@"province"];
        _city      = [aDecoder decodeObjectForKey:@"city"];
        
        _gender = [aDecoder decodeIntegerForKey:@"gender"];
        _areaID = [aDecoder decodeIntegerForKey:@"areaId"] ;
        _logIn  = [aDecoder decodeBoolForKey:@"login"];
        _logInMethod  = [aDecoder decodeIntegerForKey:@"logInMethod"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_headPic forKey:@"headPic"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_registerKey forKey:@"registerKey"];
    [aCoder encodeObject:_province forKey:@"province"];
    [aCoder encodeObject:_city forKey:@"city"];
    
    [aCoder encodeInteger:_gender  forKey:@"gender"];
    [aCoder encodeInteger:_areaID forKey:@"areaId"];
    [aCoder encodeBool:_logIn forKey:@"login"];
    [aCoder encodeInteger:_logInMethod forKey:@"logInMethod"];
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setAreaID:(int)areaId
{
    _areaID = areaId;
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
    return [NSString stringWithFormat:@"headPic = %@, userName = %@, gender = %d, signature = %@, logIn = %d, province = %@, city = %@", _headPic ,_userName, _gender, _signature, self.isLogIn, _province, _city];
}
-(void)save
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
   
    [userDefaults setBool:_logIn forKey:@"us_logIn"];
    
    [userDefaults setInteger:_gender forKey:@"us_gender"];
    [userDefaults setInteger:_areaID forKey:@"us_areaId"];
    
    [userDefaults setObject:_headPic   forKey:@"us_headPic"];
    [userDefaults setObject:_userName  forKey:@"us_userName"];
    [userDefaults setObject:_signature forKey:@"us_signature"];
    [userDefaults setObject:_registerKey  forKey:@"us_registerKey"];
    [userDefaults setObject:_province forKey:@"us_province"];
    [userDefaults setObject:_city  forKey:@"us_city"];
    
    [userDefaults setInteger:_logInMethod forKey:@"us_logInMethod"];
    [userDefaults synchronize];
}
@end
