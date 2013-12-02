//
//  MessagePaginator.m
//  MicroSpeaker
//
//  Created by wy on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MessagePaginator.h"
#import "ASIHTTPRequest.h"
@implementation MessagePaginator

#pragma mark - override Parent class's method
- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    NSString* pageUrl = [NSString stringWithFormat:@"%@/message/getByArea?areaID=2&page=%d&num=%d", homePageUrl, page, pageSize];
    NSLog(@"requst URL = %@", pageUrl);
    
    // do request on async thread
    dispatch_queue_t fetchQ = dispatch_queue_create("Message fetcher", NULL);
    __block NSMutableArray* messagesArray = [NSMutableArray array];
    
    dispatch_async(fetchQ, ^{
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:
                                    [NSURL URLWithString:pageUrl]];
        [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
        [request setProxyPort:8080];
        [request startSynchronous];
        NSLog(@"result = %@", [request responseString]);
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        for (id entry in jsonArray)
        {
            [messagesArray addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
        }
        // go back to main thread before adding results
        dispatch_sync(dispatch_get_main_queue(), ^{
            int totalResults = [messagesArray count] + self.total;
            [self receivedResults:messagesArray total:totalResults];
        });
    });
}

@end
