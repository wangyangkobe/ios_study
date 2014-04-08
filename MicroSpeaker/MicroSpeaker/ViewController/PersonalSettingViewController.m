//
//  PersonalInfoViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-2-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "LogInViewController.h"
#import "UserConfig.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface PersonalSettingViewController ()
{
    UIView* footerView;
}

@end

@implementation PersonalSettingViewController

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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UserConfig* userConfig = [UserConfig shareInstance];
    NSLog(@"user = %@", [userConfig description]);
    if ([userConfig isLogIn] == NO)
    {
        LogInViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
        return;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
        return 4;
    else
        return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - UITableView delegate Methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row;
    int section = indexPath.section;
    
    if (0 == row && 0 == section)
    {
        static NSString* cellIdentifier = @"HeadPicCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIImageView* headPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
            [headPicView setBackgroundColor:[UIColor clearColor]];
            [headPicView setTag:3001];
            
            UILabel* userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 150, 40)];
            [userNameLabel setTag:3002];
            [userNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:headPicView];
            [cell.contentView addSubview:userNameLabel];
        }
        
        UIImageView* headPicView = (UIImageView*)[cell viewWithTag:3001];
        [headPicView setImageWithURL:[NSURL URLWithString:[UserConfig shareInstance].headPic]
                    placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        UILabel* userNameLabel = (UILabel*)[cell viewWithTag:3002];
        [userNameLabel setText:[UserConfig shareInstance].userName];
        
        return cell;
    }
    
    static NSString* cellIdentifier = @"PSettingCellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(1 == row && 0 == section)
    {
        [cell.textLabel setText:@"主页"];
    }
    else if(2 == row && 0 == section)
    {
        [cell.textLabel setText:@"社区"];
        if ([UserConfig shareInstance].areaID == kFuDan)
            [cell.detailTextLabel setText:@"复旦大学"];
        else if([UserConfig shareInstance].areaID == kHuaLi)
            [cell.detailTextLabel setText:@"华东理工大学"];
    }
    else if (3 == row && 0 == section)
    {
        [cell.textLabel setText:@"性别"];
        if ([UserConfig shareInstance].gender == kBoy)
            [cell.detailTextLabel setText:@"男"];
        else
            [cell.detailTextLabel setText:@"女"];
    }
    else if(0 == row && 1 == section)
    {
        [cell.textLabel setText:@"免打扰模式"];
        [cell.detailTextLabel setText:@"23:00~6:00不接受消息"];
    }
    else
    {
        [cell.textLabel setText:@"意见和建议"];
    }
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = indexPath.row;
    int section = indexPath.section;
    
    if (0 == row && section == 0)
        return 60;
    else
        return 40;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (1 == section)
        return 50;
    else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (1 == section)
    {
        if (nil == footerView)
        {
            footerView  = [[UIView alloc] init];
    
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor redColor]];
            [button setFrame:CGRectMake(10, 3, 300, 44)];
            
            [button setTitle:@"注销登录" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
            
            [footerView addSubview:button];
        }
        return footerView;
    }
    else
        return nil;
}
-(void)logOut
{
    BOOL result = [[NetWorkConnection sharedInstance] userLogOut];
    
    if (result)
    {
        [[UserConfig shareInstance] setLogIn:NO];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UITabBarController* mainTableVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVCIdentifier"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:mainTableVC];
    }
}
@end
