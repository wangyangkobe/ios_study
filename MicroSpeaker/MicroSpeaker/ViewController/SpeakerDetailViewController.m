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
#import "NSString+Emoji.h"
#import "NetWorkConnection.h"
@interface SpeakerDetailViewController ()
-(void) getCommentsByMessageID:(long) messageID;
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
    [emojiKeyBoard removeFromSuperview];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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
    emojiKeyBoardShow = NO;
}
-(void)configureToolBar
{
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [toolBar setBarStyle:UIBarStyleBlack];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 5, 250, 30)];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
	textField.font = [UIFont systemFontOfSize:13.0f];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeySend;
    [toolBar addSubview:textField];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setFrame:CGRectMake(0, 5, 30, 30)];
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(showFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:faceButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(280, 5, 40, 30)];
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
    
    emojiKeyBoard = [[EmojiKeyBoardView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    emojiKeyBoard.delegate = self;
    
    [window addSubview:toolBar];
    [window addSubview:emojiKeyBoard];
}

-(void)showFaceKeyboard
{
    //表情键盘显示，点击, 显示系统键盘
    if (emojiKeyBoardShow != NO) {
        NSLog(@"----1");
        [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [textField resignFirstResponder];
        textField.inputView = nil;
        [textField becomeFirstResponder];
        emojiKeyBoardShow = NO;
    }else{
        //键盘显示的时候,切换到显示表情
        NSLog(@"2");
        [faceButton setBackgroundImage:[UIImage imageNamed:@"text"] forState:UIControlStateNormal];
        [textField resignFirstResponder];
        textField.inputView = emojiKeyBoard;
        [textField becomeFirstResponder];
        emojiKeyBoardShow = YES;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    [self sendTextAction];
    return TRUE;
}
-(void)sendTextAction
{
    [textField resignFirstResponder];
    NSString* str = [[textField text] stringByReplacingEmojiUnicodeWithCheatCodes];
    NSLog(@"sendTextAction：%@", str);
    
    textField.text = @"";
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [emojiKeyBoard setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NetWorkConnection sharedInstance] createCommentWithText:str messageID:_message.MessageID replyCommentID:replyCommentID];
        
        [self getCommentsByMessageID:_message.MessageID];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
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
    NSLog(@"3 -- keyboard show");
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    }];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"4 -- keyboard hide");
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// commit animations
	[UIView commitAnimations];
}

-(void)replyComments:(id)sender
{
    UIButton* button = (UIButton*)sender;
    CommentModel* comment = [commentsArray objectAtIndex:button.tag];
    replyCommentID = comment.ReplyCommentID;
    if (selfUserInfo.UserID != comment.UserBasic.UserID)
        [textField setText:[NSString stringWithFormat:@"回复%@:", comment.UserBasic.UserName]];
    else
        [textField setText:@""];
}

#pragma Mark EmojiKeyboardViewDelegate
- (void)emojiKeyBoardView:(EmojiKeyBoardView *)emojiKeyBoardView didUseEmoji:(NSString *)emojiStr
{
    textField.text = [textField.text stringByAppendingString:emojiStr];
}

//按回退键，删除emoji表情
- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyBoardView *)emojiKeyBoardView
{
    int strLen = [textField.text length];
    if (strLen < 2)
        return;
    NSString* lastStr = [textField.text substringFromIndex:strLen - 2];
    if ([[emojiKeyBoardView allEmojiFaces] containsObject:lastStr]) {
        textField.text = [textField.text substringToIndex:strLen - 2];
    }
}

