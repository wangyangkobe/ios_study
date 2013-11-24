//
//  Location.m
//  JSON
//
//  Created by wy on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

//@synthesize City, Country, Latitude, LocationAddress, LocationID, Longitude, Province;

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_Latitude  forKey:@"Latitude"];
    [aCoder encodeInt:_LocationID  forKey:@"LocationID"];
    [aCoder encodeInt:_Longitude  forKey:@"Longitude"];
    
    [aCoder encodeObject:_City forKey:@"City"];
    [aCoder encodeObject:_Country forKey:@"Country"];
    [aCoder encodeObject:_LocationAddress forKey:@"LocationAddress"];
    [aCoder encodeObject:_LocationDescription forKey:@"LocationDescription"];
    [aCoder encodeObject:_Province forKey:@"Province"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Latitude = [aDecoder decodeIntForKey:@"Latitude"];
        _LocationID = [aDecoder decodeIntForKey:@"LocationID"];
        _Longitude = [aDecoder decodeIntForKey:@"Longitude"];
        
        _City = [aDecoder decodeObjectForKey:@"City"];
        _Country = [aDecoder decodeObjectForKey:@"Country"];
        _LocationAddress = [aDecoder decodeObjectForKey:@"LocationAddress"];
        _LocationDescription = [aDecoder decodeObjectForKey:@"LocationDescription"];
        _Province = [aDecoder decodeObjectForKey:@"Province"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    LocationModel* copy = [[LocationModel allocWithZone:zone] init];
    copy.Latitude = self.Latitude;
    copy.LocationID = self.LocationID;
    copy.Longitude = self.Longitude;
    
    copy.City = [self.City copyWithZone:zone];
    copy.Country = [self.Country copyWithZone:zone];
    copy.LocationAddress = [self.LocationAddress copyWithZone:zone];
    copy.LocationDescription = [self.LocationDescription copyWithZone:zone];
    copy.Province = [self.Province copyWithZone:zone];
    return copy;
}
@end
