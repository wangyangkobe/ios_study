//
//  DisclosureButtonViewController.h
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondLevelViewController.h"
#import "DisclosureDetailViewController.h"
@interface DisclosureButtonViewController : SecondLevelViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* list;
    DisclosureDetailViewController* disclosureDetail;
}
@property(nonatomic, retain) NSArray* list;
@end
