//
//  MoveAndDeleteViewController.h
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SecondLevelViewController.h"
@interface MoveAndDeleteViewController : SecondLevelViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* dataList;
}
@property(nonatomic, retain) NSMutableArray* dataList;
-(IBAction)toggleMove;
-(IBAction)toggleDelete;
@property (weak, nonatomic) IBOutlet UITableView *childTableView;
@end
