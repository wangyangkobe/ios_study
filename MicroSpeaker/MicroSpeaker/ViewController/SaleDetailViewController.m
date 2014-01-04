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
#import <SDWebImage/UIImageView+WebCache.h>
@interface SaleDetailViewController ()

@end

@implementation SaleDetailViewController

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
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;
    self.hidesBottomBarWhenPushed = YES; //隐藏TabBar
    //  self.tableView.scrollEnabled = NO;
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"转让";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            }
            if (0 == row) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@元左右", _message.Price];
                cell.imageView.image = [UIImage imageNamed:@"RMB"];
            }else{
                cell.textLabel.text = _message.Area.AreaName;
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
        }
        cell.textLabel.text = _message.Text;
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        float textHeight = [_message.Text sizeWithFont:[UIFont systemFontOfSize:20]
                                     constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        if ([_message.PhotoThumbnails count] != 0)
            return textHeight + 90 + 20; // 70为图像高度
        else
            return textHeight + 10;
    }
    else if(2 == section)
        return 30;
    else
        return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        return 44;
    }
    else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
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
        
        for (int i = 0; i < [_message.PhotoThumbnails count]; i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 5*(i+1) + 90*i, 15 + textHeight,
                                                                                   90, 90)];
            __weak UIImageView* weakImageView = imageView;
            NSString* imagePath = [_message.PhotoThumbnails objectAtIndex:i];
            [imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [weakImageView setImage:[image imageByScalingAndCroppingForSize:CGSizeMake(90, 90)]];
            }];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            
            imageView.clipsToBounds = YES;
            //   [imageView setupImageViewerWithDatasource:self initialIndex:i onOpen:nil onClose:nil];
            [header addSubview:imageView];
        }
        return header;
    }
    else if(2 == section)
    {
//        static NSString *identifier = @"defaultHeader";
//        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//        if (!headerView) {
//            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
//        }
//        headerView.textLabel.text = @"描述";
//        headerView.textLabel.backgroundColor = [UIColor clearColor];
//        return headerView;
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 10, 30)];
        [headerView addSubview:headerLabel];
        headerLabel.text = @"描述";
        return headerView;
    }
    else
        return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (2 == section) {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        UIButton *telButton = [UIButton buttonWithType:UIButtonTypeCustom];
        telButton.frame = CGRectMake(5, 10, 255, 34);
        [footerView addSubview:telButton];
        [telButton setBackgroundColor:[UIColor colorWithRed:0.97 green:0.67 blue:0.25 alpha:1.0]];
        [telButton setTitle:[NSString stringWithFormat:@"复制联系方式: %@", _message.Tel] forState:UIControlStateNormal];
        return footerView;
    }
    return nil;
}
@end
