//
//  President.h
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPresidentNumberKey @"President"
#define kPresidentNameKey   @"Name"
#define kPresidentFromKey   @"FromYear"
#define kPresidentToKey     @"ToYear"
#define kPresidentPartyKey  @"Party"

@interface President : NSObject<NSCoding>
{
    int number;
    NSString* name;
    NSString* fromYear;
    NSString* toYear;
    NSString* party;
}
@property int number;
@property(copy, nonatomic) NSString* name;
@property(copy, nonatomic) NSString* fromYear;
@property(copy, nonatomic) NSString* toYear;
@property(copy, nonatomic) NSString* party;
@end
