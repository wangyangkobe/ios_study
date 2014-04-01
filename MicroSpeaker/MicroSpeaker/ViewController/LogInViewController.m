//
//  LogInViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-2-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "LogInViewController.h"
#import "RegisterViewController.h"

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
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:kTencentQQAppKey andDelegate:self];
    _tencentOAuth.redirectURI = kTencentQQRedirectURI;
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
    request.redirectURI = kSinaRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LogInViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    [UserConfig shareInstance].logInMethod = kSinaWeiBoLogIn;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)qqLogIn:(id)sender
{
    [_tencentOAuth authorize:_permissions inSafari:NO];
}
- (void)tencentDidLogin
{
    [UserConfig shareInstance].logInMethod = kTencentQQLogIn;
    if (_tencentOAuth.accessToken && (0 != [_tencentOAuth.accessToken length]))
    {
        // 记录登录用户的OpenID、Token以及过期时间
        NSLog(@"accessToken = %@, openId = %@, expireDate = %@", _tencentOAuth.accessToken,
              _tencentOAuth.openId,
              _tencentOAuth.expirationDate);
        
        [[NetWorkConnection sharedInstance] getUserQQInfo:_tencentOAuth.accessToken OpenID:_tencentOAuth.openId];
        
        BOOL checkUser = [[NetWorkConnection sharedInstance] checkUserQQ:_tencentOAuth.openId];
        [UserConfig shareInstance].registerKey = _tencentOAuth.openId;
        
        if (checkUser)
        {
            [[UserConfig shareInstance] setLogIn:YES];
            NSLog(@"user login successfully from QQ!");
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UserInfoModel* selfUserInfo = [[NetWorkConnection sharedInstance] showSelfUserInfo];
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selfUserInfo];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:encodedObject forKey:SELF_USERINFO];
                [defaults synchronize];
            });
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            UITabBarController* mainTableVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVCIdentifier"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:mainTableVC];
        }
        else
        {
            [[UserConfig shareInstance] setLogIn:NO];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            RegisterViewController* registerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterVCIdentifier"];
            [[UIApplication sharedApplication].keyWindow setRootViewController:registerVC];
        }
    }
    else
    {
        NSLog(@"Tencent QQ登录不成功, 没有获取accesstoken.");
    }
}
-(void)tencentDidNotLogin:(BOOL)cancelled
{
}
-(void)tencentDidNotNetWork
{
}
@end
