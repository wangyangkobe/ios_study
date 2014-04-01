//
//  AppDelegate.m
//  MicroSpeaker
//
//  Created by yang on 13-11-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "MainTabViewController.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaAppKey];
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"sourceApplication = %@", sourceApplication);
    
    if ([sourceApplication isEqualToString:@"com.sina.weibo"])
        return [WeiboSDK handleOpenURL:url delegate:self];
    else  //com.tencent.mqq
        return [TencentOAuth HandleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        NSString* userID = [(WBAuthorizeResponse*)response userID];
        NSLog(@"userID = %@", userID);
        [[NetWorkConnection sharedInstance] getUserWeiBoInfo:self.wbtoken UserID:userID];
        
        NetWorkConnection* connect = [NetWorkConnection sharedInstance];
        if ([connect checkUser:userID])
        {
            [[UserConfig shareInstance] setLogIn:YES];
            
            NSLog(@"user login successfully from sina weibo!");
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UserInfoModel* selfUserInfo = [[NetWorkConnection sharedInstance] showSelfUserInfo];
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selfUserInfo];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:encodedObject forKey:SELF_USERINFO];
                [defaults synchronize];
            });
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            UITabBarController* mainTableVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVCIdentifier"];
            [self.window setRootViewController:mainTableVC];
        }
        else
        {
            [[UserConfig shareInstance] setLogIn:NO];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            RegisterViewController* registerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegisterVCIdentifier"];
            [self.window setRootViewController:registerVC];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
