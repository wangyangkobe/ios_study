//
//  Area.h
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface AreaModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, assign) int AreaID;
@property(nonatomic, strong) NSString* AreaName;
@property(nonatomic, strong) NSString* City;
@property(nonatomic, assign) int Type;
@property(nonatomic, strong) NSString* TypeName;

@end
