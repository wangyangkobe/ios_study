//
//  MessagePaginator.m
//  MicroSpeaker
//
//  Created by wy on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MessagePaginator.h"

@implementation MessagePaginator

#pragma mark - override Parent class's method
- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize
{
    NSString* pageUrl = [NSString stringWithFormat:@"%@?page=%d&num=%d", requestURL, page, pageSize];
    NSLog(@"requst URL = %@", pageUrl);
    
    // do request on async thread
    dispatch_queue_t fetchQ = dispatch_queue_create("Message fetcher", NULL);
    __block NSMutableArray* messagesArray = [NSMutableArray array];
    
    dispatch_async(fetchQ, ^{
        
        STHTTPRequest* request = [STHTTPRequest requestWithURLString:pageUrl];
        NSError *error = nil;
        NSString *jsonStr = [request startSynchronousWithError:&error];
        
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
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
    //dispatch_release(fetchQ);
}

@end
