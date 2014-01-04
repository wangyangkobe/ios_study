//
//  MessageModel.m
//  MicroSpeaker
//
//  Created by wy on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

@synthesize Activity  = _Activity;
@synthesize Area = _Area;
@synthesize Comments = _Comments;
@synthesize CommentsCount = _CommentsCount;
@synthesize CreateAt = _CreateAt;
@synthesize Location = _Location;
@synthesize MessageID = _MessageID;
@synthesize Photo = _Photo;
@synthesize PhotoThumbnail = _PhotoThumbnail;
@synthesize PhotoThumbnails = _PhotoThumbnails;
@synthesize Photos = _Photos;
@synthesize Text = _Text;
@synthesize Type = _Type;
@synthesize User = _User;
@synthesize Theme = _Theme;
@synthesize Tel = _Tel;
@synthesize Price = _Price;
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_CommentsCount forKey:@"CommentsCount"];
    [aCoder encodeInt64:_MessageID forKey:@"MessageID"];
    [aCoder encodeInt:_Type forKey:@"Type"];
    
    [aCoder encodeObject:_Activity forKey:@"Activity"];
    [aCoder encodeObject:_Area forKey:@"Area"];
    [aCoder encodeObject:_Comments forKey:@"Comments"];
    [aCoder encodeObject:_CreateAt forKey:@"CreateAt"];
    [aCoder encodeObject:_Location forKey:@"Location"];
    [aCoder encodeObject:_Photo forKey:@"Photo"];
    [aCoder encodeObject:_PhotoThumbnail forKey:@"PhotoThumbnail"];
    [aCoder encodeObject:_PhotoThumbnails forKey:@"PhotoThumbnails"];
    [aCoder encodeObject:_Photos forKey:@"Photos"];
    [aCoder encodeObject:_Text forKey:@"Text"];
    [aCoder encodeObject:_User forKey:@"User"];
    [aCoder encodeObject:_Theme forKey:@"Theme"];
    [aCoder encodeObject:_Tel forKey:@"Tel"];
    [aCoder encodeObject:_Price forKey:@"Price"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _CommentsCount = [aDecoder decodeIntForKey:@"CommentsCount"];
        _MessageID = [aDecoder decodeInt64ForKey:@"MessageID"];
        _Type = [aDecoder decodeIntForKey:@"Type"];
        
        _Activity = [aDecoder decodeObjectForKey:@"Activity"];
        _Area = [aDecoder decodeObjectForKey:@"Area"];
        _Comments = [aDecoder decodeObjectForKey:@"Comments"];
        _CreateAt = [aDecoder decodeObjectForKey:@"CreateAt"];
        _Location = [aDecoder decodeObjectForKey:@"Location"];
        
        _Photo = [aDecoder decodeObjectForKey:@"Photo"];
        _PhotoThumbnail = [aDecoder decodeObjectForKey:@"PhotoThumbnail"];
        _PhotoThumbnails = [aDecoder decodeObjectForKey:@"PhotoThumbnails"];
        _Photos = [aDecoder decodeObjectForKey:@"Photos"];
        _Text = [aDecoder decodeObjectForKey:@"Text"];
        _User = [aDecoder decodeObjectForKey:@"User"];
        _Theme = [aDecoder decodeObjectForKey:@"Theme"];
        _Tel = [aDecoder decodeObjectForKey:@"Tel"];
        _Price = [aDecoder decodeObjectForKey:@"Price"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    MessageModel* copy = [[MessageModel allocWithZone:zone] init];
    copy.CommentsCount = self.CommentsCount;
    copy.MessageID = self.MessageID;
    copy.Type = self.Type;
    
    copy.Activity = [self.Activity copyWithZone:zone];
    copy.Area = [self.Area copyWithZone:zone];
    copy.Comments = [self.Comments copyWithZone:zone];
    copy.CreateAt = [self.CreateAt copyWithZone:zone];
    copy.Location = [self.Location copyWithZone:zone];
    copy.Photo = [self.Photo copyWithZone:zone];
    copy.PhotoThumbnail = [self.PhotoThumbnail copyWithZone:zone];
    copy.PhotoThumbnails = [self.PhotoThumbnails copyWithZone:zone];
    copy.Text = [self.Text copyWithZone:zone];
    copy.User = [self.User copyWithZone:zone];
    copy.Theme = [self.Theme copyWithZone:zone];
    copy.Tel = [self.Tel copyWithZone:zone];
    copy.Price = [self.Price copyWithZone:zone];
    return copy;
}

@end
