//
//  RegisterViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-3-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIImage+Extensions.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UserConfig.h"
#import "NetWorkConnection.h"
@interface RegisterViewController ()<UIActionSheetDelegate>
{
    NSMutableArray* areaNamesArray;
}
@end

@implementation RegisterViewController

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
    [self.headPicImageView setImageWithURL:[NSURL URLWithString:[UserConfig shareInstance].headPic]
                          placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.userNameLabel setText:[UserConfig shareInstance].userName];
    
    if ([UserConfig shareInstance].gender == kBoy)
        [self.genderLabel setText:@"男"];
    else if([UserConfig shareInstance].gender == kGirl)
        [self.genderLabel setText:@"女"];
    else
        [self.genderLabel setText:@"未知"];
    
    [self.signatureLabel setText:[UserConfig shareInstance].signature];
    
    
    _selectAreaBtn.layer.borderWidth = 1;
    _selectAreaBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    _selectAreaBtn.layer.cornerRadius = 5;
    
    areaNamesArray = [NSMutableArray array];
    for (AreaModel* element in [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getArea]])
    {
        [areaNamesArray addObject:[NSString stringWithFormat:@"%@,%@", element.AreaName, element.City]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    _selectAreaBtn = nil;
    [super viewDidUnload];
}
- (IBAction)selectAreaBtnPressed:(id)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"请选择社区"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"复旦大学,上海市", @"华东理工大学,上海市", nil];
    [menu showInView:self.view];
}

- (IBAction)doRegisterBtn:(id)sender
{
    NSString* headPic = [UserConfig shareInstance].headPic;
    NSString* userName = [UserConfig shareInstance].userName;
    int gender = [UserConfig shareInstance].gender;
    NSString* description = [UserConfig shareInstance].description;
    long areaID = 2;
    NSString* weiboID = [UserConfig shareInstance].weiboID;
    BOOL registerRes = [[NetWorkConnection sharedInstance] registerByWeiBo:userName gender:gender description:description areaID:areaID weiboID:weiboID province:@"上海市" city:@"上海市" country:@"中国" headPic:headPic];
    
    if (registerRes) {
        [[UserConfig shareInstance] setLogIn:YES];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UITabBarController* mainTableVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVCIdentifier"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:mainTableVC];
    }
}
@end
