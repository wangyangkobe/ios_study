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
@interface PersonalSettingViewController ()

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
    if ([userConfig isLogIn] == NO) {
        LogInViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView dataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - UITableView delegate Methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"CellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = @"登录";
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    LogInViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
