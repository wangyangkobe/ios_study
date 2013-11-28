//
//  ActivityDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UILabel+Extensions.h"
@interface ActivityDetailViewController ()
@end

@implementation ActivityDetailViewController

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
    
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
     self.title = _message.Area.AreaName;
     
     [_scrollView setFrame:CGRectMake(0, 0, 320, 500)];
     _scrollView.delegate = self;
     _scrollView.contentSize = CGSizeMake(320, 900);
     _scrollView.scrollEnabled = YES;
     
     UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_detail_menu_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareActivity)];
     self.navigationItem.rightBarButtonItem = rightButton;
     
     self.themeLabel.text = _message.Activity.Theme;
     self.timeLabel.text = [NSString stringWithFormat:@"活动时间%@至%@", _message.Activity.FromTime, _message.Activity.FromTime];
     self.locationLabel.text = _message.Location.LocationAddress;
     self.createTimeLabel.text = _message.CreateAt;
     self.userNameLabel.text = _message.User.UserName;
     
     NSString* imageName = (_message.User.Gender == 0) ? @"gender_boy_big.png" : @"gender_girl_big.png";
     [self.genderImageView setImage:[UIImage imageNamed:imageName]];*/
    
    self.title = _message.Area.AreaName;
    __unsafe_unretained MessageModel* weakMessage = _message;
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = weakMessage.Activity.Theme;
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"ActivityTime";
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
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.textLabel.text = weakMessage.Location.LocationAddress;
			cell.imageView.image = [UIImage imageNamed:@"group_list_location_src.png"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor darkGrayColor];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"User";
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
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"group_detail_menu_share.png"] style:UIBarButtonItemStylePlain target:self action:@selector(shareActivity)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
-(void) shareActivity
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowIndex    = [indexPath row];
    int sectionIdex = [indexPath section];
    if (0 == rowIndex && 0 == sectionIdex)
        return 40;
    else if(1 == sectionIdex && 0 == rowIndex)
        return 110;
    else if(2 == sectionIdex && 0 == rowIndex)
    {
        NSString* str = _message.Activity.Description;
        CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height;
    }
    else
        return 25;
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