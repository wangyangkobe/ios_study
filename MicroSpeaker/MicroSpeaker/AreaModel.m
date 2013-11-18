//
//  Area.m
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

@synthesize AreaID = _AreaID;
@synthesize AreaName = _AreaName;
@synthesize City = _City;
@synthesize Type = _Type;
@synthesize TypeName = _TypeName;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[NSNumber numberWithInt:_Type] forKey:@"Type"];
    [aCoder encodeObject:[NSNumber numberWithInt:_AreaID] forKey:@"AreaID"];
    
    [aCoder encodeObject:_AreaName forKey:@"AreaName"];
    [aCoder encodeObject:_City forKey:@"City"];
    [aCoder encodeObject:_TypeName forKey:@"TypeName"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _AreaID = [[aDecoder decodeObjectForKey:@"AreaID"] integerValue];
        _Type   = [[aDecoder decodeObjectForKey:@"Type"] integerValue];
        
        _AreaName  = [aDecoder decodeObjectForKey:@"AreaName"];
        _City = [aDecoder decodeObjectForKey:@"City"];
        _TypeName = [aDecoder decodeObjectForKey:@"TypeName"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    AreaModel* copy = [[AreaModel allocWithZone:zone] init];
    copy.AreaID = self.AreaID;
    copy.Type = self.Type;
    
    copy.AreaName = [self.AreaName copyWithZone:zone];
    copy.City  = [self.City copyWithZone:zone];
    copy.TypeName = [self.TypeName copyWithZone:zone];
    return copy;
}
@end
