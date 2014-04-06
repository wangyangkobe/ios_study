//
//  UserInfoModel.h
//  MicroSpeaker
//
//  Created by wy on 13-12-14.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#include "AreaModel.h"
@interface UserInfoModel : JSONModel<NSCopying, NSCoding>

@property (nonatomic, copy)   AreaModel* Area;
@property (nonatomic, copy)   NSString<Optional>* CreateAt;
@property (nonatomic, copy)   NSString<Optional>* Province;
@property (nonatomic, copy)   NSString<Optional>* City;
@property (nonatomic, copy)   NSString<Optional>* ModifiedAt;
@property (nonatomic, assign) int Gender;
@property (nonatomic, copy)   NSString<Optional>* QQ;
@property (nonatomic, copy)   NSString<Optional>* WeiboID;
@property (nonatomic, assign) int UserID;
@property (nonatomic, copy)   NSString<Optional>* HeadPic;
@property (nonatomic, copy)   NSString<Optional>* HeadPicOriginal;
@property (nonatomic, copy)   NSString<Optional>* Country;
@property (nonatomic, copy)   NSString<Optional>* Description;
@property (nonatomic, copy)   NSString* UserName;

@end
