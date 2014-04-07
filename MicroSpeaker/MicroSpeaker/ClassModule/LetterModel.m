//
//  LetterModel.m
//  MicroSpeaker
//
//  Created by wy on 14-4-7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "LetterModel.h"
#import "JSONKit.h"

@implementation Letter : JSONModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_LetterID    forKey:@"LetterID"];
    
    [aCoder encodeObject:_CreateAt forKey:@"CreateAt"];
    [aCoder encodeObject:_FromUser forKey:@"FromUser"];
    [aCoder encodeObject:_ToUser   forKey:@"ToUser"];
    [aCoder encodeObject:_Text     forKey:@"Text"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _LetterID = [aDecoder decodeIntForKey:@"LetterID"];
        
        _CreateAt = [aDecoder decodeObjectForKey:@"CreateAt"];
        _FromUser = [aDecoder decodeObjectForKey:@"FromUser"];
        _ToUser   = [aDecoder decodeObjectForKey:@"ToUser"];
        _Text     = [aDecoder decodeObjectForKey:@"Text"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    Letter* copy = [[Letter allocWithZone:zone] init];
    
    copy.LetterID  = self.LetterID;
    copy.CreateAt  = [self.CreateAt copyWithZone:zone];
    copy.FromUser  = [self.FromUser copyWithZone:zone];
    copy.ToUser    = [self.ToUser copyWithZone:zone];
    copy.Text      = [self.Text copyWithZone:zone];
    return copy;
}
@end



@implementation LetterModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_Letter   forKey:@"Letter"];
    [aCoder encodeObject:_User     forKey:@"User"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _Letter = [aDecoder decodeObjectForKey:@"Letter"];
        _User     = [aDecoder decodeObjectForKey:@"User"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    LetterModel* copy = [[LetterModel allocWithZone:zone] init];
    
    copy.Letter = [self.Letter copyWithZone:zone];
    copy.User   = [self.User copyWithZone:zone];
    return copy;
}


@end
