//
//  SpeakerDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-11-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SpeakerDetailViewController.h"

@interface SpeakerDetailViewController ()

@end

@implementation SpeakerDetailViewController

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
    self.title = @"正文";
    __unsafe_unretained MessageModel* weakMessage = _message;
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.title = weakMessage.Activity.Theme;
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"User";
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.imageView removeFromSuperview];
            [cell.textLabel removeFromSuperview];
            
            UIImageView* headPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            [headPicView setContentMode:UIViewContentModeScaleToFill];
            [headPicView setImageWithURL:[NSURL URLWithString:weakMessage.User.HeadPic]];
            [cell.contentView addSubview:headPicView];
            
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 40)];
            nameLabel.text = weakMessage.User.UserName;
            [nameLabel setTextColor:[UIColor grayColor]];
            [nameLabel setFont:[UIFont systemFontOfSize:13]];
            [cell.contentView addSubview:nameLabel];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
		}];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    
    if (0 == section && 0 == row)
    {
        return 60;
    }
    return tableView.rowHeight;
}
@end
