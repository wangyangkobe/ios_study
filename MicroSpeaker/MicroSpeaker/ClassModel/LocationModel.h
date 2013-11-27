//
//  Location.h
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface LocationModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, strong) NSString* City;
@property(nonatomic, strong) NSString* Country;
@property(nonatomic, assign) int  Latitude;
@property(nonatomic, strong) NSString* LocationAddress;
@property(nonatomic, strong) NSString* LocationDescription;
@property(nonatomic, assign) int LocationID;
@property(nonatomic, assign) int Longitude;
@property(nonatomic, strong) NSString* Province;

@end
