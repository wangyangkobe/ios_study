//
//  MainTabViewController.h
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefination.h"
#import "NetWorkConnection.h"
#import "PullTableView.h"

#define kFileName @"MessageData.plist"
#define kDataKey @"MessageData"

@interface MainTabViewController : UIViewController<UITableViewDataSource, PullTableViewDelegate, UITableViewDelegate>

@property(nonatomic, copy) NSMutableArray* messagesArray;

@property (nonatomic, retain) IBOutlet PullTableView* pullTableView;


@end
