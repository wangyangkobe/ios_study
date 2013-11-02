//
//  President.m
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "President.h"

@implementation President

@synthesize number;
@synthesize name;
@synthesize fromYear;
@synthesize toYear;
@synthesize party;

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.number forKey:kPresidentNumberKey];
    [aCoder encodeObject:self.name forKey:kPresidentNameKey];
    [aCoder encodeObject:self.fromYear forKey:kPresidentFromKey];
    [aCoder encodeObject:self.toYear forKey:kPresidentToKey];
    [aCoder encodeObject:self.party forKey:kPresidentPartyKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        number = [aDecoder decodeIntForKey:kPresidentNumberKey];
        name = [aDecoder decodeObjectForKey:kPresidentNameKey];
        fromYear = [aDecoder decodeObjectForKey:kPresidentFromKey];
        toYear = [aDecoder decodeObjectForKey:kPresidentToKey];
        party =[aDecoder decodeObjectForKey:kPresidentPartyKey];
    }
    return self;
}
@end
