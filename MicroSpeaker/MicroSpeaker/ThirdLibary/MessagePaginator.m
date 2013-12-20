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
#include "NetWorkConnection.h"
@implementation MessagePaginator

#pragma mark - override Parent class's method
- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    // do request on async thread
    dispatch_queue_t fetchQ = dispatch_queue_create("Message fetcher", NULL);
    
    dispatch_async(fetchQ, ^{
        NSArray* messagesArray = [[NetWorkConnection sharedInstance] getMessageByAreaID:2 PageSize:pageSize Page:page];
        
        // go back to main thread before adding results
        dispatch_sync(dispatch_get_main_queue(), ^{
            int totalResults = [messagesArray count] + self.total;
            [self receivedResults:messagesArray total:totalResults];
        });
    });
}

@end
