//
//  MessagePaginator.m
//  MicroSpeaker
//
//  Created by wy on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MessagePaginator.h"
#import "ASIHTTPRequest.h"
#import "MacroDefination.h"
#import "NetWorkConnection.h"
#import "UserInfoModel.h"
@implementation MessagePaginator

#pragma mark - override Parent class's method
- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    NSLog(@"%@: maxID = %ld", NSStringFromSelector(_cmd), self.lastMessageId);
    
    if (selfUserInfo == nil) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
        selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    }
    long areaID = selfUserInfo.Area.AreaID;
    // do request on async thread
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray* messagesArray = nil;
        if (self.lastMessageId == -1)
            messagesArray = [[NetWorkConnection sharedInstance] getMessageByAreaID:areaID PageSize:pageSize Page:page];
        else
            messagesArray = [[NetWorkConnection sharedInstance] getMessageByAreaID:areaID PageSize:pageSize maxID:self.lastMessageId];
        
        // go back to main thread before adding results
        dispatch_sync(dispatch_get_main_queue(), ^{
            int totalResults = [messagesArray count] + self.total;
            [self receivedResults:messagesArray total:totalResults];
        });
    });
}

@end
