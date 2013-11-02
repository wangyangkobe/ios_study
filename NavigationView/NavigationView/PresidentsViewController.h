//
//  PresidentsViewController.h
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"

@interface PresidentsViewController : SecondLevelViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* presidentList;
}
@property(nonatomic, retain) NSMutableArray* presidentList;
@end
