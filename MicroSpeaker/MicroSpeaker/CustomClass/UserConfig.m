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
    static NSUserDefaults* userDefaults;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return sharedInstance;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _headPic   = [aDecoder decodeObjectForKey:@"headPic"];
        _userName  = [aDecoder decodeObjectForKey:@"userName"];
        _signature = [aDecoder decodeObjectForKey:@"signature"];
        
        _gender = [[aDecoder decodeObjectForKey:@"gender"] intValue];
        _areaId = [[aDecoder decodeObjectForKey:@"areaId"] intValue];
        
        _weiboID = [aDecoder decodeObjectForKey:@"weiboID"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_headPic forKey:@"headPic"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_signature forKey:@"signature"];
    [aCoder encodeObject:_weiboID forKey:@"weiboID"];
    
    [aCoder encodeObject:[NSNumber numberWithInt:_gender] forKey:@"gender"];
    [aCoder encodeObject:[NSNumber numberWithInt:_areaId] forKey:@"areaId"];
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(void)setLogIn:(BOOL)logIn
{
     NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:logIn forKey:@"logIn"];
    [userDefaults synchronize];
}
-(BOOL)isLogIn
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"logIn"];
}
-(NSString*)description
{
    return [NSString stringWithFormat:@"userName = %@, gender = %d, signature = %@, logIn = %d", _userName, _gender, _signature, self.isLogIn];
}
//-(void)save
//{
//    NSLog(@"%s %d", __FUNCTION__, self.aaa);
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
//    
//    [userDefaults setObject:data forKey:@"UserConfig"];
//    [userDefaults synchronize];
//}
@end
