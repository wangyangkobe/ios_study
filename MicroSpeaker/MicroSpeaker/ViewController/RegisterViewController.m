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
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                           initWithTitle: @"请选择社区"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"复旦大学,上海市", @"华东理工大学,上海市", nil];
    
//    for (NSString* areaName in areaNamesArray) {
//        [actionSheet addButtonWithTitle:areaName];
//    }
    [actionSheet showInView:self.view];
}

#pragma mark ActionSheet Delegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* areaName = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self.selectAreaBtn setTitle:areaName forState:UIControlStateNormal];
    if ([areaName rangeOfString:@"复旦大学"].location != NSNotFound)
    {
        [UserConfig shareInstance].areaID = kFuDan;
    }
    else if([areaName rangeOfString:@"华东理工大学"].location != NSNotFound)
    {
        [UserConfig shareInstance].areaID = kHuaLi;
    }
}

- (IBAction)doRegisterBtn:(id)sender
{
    NSString* headPic     = [UserConfig shareInstance].headPic;
    NSString* userName    = [UserConfig shareInstance].userName;
    NSString* description = [UserConfig shareInstance].signature;
    NSString* regKeyID    = [UserConfig shareInstance].weiboID;
    NSString* appName;
    if (regKeyID) {
        appName = @"sinaweibo";
    }
    else{
        appName = @"tencentqq";
        regKeyID = [UserConfig shareInstance].qqOpenID;
    }

    NSString* province    = [UserConfig shareInstance].province;
    NSString* city        = [UserConfig shareInstance].city;
    int gender  = [UserConfig shareInstance].gender;
    long areaID = [UserConfig shareInstance].areaID;
   
    BOOL registerRes = [[NetWorkConnection sharedInstance] userRegisterByApp:appName name:userName gender:gender description:description areaID:areaID registerKeyID:regKeyID province:province city:city country:@"中国" headPic:headPic];
    
    if (registerRes) {
        [[UserConfig shareInstance] setLogIn:YES];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UITabBarController* mainTableVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarVCIdentifier"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:mainTableVC];
    }
}
@end
