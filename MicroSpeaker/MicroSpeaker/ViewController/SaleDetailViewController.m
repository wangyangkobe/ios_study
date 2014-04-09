//
//  SaleDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-1-4.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "SaleDetailViewController.h"
#import "NSString+Extensions.h"
#import "UILabel+Extensions.h"
#import "UIImage+Extensions.h"
#import "MacroDefination.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIButton+Extensions.h"
#import "PrivateMessageViewController.h"
@interface SaleDetailViewController ()

@end

@implementation SaleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES; //隐藏TabBar
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.hidesBottomBarWhenPushed = YES; //隐藏TabBar
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView layoutSubviews];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (SaleMessage == _message.Type)
        self.title = @"转让";
    else
        self.title = @"求购";
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_detail_menu_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareSaleMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self.phoneNumberBtn setBackgroundColor:[UIColor colorWithRed:0.97 green:0.67 blue:0.25 alpha:1.0]];
    [self.phoneNumberBtn setTitle:[NSString stringWithFormat:@"请拨打：%@", _message.Tel] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)shareSaleMessage
{
}

#pragma mark UITableView dataSource
-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 0;
    else
        return 2;
}
#pragma mark UITableView delegate method
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    NSLog(@"row = %d", row);
    if (1 == section)
    {
        if (0 == row || row == 1) {
            static NSString* CellIdentifier = @"CellIdentifer";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
                [imageView setTag:1000];
                [cell.contentView addSubview:imageView];
                UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, SCREEN_WIDTH - 42, 44)];
                [textLabel setTag:1001];
                [cell.contentView addSubview:textLabel];
                [textLabel setFont:[UIFont systemFontOfSize:20]];
            }
            UIImageView* imageView = (UIImageView*)[cell.contentView viewWithTag:1000];
            UILabel* textLabel = (UILabel*)[cell.contentView viewWithTag:1001];
            if (0 == row) {
                textLabel.text = [NSString stringWithFormat:@"%@元左右", _message.Price];
                imageView.image = [UIImage imageNamed:@"vad_icon_price"];
                textLabel.textColor = [UIColor greenColor];
            }else{
                imageView.image = [UIImage imageNamed:@"vad_icon_location"];
                textLabel.text = _message.Area.AreaName;
                textLabel.textColor = [UIColor blackColor];
            }
            return cell;
        }
    }
    else if(section == 2)
    {
        if (row == 1) {
            static NSString* CellIdentifier = @"SalerInfoCellIdentifer";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel* salerNameLabel  = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 20)];
                UILabel* createTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 10, 20)];
                [salerNameLabel setTag:2000];
                [createTimeLabel setTag:2001];
                [salerNameLabel setTextColor:[UIColor grayColor]];
                [createTimeLabel setTextColor:[UIColor grayColor]];
                [cell.contentView addSubview:salerNameLabel];
                [cell.contentView addSubview:createTimeLabel];
            }
            UILabel* label = (UILabel*)[cell viewWithTag:2000];
            label.text = [NSString stringWithFormat:@"发布人：%@", _message.User.UserName];
            label = (UILabel*)[cell viewWithTag:2001];
            label.text = [NSString stringWithFormat:@"发布时间：%@", _message.CreateAt];
            
            return cell;
        }
        
        static NSString* CellIdentifier = @"DescriptionCellIdentifer";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel* textLabel = [[UILabel alloc] init];
            [textLabel setTag:2003];
            [cell.contentView addSubview:textLabel];
        }
        UILabel* textLabel = (UILabel*)[cell viewWithTag:2003];
        float textHeight = [_message.Text sizeWithFont:[UIFont boldSystemFontOfSize:17]
                                     constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        [textLabel setFrame:CGRectMake(10, 0, SCREEN_WIDTH, textHeight)];
        [textLabel setText:_message.Text];
        [textLabel sizeToFitFixedWidth:SCREEN_WIDTH - 10 lines:10];
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == 0) {
        float textHeight = [_message.Text sizeWithFont:[UIFont boldSystemFontOfSize:17]
                                     constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        return textHeight + 10;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        float textHeight = [_message.Theme sizeWithFont:[UIFont systemFontOfSize:20]
                                      constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                          lineBreakMode:NSLineBreakByWordWrapping].height;
        if ([_message.PhotoThumbnails count] != 0)
            return textHeight + 90 + 20; // 70为图像高度
        else
            return textHeight + 10;
    }
    else if(2 == section)
    {
        return 30;
    }
    else
        return 0;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section)
    {
        float textHeight = [_message.Theme sizeWithFont:[UIFont boldSystemFontOfSize:20]
                                      constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                          lineBreakMode:NSLineBreakByWordWrapping].height;
        
        UIView* header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, textHeight)];
        
        UILabel *saleThemeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310.0, textHeight)];
        saleThemeLabel.backgroundColor = [tableView backgroundColor];
        [saleThemeLabel setText:_message.Theme];
        [saleThemeLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [saleThemeLabel sizeToFitFixedWidth:saleThemeLabel.frame.size.width lines:10];
        [header addSubview:saleThemeLabel];
        
        for (int i = 0; i < [_message.PhotoThumbnails count]; i++)
        {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 5*(i+1) + 90*i, 15 + textHeight,
                                                                                   90, 90)];
            __weak UIImageView* weakImageView = imageView;
            NSString* imagePath = [_message.PhotoThumbnails objectAtIndex:i];
            [imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [weakImageView setImage:[image imageByScalingAndCroppingForSize:CGSizeMake(90, 90)]];
            }];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            
            imageView.clipsToBounds = YES;
            [imageView setupImageViewerWithDatasource:self initialIndex:i onOpen:nil onClose:nil];
            [header addSubview:imageView];
        }
        return header;
    }
    else if(2 == section)
    {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 30)];
        [headerView addSubview:headerLabel];
        headerLabel.text = @"描述";
        return headerView;
    }
    else
        return nil;
}

#pragma mark - MHFacebookImageViewerDatasource delegate methods
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [_message.PhotoThumbnails count];
}
- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [_message.PhotoThumbnails objectAtIndex:index];
}
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
}
- (IBAction)pressPhoneNumber:(id)sender
{
    NSString *phoneNumber = [NSString stringWithFormat:@"telprompt:://%@", _message.Tel];
    if (phoneNumber)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }

}

- (IBAction)sendPrivateMessage:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    PrivateMessageViewController* privateMessageVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PrivateMessageViewController"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    UserInfoModel* selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    int userID = self.message.User.UserID;
    if (userID == selfUserInfo.UserID)
        return;
    privateMessageVC.otherUserID = userID;
    [self.navigationController pushViewController:privateMessageVC animated:YES];
}
@end
