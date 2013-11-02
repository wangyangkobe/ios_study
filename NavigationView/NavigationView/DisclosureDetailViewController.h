//
//  DisclosureDetailViewController.h
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisclosureDetailViewController : UIViewController
{
    NSString* message;
}
@property(nonatomic, copy)NSString* message;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
