//
//  CommentModel.m
//  MicroSpeaker
//
//  Created by wy on 13-12-6.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_CommentID forKey:@"CommentID"];
    [aCoder encodeInt:_MessageID forKey:@"MessageID"];
    [aCoder encodeInteger:_ReplyCommentID forKey:@"ReplyCommentID"];
    
    [aCoder encodeObject:_UserBasic forKey:@"UserBasic"];
    [aCoder encodeObject:_Message forKey:@"Message"];
    [aCoder encodeObject:_Text forKey:@"Text"];
    [aCoder encodeObject:_CreateAt forKey:@"CreateAt"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _CommentID = [aDecoder decodeIntForKey:@"CommentID"];
        _MessageID = [aDecoder decodeIntForKey:@"MessageID"];
        _ReplyCommentID = [aDecoder decodeIntForKey:@"ReplyCommentID"];
        
        _UserBasic = [aDecoder decodeObjectForKey:@"UserBasic"];
        _Message = [aDecoder decodeObjectForKey:@"Message"];
        _Text = [aDecoder decodeObjectForKey:@"Text"];
        _CreateAt = [aDecoder decodeObjectForKey:@"CreateAt"];
    }
    return self;
}

#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    CommentModel* copy = [[CommentModel allocWithZone:zone] init];
    
    copy.CommentID = self.CommentID;
    copy.MessageID = self.MessageID;
    copy.ReplyCommentID = self.ReplyCommentID;
    
    copy.UserBasic = [self.UserBasic copyWithZone:zone];
    copy.Message = [self.Message copyWithZone:zone];
    copy.Text = [self.Text copyWithZone:zone];
    copy.CreateAt = [self.CreateAt copyWithZone:zone];
    return copy;
}
@end
