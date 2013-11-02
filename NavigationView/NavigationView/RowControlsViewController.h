//
//  RowControlsViewController.h
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"
@interface RowControlsViewController : SecondLevelViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* dataList;
}
@property(nonatomic, retain) NSArray* dataList;
-(IBAction)buttonTapped:(id)sender;
@end
