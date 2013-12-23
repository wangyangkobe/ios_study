//
//  NMPaginator.h
//
//  Created by Nicolas Mondollot on 07/04/12.
//

#import <Foundation/Foundation.h>

typedef enum {
    RequestStatusNone,
    RequestStatusInProgress,
    RequestStatusDone // request succeeded or failed
} RequestStatus;

@protocol NMPaginatorDelegate
@required
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results;
@optional
- (void)paginatorDidFailToRespond:(id)paginator;
- (void)paginatorDidReset:(id)paginator;
@end

@interface NMPaginator : NSObject {
    id <NMPaginatorDelegate> __weak delegate;
}

@property (weak) id delegate;
@property (assign, readonly) NSInteger pageSize; // number of results per page
@property (assign, readonly) NSInteger page; // number of pages already fetched
@property (assign, readonly) NSInteger total; // total number of results
@property (assign, readonly) RequestStatus requestStatus;
@property (nonatomic, strong, readonly) NSMutableArray *results;

@property(nonatomic, assign) long lastMessageId; //上次获取到的最后一条消息ID，第一次request的值为-1

- (id)initWithPageSize:(NSInteger)pageSize delegate:(id<NMPaginatorDelegate>)paginatorDelegate;
- (void)reset;
- (BOOL)reachedLastPage;

- (void)fetchFirstPage;
- (void)fetchNextPage;

// call these from subclass when you receive the results
- (void)receivedResults:(NSArray *)results total:(NSInteger)total;
- (void)failed;

@end
