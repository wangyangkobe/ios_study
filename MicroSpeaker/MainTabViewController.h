//
//  MainTabViewController.h
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PullRefreshTableViewController.h"
@interface MainTabViewController : PullRefreshTableViewController
{
    NSMutableArray* userInfoArr;
}
@property(nonatomic, copy) NSMutableArray* userInfoArr;

@end
