//
//  SpeakerDetailViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-11-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SpeakerDetailViewController.h"
#include "MacroDefination.h"
#import "UILabel+Extensions.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CommentModel.h"

@interface SpeakerDetailViewController ()
-(void) getCommentsByMessageID:(int) messageID;
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
    self.hidesBottomBarWhenPushed = YES; //隐藏TabBar
	return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [toolBar removeFromSuperview];
    [scrollView removeFromSuperview];
    [pageControl removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.title = @"正文";
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
    
    commentsArray = [[NSMutableArray alloc] init];
    [self getCommentsByMessageID:_message.MessageID];
    
    [self configureToolBar];
    
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:toolBar];
}
-(void)configureToolBar
{
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [toolBar setBarStyle:UIBarStyleBlack];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(35, 5, 240, 30)];
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    [textView.internalTextView setReturnKeyType:UIReturnKeySend];
    textView.delegate = self;
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
	textView.returnKeyType = UIReturnKeyGo; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    [toolBar addSubview:textView];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setFrame:CGRectMake(0, 5, 30, 30)];
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(showFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:faceButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(toolBar.bounds.size.width - 45.0f, 7, 40, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [sendButton addTarget:self action:@selector(sendTextAction) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sendButton];
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self createFaceKeyboard];
}

-(void)createFaceKeyboard
{
    //创建表情键盘
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            FaceView *fview=[[FaceView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFaceView:i size:CGSizeMake(33, 43)];
            fview.delegate = self;
            [scrollView addSubview:fview];
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*9, keyboardHeight);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(98, SCREEN_HEIGHT - 120, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor = RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    [pageControl setHidden:YES];
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [window addSubview:pageControl];
}
-(void)showFaceKeyboard
{
    CGRect toolBarFrame = toolBar.frame;
    //如果直接点击表情，通过toolbar的位置来判断
    if (toolBarFrame.origin.y== SCREEN_HEIGHT - TOOLBAR_HEIGHT && toolBarFrame.size.height == TOOLBAR_HEIGHT) {
        NSLog(@"1");
        [UIView animateWithDuration:0.25 animations:^{
            [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
        }];
        //[pageControl setHidden:NO];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (isKeyboardShow == NO) {
        NSLog(@"2");
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
        }];
        [textView becomeFirstResponder];
    }else{
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        NSLog(@"3");
        [UIView animateWithDuration:0.25 animations:^{
            toolBar.frame = CGRectMake(0, SCREEN_HEIGHT -  KEYBOARD_HEIGHT -toolBar.frame.size.height,
                                       SCREEN_WIDTH, toolBar.frame.size.height);
        }];
        [UIView animateWithDuration:0.25 animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT, SCREEN_WIDTH, keyboardHeight)];
        }];
        [textView resignFirstResponder];
    }
}

-(void)sendTextAction
{
    [textView resignFirstResponder];
    NSLog(@"sendTextAction：%@", [textView text]);
    
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
                                   [NSURL URLWithString:@"http://101.78.230.95:8082/microbroadcastDEV/comment/create"]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:[textView text] forKey:@"text"];
    [request setPostValue:[NSString stringWithFormat:@"%d", _message.MessageID] forKey:@"messageID"];
    if (replyCommentID > 0)
        [request setPostValue:[NSString stringWithFormat:@"%d", replyCommentID] forKey:@"replyCommentID"];
    [request startSynchronous];
    NSLog(@"headers:%@", [request responseHeaders]);
    NSLog(@"response:%@", [request responseString]);
    
    [self getCommentsByMessageID:_message.MessageID];
    
    [self.tableView reloadData];
    
    textView.text = @"";
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
}
#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification
{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        
        CGSize toolBarSize = toolBar.frame.size;
        if (toolBarSize.height > TOOLBAR_HEIGHT)
        {
            [toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - toolBarSize.height, SCREEN_WIDTH, toolBarSize.height)];
        }else{
            [toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        }
    }];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    isKeyboardShow = YES;
}
-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"键盘即将消失：%@", NSStringFromCGRect(keyBoardFrame));
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
    CGSize toolBarSize = toolBar.frame.size;
    if (toolBarSize.height > TOOLBAR_HEIGHT)
    {
        NSLog(@"4");
        [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - KEYBOARD_HEIGHT - toolBarSize.height, SCREEN_WIDTH, toolBarSize.height)];
    }else{
        NSLog(@"5");
        // [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT- TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
    }
	// commit animations
	[UIView commitAnimations];
    isKeyboardShow = NO;
}

