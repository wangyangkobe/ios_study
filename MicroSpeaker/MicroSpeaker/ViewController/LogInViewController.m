//
//  LogInViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-2-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()
@property (nonatomic, retain)NSArray* permissions;
@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"login.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:image];
    
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"101049592" andDelegate:self];
    _tencentOAuth.redirectURI = @"www.qq.com";
    _permissions = [NSArray arrayWithObjects:@"get_user_info", @"add_t", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sinaLogIn:(id)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LogInViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)qqLogIn:(id)sender
{
    [_tencentOAuth authorize:_permissions inSafari:NO];
}
- (void)tencentDidLogin
{
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"accessToken = %@", _tencentOAuth.accessToken);
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
}
-(void)tencentDidNotNetWork
{
}
@end
