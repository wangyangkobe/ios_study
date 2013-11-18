//
//  MainTabViewController.h
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PullRefreshTableViewController.h"

#define kFileName @"MessageData.plist"
#define kDataKey @"MessageData"

@interface MainTabViewController : PullRefreshTableViewController
{
    NSMutableArray* messageArray;
    NSMutableDictionary* heightCache;
    UIActivityIndicatorView* spinner;
}
@property(nonatomic, copy) NSMutableArray* messageArray;

@end