#pragma mark UITableView delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (0 == section)
        return [_message.Text sizeWithFont:[UIFont systemFontOfSize:17]
                         constrainedToSize:CGSizeMake(300, 1000)
                             lineBreakMode:NSLineBreakByWordWrapping].height + 20;
    else if(1 == section)
        return 30;
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
    else if(1 == section && [commentsArray count] >= 5)
    {
        NSLog(@"----");
        UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 25)];
        UIButton* loadMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [loadMoreButton setFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 25)];
        [loadMoreButton setTitle:@"加载更多" forState:UIControlStateNormal];
        [loadMoreButton addTarget:self action:@selector(loadMoreComments) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:loadMoreButton];
        return footer;
    }
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    int section = [indexPath section];
    int row     = [indexPath row];
    if (0 == section) {
        static NSString* CellIdentifier = @"UserCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIImageView* headPicView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            [headPicView setContentMode:UIViewContentModeScaleToFill];
            headPicView.layer.cornerRadius = 5.0f;
            headPicView.layer.masksToBounds = YES;
            headPicView.tag = 1001;
            
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 40)];
            [nameLabel setTextColor:[UIColor grayColor]];
            [nameLabel setFont:[UIFont systemFontOfSize:13]];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
            nameLabel.tag = 1002;
            
            [cell.contentView addSubview:headPicView];
            [cell.contentView addSubview:nameLabel];
        }
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView* headPicView = (UIImageView*)[cell.contentView viewWithTag:1001];
        UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:1002];
        
        [headPicView setImageWithURL:[NSURL URLWithString:_message.User.HeadPic]];
        nameLabel.text = _message.User.UserName;
        
        return  cell;
    }
    else{
        CommentModel* comment = [commentsArray objectAtIndex:row];
        static NSString* CellIdentifier = @"CommentsCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIImageView* headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
            headImageView.tag = 1003;
            
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, SCREEN_WIDTH - 35, 10)];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
            [nameLabel setTextColor:[UIColor brownColor]];
            [nameLabel setFont:[UIFont systemFontOfSize:10]];
            nameLabel.tag = 1004;
            
            UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, SCREEN_WIDTH - 35, 10)];
            [timeLabel setBackgroundColor:[UIColor clearColor]];
            [timeLabel setFont:[UIFont systemFontOfSize:10]];
            [timeLabel setTextColor:[UIColor grayColor]];
            timeLabel.tag = 1005;
            
            UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 280, 40)];
            [textLabel setBackgroundColor:[UIColor clearColor]];
            [textLabel setFont:[UIFont systemFontOfSize:12]];
            textLabel.tag = 1006;
            
            UIButton* replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [replyButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
            [replyButton setFrame:CGRectMake(280, 10, 15, 15)];
            [replyButton addTarget:self action:@selector(replyComments:) forControlEvents:UIControlEventTouchUpInside];
            replyButton.tag = 1007;
            
            [cell.contentView addSubview:headImageView];
            [cell.contentView addSubview:nameLabel];
            [cell.contentView addSubview:timeLabel];
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:replyButton];
        }
        
        UIImageView* headImageView = (UIImageView*)[cell.contentView viewWithTag:1003];
        UILabel*  nameLabel   = (UILabel*)[cell.contentView viewWithTag:1004];
        UILabel*  timeLabel   = (UILabel*)[cell.contentView viewWithTag:1005];
        UILabel*  textLabel   = (UILabel*)[cell.contentView viewWithTag:1006];
        UIButton* replyButton = (UIButton*)[cell.contentView viewWithTag:1007];
        [headImageView setImageWithURL:[NSURL URLWithString:comment.UserBasic.HeadPic]];
        [nameLabel setText:comment.UserBasic.UserName];
        [timeLabel setText:comment.CreateAt];
        
        [textLabel setText:[comment.Text stringByReplacingEmojiCheatCodesWithUnicode]];
        [textLabel sizeToFitFixedWidth:280 lines:5];
        
        [replyButton setTag:row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
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
    {
        NSString* text = [((CommentModel*)[commentsArray objectAtIndex:row]).Text stringByReplacingEmojiCheatCodesWithUnicode];
        float textHeight = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]
                            constrainedToSize:CGSizeMake(270, 63)
                                lineBreakMode:NSLineBreakByWordWrapping].height;
        return 30 + textHeight;
    }
}

// get comments by message id
-(void)getCommentsByMessageID:(long)messageID
{
    [commentsArray removeAllObjects];
    
    NSArray* result = [[NetWorkConnection sharedInstance] getCommentsByMessageID:messageID PageSize:5];

    [commentsArray addObjectsFromArray:result];

    NSLog(@"Comments number is %d.", [commentsArray count]);
}

-(IBAction)backGroundTap
{
    [textField resignFirstResponder];
    [emojiKeyBoard setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
}

//加载更多的comments
-(void)loadMoreComments
{
    CommentModel* lastComment = [commentsArray lastObject];
    NSArray* result = [[NetWorkConnection sharedInstance] getCommentsByMessageID:_message.MessageID
                                                                        PageSize:5
                                                                           MaxID:lastComment.CommentID];
    [commentsArray addObjectsFromArray:result];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
@end
