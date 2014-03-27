//
//  LogInViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-2-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController<WBHttpRequestDelegate, TencentSessionDelegate>

@property (nonatomic, retain)TencentOAuth *tencentOAuth;

- (IBAction)sinaLogIn:(id)sender;
- (IBAction)qqLogIn:(id)sender;

@end
