//
//  UserConfig.h
//  MicroSpeaker
//
//  Created by wy on 14-3-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject<NSCopying, NSCoding>

@property(nonatomic, copy) NSString* headPic;
@property(nonatomic, copy) NSString* userName;
@property(nonatomic, copy) NSString* signature; //用户签名
@property(nonatomic, copy) NSString* province;
@property(nonatomic, copy) NSString* city;

@property(nonatomic, assign) int gender;        //性别
@property(nonatomic, assign) int areaID;        //社区

@property(nonatomic, copy) NSString* registerKey; //weiboID  or qqOpenID

@property(nonatomic, assign, getter = isLogIn) BOOL logIn;
@property(nonatomic, assign) LogInMethod logInMethod;

+ (instancetype)shareInstance;
- (void)save;

@end
