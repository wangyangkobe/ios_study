//
//  UserConfig.h
//  MicroSpeaker
//
//  Created by wy on 14-3-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject

@property(nonatomic, assign, getter = isLogIn) BOOL logIn;

+ (instancetype)shareInstance;

@end
