//
//  MessageViewController.m
//
//
//  Created by wy on 14-4-6.
//
//

#import "MessageViewController.h"
#import "DAPagesContainer.h"
#import "PrivateMessageViewController.h"
#import "SpeakerDetailViewController.h"

#define kPrivateMessageVCTag 9000
#define kCommentMessageVCTag 9001
@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSMutableArray* letterContacts;
    NSMutableArray* commentContacts;
    
    UITableView* privateMessgaeTBV;
    UITableView* commentMessageTBV;
    
    //左右滑动部分
	UIPageControl *pageControl;
    int currentPage;
    BOOL pageControlUsed;
}

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UserConfig shareInstance] isLogIn] == NO)
    {
        LogInViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
        return;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息中心";
    
    commentMessageTBV = [[UITableView alloc]init];
    commentMessageTBV.frame = CGRectMake(0, 0, 320, _scrollView.frame.size.height);
    commentMessageTBV.dataSource = self;
    commentMessageTBV.delegate = self;
    commentMessageTBV.tag = kCommentMessageVCTag;
    [_scrollView addSubview:commentMessageTBV];
    
    privateMessgaeTBV = [[UITableView alloc] init];
    privateMessgaeTBV.frame = CGRectMake(320, 0, 320, _scrollView.frame.size.height);
    privateMessgaeTBV.dataSource = self;
    privateMessgaeTBV.delegate = self;
    privateMessgaeTBV.tag = kPrivateMessageVCTag;
    [_scrollView addSubview:privateMessgaeTBV];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        letterContacts  = [[[NetWorkConnection sharedInstance] getLetterContacts] mutableCopy];
        commentContacts = [[[NetWorkConnection sharedInstance] getCommentToMe:-1 maxID:66666 num:3 page:1] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (0 == _segmentControl.selectedSegmentIndex)
                [commentMessageTBV reloadData];
            else
                [privateMessgaeTBV reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScrollView {
    
    //设置 tableScrollView
    // a page is the width of the scroll view
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.delegate = self;
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    //公用
    currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(1 == _segmentControl.selectedSegmentIndex)
        return [letterContacts count];
    else
        return [commentContacts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentControl.selectedSegmentIndex == 1)
        return 60;
    else
        return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __FUNCTION__);
    if (_segmentControl.selectedSegmentIndex == 1)
    {
        static NSString* CellIdentifier = @"PrivateMessageCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIImageView* headPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
            headPic.layer.masksToBounds = YES; //没这句话它圆不起来
            headPic.layer.cornerRadius = 5.0;
            [headPic setTag:8000];
            [cell.contentView addSubview:headPic];

            UILabel* userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 200, 30)];
            [userName setTag:8001];
            [userName setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:userName];

            UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 200, 15)];
            [textLabel setTag:8002];
            [textLabel setFont:[UIFont systemFontOfSize:14]];
            [textLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:textLabel];


            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 45, 200, 15)];
            [timeLabel setTag:8003];
            [timeLabel setFont:[UIFont systemFontOfSize:14]];
            [timeLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:timeLabel];

            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        LetterModel* element = [letterContacts objectAtIndex:indexPath.row];
        UIImageView* headPic = (UIImageView*)[cell.contentView viewWithTag:8000];
        [headPic setImageWithURL:[NSURL URLWithString:element.User.HeadPic]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];


        UILabel* userName = (UILabel*)[cell.contentView viewWithTag:8001];
        [userName setText:element.User.UserName];

        UILabel* text = (UILabel*)[cell.contentView viewWithTag:8002];
        [text setText:element.Letter.Text];

        UILabel* time = (UILabel*)[cell.contentView viewWithTag:8003];
        [time setText:element.Letter.CreateAt];
        return cell;
    }
    else
    {
        static NSString* CellIdentifier = @"CommentMessageCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        CommentModel* comment = [commentContacts objectAtIndex:indexPath.row];
        cell.textLabel.text = comment.Text;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];

    if (_segmentControl.selectedSegmentIndex == 1)
    {
        PrivateMessageViewController* privateMessageVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PrivateMessageViewController"];
        LetterModel* selectedLetter = (LetterModel*)[letterContacts objectAtIndex:indexPath.row];
        privateMessageVC.otherUserID = selectedLetter.User.UserID;
        
        [privateMessageVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:privateMessageVC animated:YES];
    }
    else
    {
        SpeakerDetailViewController* speakerDetailViewController = [[SpeakerDetailViewController alloc] init];
        CommentModel* selectedComment= (CommentModel*)[commentContacts objectAtIndex:indexPath.row];
        speakerDetailViewController.message = selectedComment.Message;
        [[UIApplication sharedApplication].keyWindow setRootViewController:speakerDetailViewController];
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    pageControl.currentPage = page;
    currentPage = page;
    pageControlUsed = NO;
}
- (IBAction)changeTableView:(id)sender
{
    NSLog(@"%s, selected = %d", __FUNCTION__, _segmentControl.selectedSegmentIndex);
    if (1 == _segmentControl.selectedSegmentIndex)
    {
        [UIView beginAnimations:nil context:nil];//动画开始
        [UIView setAnimationDuration:0.3];
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        [UIView commitAnimations];
        
        [privateMessgaeTBV reloadData];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];//动画开始
        [UIView setAnimationDuration:0.3];
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];
        
        [commentMessageTBV reloadData];
    }
}
@end
