//
//  MainTabViewController.h
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "MessagePaginator.h"

#define kFileName @"MessageData.plist"
#define kDataKey @"MessageData"

@interface MainTabViewController : PullRefreshTableViewController<NMPaginatorDelegate>
{
    NSMutableArray* messageArray;
    NSMutableDictionary* heightCache;
    UIActivityIndicatorView* screenActivityIndicator;
}

@property(nonatomic, copy) NSMutableArray* messageArray;

// this property for NMPaginator
@property (nonatomic, strong) MessagePaginator *messagePaginator;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *footerActivityIndicator;

@end
