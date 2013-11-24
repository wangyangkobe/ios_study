//
//  ActivityDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "ActivityDetailViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    [self.genderImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) shareActivity
{
    
}

// 触摸屏幕来滚动画面还是其他的方法使得画面滚动，皆触发该函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling...");
}

// 触摸屏幕并拖拽画面，再松开，最后停止时，触发该函数
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging  -  End of Scrolling.");
}

// 滚动停止时，触发该函数

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating  -   End of Scrolling.");
}

// 调用以下函数，来自动滚动到想要的位置，此过程中设置有动画效果，停止时，触发该函数

// UIScrollView的setContentOffset:animated:

// UIScrollView的scrollRectToVisible:animated:

// UITableView的scrollToRowAtIndexPath:atScrollPosition:animated:

// UITableView的selectRowAtIndexPath:animated:scrollPosition:
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndScrollingAnimation  -   End of Scrolling.");
}
@end
