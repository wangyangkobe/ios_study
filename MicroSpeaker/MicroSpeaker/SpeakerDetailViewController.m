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
    NSLog(@"sendTextAction：%@", [textField text]);
    
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [emojiKeyBoard setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self createCommentWithText:[textField text] messageID:_message.MessageID replyCommentID:replyCommentID];
        [self getCommentsByMessageID:_message.MessageID];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            textField.text = @"";
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
    [textField setText:[NSString stringWithFormat:@"回复%@:", comment.UserBasic.UserName]];
}

#pragma Mark EmojiKeyboardViewDelegate
- (void)emojiKeyBoardView:(EmojiKeyBoardView *)emojiKeyBoardView didUseEmoji:(NSString *)emojiStr
{
    NSLog(@"Controller: %@ pressed", emojiStr);
    NSLog(@"length = %d", [emojiStr length]);
    textField.text = [textField.text stringByAppendingString:emojiStr];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(EmojiKeyBoardView *)emojiKeyBoardView
{
    NSLog(@"Controller: Back pressed, %@", textField.text);
    int strLen = [textField.text length];
    if (strLen < 2)
        return;
    NSString* lastStr = [textField.text substringFromIndex:strLen - 2];
    NSLog(@"%d", [emojiKeyBoardView allEmojiFaces].count);
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
-(void)getCommentsByMessageID:(long)messageID// sinceID:(long)sinceId
{
    [commentsArray removeAllObjects];
    NSString* requestStr = [NSString stringWithFormat:@"%@/comment/show?messageID=%ld", HOME_PAGE, messageID];
    //    if (sinceId != -1)
    //        [requestStr stringByAppendingFormat:@"&sinceID=%ld", sinceId];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestStr]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request startSynchronous];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    for (id comment in jsonArray)
    {
        [commentsArray addObject:[[CommentModel alloc] initWithDictionary:comment error:nil]];
    }
    
    NSLog(@"Comments number is %d.", [commentsArray count]);
}
-(void)createCommentWithText:(NSString*)text messageID:(int)messageId replyCommentID:(int)replyCommentId
{
    NSString* requestURL = [NSString stringWithFormat:@"%@/comment/create", HOME_PAGE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:requestURL]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:text forKey:@"text"];
    [request setPostValue:[NSString stringWithFormat:@"%d", messageId] forKey:@"messageID"];
    if (replyCommentID > 0)
        [request setPostValue:[NSString stringWithFormat:@"%d", replyCommentId] forKey:@"replyCommentID"];
    [request startSynchronous];
    NSLog(@"response:%@", [request responseString]);
}
-(IBAction)backGroundTap
{
    [textField resignFirstResponder];
    [emojiKeyBoard setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, KEYBOARD_HEIGHT)];
    [toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
}
@end
