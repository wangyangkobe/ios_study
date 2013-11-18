//
//  Activity.h
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ActivityModel : JSONModel<NSCopying, NSCoding>

@property(strong, nonatomic) NSString* Address;
@property(strong, nonatomic) NSString* Description;
@property(strong, nonatomic) NSString* FromTime;
@property(strong, nonatomic) NSString* Tel;
@property(strong, nonatomic) NSString* Theme;
@property(strong, nonatomic) NSString* ToTime;

@end
