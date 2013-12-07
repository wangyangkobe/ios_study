//
//  ActivityDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+Extensions.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "MacroDefination.h"
@interface ActivityDetailViewController ()

@property (nonatomic, assign) bool isAttendActivity;
@property (nonatomic, copy) NSString* attendActivityTime;
@property (nonatomic, retain)  UIButton* activityButton;
@end

@implementation ActivityDetailViewController

@synthesize activityButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    self.hidesBottomBarWhenPushed = YES;
	return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self checkAttendActivity];
    
    self.title = _message.Area.AreaName;
    __unsafe_unretained MessageModel* weakMessage = _message;
    
    NSString* str = _message.Activity.Description;
    float fontHeight = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = weakMessage.Activity.Theme;
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"ActivityTime";
            staticContentCell.cellHeight = 40.0;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = [NSString stringWithFormat:@"活动时间:%@至%@", weakMessage.Activity.FromTime, weakMessage.Activity.FromTime];
			cell.imageView.image = [UIImage imageNamed:@"group_list_clock_src.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.textColor = [UIColor darkGrayColor];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"ActivityLocation";
            staticContentCell.cellHeight = 25;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = weakMessage.Location.LocationAddress;
			cell.imageView.image = [UIImage imageNamed:@"group_list_location_src.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"User";
            staticContentCell.cellHeight = 25;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = weakMessage.User.UserName;
            NSString* imageName = (weakMessage.User.Gender == 0) ? @"gender_boy_big.png" : @"gender_girl_big.png";
			cell.imageView.image = [UIImage imageNamed:imageName];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"CreateTime";
            staticContentCell.cellHeight = 25;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = [NSString stringWithFormat:@"发布时间:%@", weakMessage.CreateAt] ;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
			cell.imageView.image = [UIImage imageNamed:@"group_list_clock_src.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动照片";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"ActivityPic";
            staticContentCell.cellHeight = 110;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
            [image setImageWithURL:[NSURL URLWithString:weakMessage.PhotoThumbnail]];
            [cell.contentView addSubview:image];
            [image setContentMode:UIViewContentModeScaleToFill];
		}];
    }];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = @"活动简介";
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellHeight = fontHeight;
			staticContentCell.reuseIdentifier = @"ActivityDetail";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.text = weakMessage.Activity.Description;
            //配置label讲文字全部显示
            cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, 320, 0);
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            [cell.textLabel sizeToFit];
            
            //清除cell的边框和背景
            [cell setBackgroundView:[[UIView alloc] init]];
            [cell setBackgroundColor:[UIColor clearColor]];
		}];
    }];
    
    __weak typeof(self) weakSelf = self;
    activityButton = [[UIButton alloc] init];
    __weak UIButton* weakActivityButton = activityButton;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"ActivityButton";
            staticContentCell.cellHeight = 60;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            [weakActivityButton setFrame:CGRectMake(10, 10, 280, 40)];
            [weakActivityButton addTarget:weakSelf action:@selector(activityButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            weakActivityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [weakSelf changeButtonTitleAndColor:weakActivityButton];
            
            [cell.contentView addSubview:weakActivityButton];
            //清除cell的边框和背景
            [cell setBackgroundView:[[UIView alloc] init]];
            [cell setBackgroundColor:[UIColor clearColor]];
		}];
    }];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_detail_menu_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareActivity)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)checkAttendActivity
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/checkAttend?activityID=%ld", HOME_PAGE, _message.MessageID];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
        [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
        [request setProxyPort:8080];
#endif
        [request startSynchronous];
        
        NSLog(@"checkAttendActivity: %@", [request responseString]);
        if ([[request responseString] isEqualToString:@"false"]) {
            _isAttendActivity = NO;
            _attendActivityTime = nil;
        }else{
            _isAttendActivity = YES;
            _attendActivityTime = [NSString stringWithString:[request responseString]];
        }
        
        [self performSelectorOnMainThread:@selector(changeButtonTitleAndColor:) withObject:activityButton waitUntilDone:YES];
    });
}
-(void)changeButtonTitleAndColor:(UIButton*)button
{
    if (_isAttendActivity == NO)
    {
        [button setTitle:@"参加" forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor purpleColor]];
        
    }else{
        [button setBackgroundColor:[UIColor redColor]];
        [button setTitle:[NSString stringWithFormat:@"%@\n参加", _attendActivityTime] forState:UIControlStateNormal];
    }
}
-(void)activityButtonPressed:(id)sender
{
    UIButton* button = (UIButton*)sender;
    
    if (_isAttendActivity) //已经参加了
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"您已参加了该活动!" message:@"是否取消参加?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alertView show];
    }else{
        NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/attend", HOME_PAGE];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
        [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
        [request setProxyPort:8080];
#endif
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSString stringWithFormat:@"%ld", _message.MessageID] forKey:@"activityID"];
        [request startSynchronous];
        
        [button setBackgroundColor:[UIColor redColor]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
        [button setTitle:[NSString stringWithFormat:@"%@参加", [formatter stringFromDate:[NSDate date]]]
                forState:UIControlStateNormal];
        _isAttendActivity = true;
        NSLog(@"参加活动:%@", [request responseString]);
    }
}
-(void) shareActivity
{
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowIndex    = [indexPath row];
    int sectionIdex = [indexPath section];
    if (1 == sectionIdex && 0 == rowIndex && [_message.Photos count] > 0)
    {
        FGalleryViewController* networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
}

#pragma mart UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) //取消参加
    {
        [self.activityButton setBackgroundColor:[UIColor purpleColor]];
        [self.activityButton setTitle:@"参加" forState:UIControlStateNormal];
        _isAttendActivity = false;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString* requestUrl = [NSString stringWithFormat:@"%@/activity/cancel", HOME_PAGE];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestUrl]];
#if SET_PROXY
            [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
            [request setProxyPort:8080];
#endif
            [request setRequestMethod:@"POST"];
            [request setPostValue:[NSString stringWithFormat:@"%ld", _message.MessageID] forKey:@"activityID"];
            [request startSynchronous];
            NSLog(@"cancel result: %@", [request responseString]);
        });
        
    }else{
        // do nothing
    }
}

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    return [_message.Photos count];
}
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	return FGalleryPhotoSourceTypeNetwork;
}
- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [_message.Photos objectAtIndex:index];
}

@end