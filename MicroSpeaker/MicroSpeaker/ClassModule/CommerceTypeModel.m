//
//  CommerceTypeModel.m
//  MicroSpeaker
//
//  Created by wy on 14-1-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommerceTypeModel.h"

@implementation CommerceTypeModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_Type forKey:@"Type"];
    [aCoder encodeObject:_TypeName forKey:@"TypeName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Type = [aDecoder decodeIntForKey:@"Type"];
        _TypeName = [aDecoder decodeObjectForKey:@"TypeName"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    CommerceTypeModel* copy = [[CommerceTypeModel allocWithZone:zone] init];
    
    copy.Type = self.Type;
    copy.TypeName = [self.TypeName copyWithZone:zone];
    return copy;
}

@end
