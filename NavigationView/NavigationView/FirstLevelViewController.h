//
//  FirstLevelViewController.h
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLevelViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray* controllers;
}
@property(retain, nonatomic) NSArray* controllers;
@end
