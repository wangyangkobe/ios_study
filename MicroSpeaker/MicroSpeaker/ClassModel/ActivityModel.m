//
//  Activity.m
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

@synthesize Address = _Address;
@synthesize Description = _Description;
@synthesize FromTime = _FromTime;
@synthesize Tel = _Tel;
@synthesize Theme = _Theme;
@synthesize ToTime = _ToTime;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [aCoder encodeObject:_Address forKey:@"Address"];
    [aCoder encodeObject:_Description forKey:@"Description"];
    [aCoder encodeObject:_FromTime forKey:@"FromTime"];
    [aCoder encodeObject:_Tel forKey:@"Tel"];
    [aCoder encodeObject:_Theme forKey:@"Theme"];
    [aCoder encodeObject:_ToTime forKey:@"ToTime"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Address = [aDecoder decodeObjectForKey:@"Address"];
        _Description = [aDecoder decodeObjectForKey:@"Description"];
        _FromTime = [aDecoder decodeObjectForKey:@"FromTime"];
        _Tel = [aDecoder decodeObjectForKey:@"Tel"];
        _Theme = [aDecoder decodeObjectForKey:@"Theme"];
        _ToTime = [aDecoder decodeObjectForKey:@"ToTime"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    ActivityModel* copy = [[ActivityModel allocWithZone:zone] init];
    copy.Address = [self.Address copyWithZone:zone];
    copy.Description = [self.Description copyWithZone:zone];
    copy.FromTime = [self.FromTime copyWithZone:zone];
    copy.Tel = [self.Tel copyWithZone:zone];
    copy.Theme = [self.Theme copyWithZone:zone];
    copy.ToTime  = [self.ToTime copyWithZone:zone];
    return copy;
}
@end
