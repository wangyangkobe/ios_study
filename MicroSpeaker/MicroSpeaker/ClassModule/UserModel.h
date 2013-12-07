//
//  User.h
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface UserModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, assign) int Gender;
@property(nonatomic, strong) NSString* HeadPic;
@property(nonatomic, assign) int UserID;
@property(nonatomic, strong) NSString<Optional>* HeadPicOriginal;
@property(nonatomic, strong) NSString* UserName;

@end
