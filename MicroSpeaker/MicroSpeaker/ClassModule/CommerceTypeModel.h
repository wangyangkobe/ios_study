//
//  CommerceTypeModel.h
//  MicroSpeaker
//
//  Created by wy on 14-1-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface CommerceTypeModel : JSONModel<NSCopying, NSCoding>

@property(nonatomic, assign) int Type;
@property(nonatomic, retain) NSString* TypeName;

@end
