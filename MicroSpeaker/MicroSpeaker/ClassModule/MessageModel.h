//
//  MessageModel.h
//  MicroSpeaker
//
//  Created by wy on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "AreaModel.h"
#import "LocationModel.h"
#import "UserModel.h"
#import "ActivityModel.h"

@interface MessageModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, strong) ActivityModel<Optional>* Activity;
@property(nonatomic, strong) AreaModel* Area;
@property(nonatomic, strong) NSArray* Comments;
@property(nonatomic, assign) int CommentsCount;
@property(nonatomic, strong) NSString* CreateAt;
@property(nonatomic, strong) LocationModel* Location;
@property(nonatomic, assign) long MessageID;
@property(nonatomic, strong) NSString<Optional>* Photo;
@property(nonatomic, strong) NSString<Optional>* PhotoThumbnail;
@property(nonatomic, strong) NSArray* PhotoThumbnails;
@property(nonatomic, strong) NSArray* Photos;
@property(nonatomic, strong) NSString* Text;
@property(nonatomic, assign) int Type;
@property(nonatomic, strong) UserModel* User;

@end
