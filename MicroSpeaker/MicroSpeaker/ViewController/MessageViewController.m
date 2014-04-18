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
#import "UILabel+Extensions.h"
#import "NSString+Extensions.h"
#import "SpeakerViewController.h"

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
    _segmentControl.segmentedControlStyle = 7;
    if (0 == _segmentControl.selectedSegmentIndex)
    {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
        [commentMessageTBV reloadData];
    }
    else
    {
        [_scrollView setContentOffset:CGPointMake(320, 0)];
        [privateMessgaeTBV reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息中心";
    [self configureScrollView];
    
    commentMessageTBV = [[UITableView alloc]init];
    commentMessageTBV.frame = CGRectMake(0, 0, 320, _scrollView.frame.size.height);
    commentMessageTBV.dataSource = self;
    commentMessageTBV.delegate = self;
    commentMessageTBV.tag = kCommentMessageVCTag;
    commentMessageTBV.contentInset = UIEdgeInsetsMake(0, 0, 90, 0); //tabbar height 49
    [_scrollView addSubview:commentMessageTBV];
    
    privateMessgaeTBV = [[UITableView alloc] init];
    privateMessgaeTBV.frame = CGRectMake(320, 0, 320, _scrollView.frame.size.height);
    privateMessgaeTBV.dataSource = self;
    privateMessgaeTBV.delegate = self;
    privateMessgaeTBV.contentInset = UIEdgeInsetsMake(0, 0, 90, 0); //tabbar height 49
    privateMessgaeTBV.tag = kPrivateMessageVCTag;
    [_scrollView addSubview:privateMessgaeTBV];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        letterContacts  = [[[NetWorkConnection sharedInstance] getLetterContacts] mutableCopy];
        commentContacts = [[[NetWorkConnection sharedInstance] getCommentToMe:-1 maxID:66666 num:10 page:1] mutableCopy];
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

- (void)configureScrollView
{
    // a page is the width of the scroll view
    _scrollView.pagingEnabled = YES;
    _scrollView.clipsToBounds = NO;
 //   _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
 //   _scrollView.delegate = self;
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    //公用
    currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor whiteColor];
}
- (CGFloat)calculateTextHeight:(NSString*)str
{
    return [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16]
           constrainedToSize:CGSizeMake(250, 100)
               lineBreakMode:NSLineBreakByWordWrapping].height;
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
    {
        CommentModel* comment = [commentContacts objectAtIndex:indexPath.row];
        NSString* str = [NSString stringWithFormat:@"回复我的:%@", comment.Message.Text];
        int height1 = [self calculateTextHeight:str];
        int height2 = [self calculateTextHeight:comment.Text];
        return height1 + height2 + 50;
    }
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        CommentModel* comment = [commentContacts objectAtIndex:indexPath.row];
        NSString* messageText = [NSString stringWithFormat:@"回复我的:%@", comment.Message.Text];
        float height1 = [self calculateTextHeight:messageText];
        float height2 = [self calculateTextHeight:comment.Text];
        
        static NSString* CellIdentifier = @"CommentMessageCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
//            for (UIView* view in [cell.contentView subviews])
//            {
//                if ([view isKindOfClass:[UILabel class]]) {
//                    [view removeFromSuperview];
//                }
//            }
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIImageView* headPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
            [headPic setTag:8005];
            [cell.contentView addSubview:headPic];
            
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 20)];
            [nameLabel setTag:8006];
            [nameLabel setFont:[UIFont systemFontOfSize:14]];
            [nameLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:nameLabel];
            
            UILabel* textLable1 = [[UILabel alloc] initWithFrame:CGRectZero];
            [textLable1 setTag:8007];
            [textLable1 setFont:[UIFont systemFontOfSize:15]];
            [cell.contentView addSubview:textLable1];
            
            UILabel* textLable2 = [[UILabel alloc] initWithFrame:CGRectZero];
            [textLable2 setTag:8008];
            [textLable2 setFont:[UIFont systemFontOfSize:15]];
            [cell.contentView addSubview:textLable2];
            
            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [timeLabel setTag:8009];
            [timeLabel setFont:[UIFont systemFontOfSize:14]];
            [timeLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:timeLabel];
        }
        
        UIImageView* headPic = (UIImageView*)[cell.contentView viewWithTag:8005];
        [headPic setImageWithURL:[NSURL URLWithString:comment.UserBasic.HeadPic]
                placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:8006];
        [nameLabel setText:comment.UserBasic.UserName];
        
        UILabel* textLabel1 = (UILabel*)[cell.contentView viewWithTag:8007];
        [textLabel1 setFrame:CGRectMake(60, 25, 250, height1)];
        textLabel1.text = messageText;
        [textLabel1 sizeToFitFixedWidth:250 lines:3];
        
        UILabel* textLabel2 = (UILabel*)[cell.contentView viewWithTag:8008];
        [textLabel2 setFrame:CGRectMake(60, 25+height1, 250, height2)];
        textLabel2.text = comment.Text;
        [textLabel2 sizeToFitFixedWidth:250 lines:3];
        
        UILabel* timeLabel = (UILabel*)[cell.contentView viewWithTag:8009];
        [timeLabel setFrame:CGRectMake(60, 25+height1+height2, 200, 20)];
        [timeLabel setText:comment.CreateAt];
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
        privateMessageVC.otherUserName = selectedLetter.User.UserName;
        
        [privateMessageVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:privateMessageVC animated:YES];
    }
    else
    {
        SpeakerViewController* speakerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SpeakerViewController"];
        CommentModel* selectedComment= (CommentModel*)[commentContacts objectAtIndex:indexPath.row];
        speakerVC.message = selectedComment.Message;
        [self.navigationController pushViewController:speakerVC animated:YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%s", __FUNCTION__);
//    CGFloat pageWidth = _scrollView.frame.size.width;
//    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    
//    pageControl.currentPage = page;
//    currentPage = page;
//    pageControlUsed = NO;
//   _segmentControl.selectedSegmentIndex = page;
//   [self changeTableView:nil];
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