#pragma mark HPGrowingTextView delegate  //改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
	CGRect r = toolBar.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	toolBar.frame = r;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320; //通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page; //pagecontroll响应值的变化
}
//pagecontroll的委托方法
- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage; //获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)]; //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSLog(@"进代理了");
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (textView.text.length > 0) {
            if ([[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr=[textView.text substringToIndex:textView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[textView.text substringFromIndex:textView.text.length-1]);
                newStr=[textView.text substringToIndex:textView.text.length-1];
            }
            textView.text=newStr;
        }
        NSLog(@"删除后更新%@",textView.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",textView.text,str];
        [textView setText:newStr];
        NSLog(@"点击其他后更新%d,%@",str.length,textView.text);
    }
    NSLog(@"出代理了");
}

-(void)replyComments:(id)sender
{
    UIButton* button = (UIButton*)sender;
    CommentModel* comment = [commentsArray objectAtIndex:button.tag];
    replyCommentID = comment.ReplyCommentID;
    [textView setText:[NSString stringWithFormat:@"回复%@:", comment.UserBasic.UserName]];
}
#pragma mark UITableView delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (0 == section)
        return [_message.Text sizeWithFont:[UIFont systemFontOfSize:17]
                         constrainedToSize:CGSizeMake(300, 1000)
                             lineBreakMode:NSLineBreakByWordWrapping].height + 20;
    else
        return UITableViewAutomaticDimension;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (0 == section) {
        float textHeight = [_message.Text sizeWithFont:[UIFont systemFontOfSize:17]
                                     constrainedToSize:CGSizeMake(300, 1000)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        
        UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, textHeight)];
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 310.0, textHeight)];
        footerLabel.backgroundColor = [tableView backgroundColor];
        [footerLabel setText:_message.Text];
        [footerLabel sizeToFitFixedWidth:footerLabel.frame.size.width lines:10];
        [footer addSubview:footerLabel];
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + textHeight + 5, SCREEN_WIDTH, 10)];
        timeLabel.text = _message.CreateAt;
        [timeLabel setTextColor:[UIColor grayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:13]];
        [footer addSubview:timeLabel];
        return footer;
    }
    else
        return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row     = [indexPath row];
    if (0 == section) {
        static NSString* CellIdentifier = @"UserCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView* headPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [headPicView setContentMode:UIViewContentModeScaleToFill];
        [headPicView setImageWithURL:[NSURL URLWithString:_message.User.HeadPic]];
        headPicView.layer.cornerRadius = 5.0f;
        headPicView.layer.masksToBounds = YES;
        [cell.contentView addSubview:headPicView];
        
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 40)];
        nameLabel.text = _message.User.UserName;
        [nameLabel setTextColor:[UIColor grayColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.contentView addSubview:nameLabel];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        
        return  cell;
    }
    else{
        CommentModel* comment = [commentsArray objectAtIndex:row];
        static NSString* CellIdentifier = @"CommentsCellIdentifier";
        UIImageView* headImageView = nil;
        UILabel* nameLabel = nil;
        UILabel* timeLabel = nil;
        UILabel* textLabel = nil;
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH - 35, 10)];
            timeLabel =  [[UILabel alloc] initWithFrame:CGRectMake(40, 15, SCREEN_WIDTH - 35, 10)];
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 280, 40)];
        }
        
        [headImageView setImageWithURL:[NSURL URLWithString:comment.UserBasic.HeadPic]];
        [nameLabel setText:comment.UserBasic.UserName];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor brownColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:10]];
        
        [timeLabel setText:comment.CreateAt];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:10]];
        [timeLabel setTextColor:[UIColor grayColor]];
        [cell addSubview:headImageView];
        [cell addSubview:nameLabel];
        [cell addSubview:timeLabel];
        
        
        [textLabel setText:comment.Text];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setFont:[UIFont systemFontOfSize:12]];
        [textLabel sizeToFitFixedWidth:280 lines:5];
        [cell.contentView addSubview:textLabel];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(280, 10, 15, 15)];
        [cell.contentView addSubview:button];
        button.tag = row;
        [button addTarget:self action:@selector(replyComments:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (0 == [commentsArray count])
        return 1;
    else
        return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section)
        return 1;
    else
        return [commentsArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = [indexPath section];
    int row     = [indexPath row];
    if (0 == section && 0 == row)
        return 60;
    else
        return 50;
}

// some methods for get or post data
-(void)getCommentsByMessageID:(int)messageID
{
    [commentsArray removeAllObjects];
    NSString* requestStr = [NSString stringWithFormat:@"%@/comment/show?messageID=%d", HOME_PAGE, messageID];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestStr]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    NSLog(@"result = %@", [request responseString]);
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id comment in jsonArray)
    {
        [commentsArray addObject:[[CommentModel alloc] initWithDictionary:comment error:nil]];
    }
}

-(void)backGroundTap
{
    [textView resignFirstResponder];
    [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
}
@end
