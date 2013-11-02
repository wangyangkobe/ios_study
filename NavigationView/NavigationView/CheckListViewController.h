//
//  CheckListViewController.h
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"
@interface CheckListViewController : SecondLevelViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* checkLists;
    NSIndexPath* lastIndexPath;
}
@property(nonatomic, retain) NSArray* checkLists;
@property(nonatomic, retain) NSIndexPath* lastIndexPath;
@end
