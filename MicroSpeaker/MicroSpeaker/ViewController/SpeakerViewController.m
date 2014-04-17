//
//  SpeakerViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "SpeakerViewController.h"
#import "UIImage+Extensions.h"
#import "UserInfoModel.h"
#import "NSString+Emoji.h"
#import "UILabel+Extensions.h"
#import "MHFacebookImageViewer.h"
#import "PrivateMessageViewController.h"
@interface SpeakerViewController ()<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MHFacebookImageViewerDatasource>
{
    UserInfoModel* selfUserInfo;
    NSMutableArray* commentsArray;
    UITextField* textField;
    UIButton*    faceButton;  //表情按钮
    UIButton*    sendButton;  //表情按钮
    
    int replyCommentID;
}

@end

@implementation SpeakerViewController

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
    
    [self.headPic setImageWithURL:[NSURL URLWithString:_message.User.HeadPic]];
    headPic.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(sendPrivateMessage:)];
    [headPic addGestureRecognizer:singleTap];
    self.headPic.layer.cornerRadius = 5.0f;
    self.headPic.layer.masksToBounds = YES;
    
    [self.userNameLabel setText:_message.User.UserName];
    [self.titleLabel setText:[NSString stringWithFormat:@"%@ 大声说", _message.Area.AreaName]];
    
    NSString* genderPic = (_message.User.Gender == 0) ? @"gender_boy_big.png" : @"gender_girl_big.png";
    [self.genderPic setImage:[UIImage imageNamed:genderPic]];
    
    float textHeight = [_message.Text sizeWithFont:[UIFont systemFontOfSize:17]
                                 constrainedToSize:CGSizeMake(300, 1000)
                                     lineBreakMode:NSLineBreakByWordWrapping].height;
    CGRect frame = self.textLabel.frame;
    frame.size.height = textHeight;
    [self.textLabel setFrame:frame];
    [self.textLabel setText:_message.Text];
    
    for (int i = 0; i < [_message.PhotoThumbnails count]; i++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake( 10*(i+1) + 70*i, 55 + textHeight, 70, 70)];
        __weak UIImageView* weakImageView = imageView;
        NSString* imagePath = [_message.PhotoThumbnails objectAtIndex:i];
        [imageView setImageWithURL:[NSURL URLWithString:imagePath]
                  placeholderImage:[UIImage imageNamed:@"placeholder"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             [weakImageView setImage:[image imageByScalingAndCroppingForSize:CGSizeMake(70, 70)]];
                         }];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        
        imageView.clipsToBounds = YES;
        //        [imageView setupImageViewerWithDatasource:self initialIndex:i onOpen:nil onClose:nil];
        [self.headerView addSubview:imageView];
    }
    
    CGRect headViewFrame = self.headerView.frame;
    if ([_message.PhotoThumbnails count] > 0)
        headViewFrame.size.height = textHeight + 60 + 70;
    else
        headViewFrame.size.height = textHeight + 60;
    [self.headerView setFrame:headViewFrame];
    
   // [self.tableView setTableHeaderView:self.headerView];
    self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height + 66, 0, 0, 0);
   // [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
}
#pragma mark UITableView DataSource Method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [commentsArray count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel* comment = [commentsArray objectAtIndex:indexPath.row];
    static NSString* CellIdentifier = @"CommentCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    UIImageView* headImageView = (UIImageView*)[cell.contentView viewWithTag:2000];
    UILabel*  nameLabel   = (UILabel*)[cell.contentView viewWithTag:2001];
    UILabel*  textLabel   = (UILabel*)[cell.contentView viewWithTag:2002];
    UILabel*  timeLabel   = (UILabel*)[cell.contentView viewWithTag:2003];
    UIButton* replyButton = (UIButton*)[cell.contentView viewWithTag:2004];
    
    [headImageView setImageWithURL:[NSURL URLWithString:comment.UserBasic.HeadPic]];

    [nameLabel setText:comment.UserBasic.UserName];
    [timeLabel setText:comment.CreateAt];
    [textLabel setText:[comment.Text stringByReplacingEmojiCheatCodesWithUnicode]];
    [textLabel sizeToFitFixedWidth:280 lines:5];
    
    [replyButton setTag:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [headImageView setImageWithURL:[NSURL URLWithString:comment.UserBasic.HeadPic]];
    
    return cell;
    
}
// get comments by message id
-(void)getCommentsByMessageID:(long)messageID
{
    [commentsArray removeAllObjects];
    
    NSArray* result = [[NetWorkConnection sharedInstance] getCommentsByMessageID:messageID PageSize:5];
    
    [commentsArray addObjectsFromArray:result];
    
    NSLog(@"Comments number is %lu.", (unsigned long)[commentsArray count]);
}

- (void)configureToolBar
{
    textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 7, 250, 30)];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:13.0f];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeySend;
    [self.toolBar addSubview:textField];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setFrame:CGRectMake(0, 7, 30, 30)];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    // [faceButton addTarget:self action:@selector(showFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:faceButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(280, 7, 40, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendCommentMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:sendButton];
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
#pragma mark 监听键盘的显示与隐藏
- (void)inputKeyboardWillShow:(NSNotification *)notification
{
    NSLog(@"call: %s", __FUNCTION__);
    CGRect keyBoardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        [self.toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - 44 - 40 - 20, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    }];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"call: %s", __FUNCTION__);
    textField.text = @"";
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView beginAnimations:@"KeyboardWillHide" context:nil];
    [UIView setAnimationDuration:animationTime];
    [self.toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 40 - 20, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    [self sendCommentMessage];
    return TRUE;
}
- (void)backGroundTap
{
    [textField resignFirstResponder];
}
- (void)sendCommentMessage
{
    NSString* str = [[textField text] stringByReplacingEmojiUnicodeWithCheatCodes];
    NSLog(@"sendTextAction：%@", str);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NetWorkConnection sharedInstance] createCommentWithText:str
                                                        messageID:_message.MessageID
                                                   replyCommentID:replyCommentID];
        
        [self getCommentsByMessageID:_message.MessageID];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    [textField resignFirstResponder];
    textField.text = @"";
    [self.toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
}
- (IBAction)pressReplyButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    CommentModel* comment = [commentsArray objectAtIndex:button.tag];
    replyCommentID = comment.ReplyCommentID;
    if (selfUserInfo.UserID != comment.UserBasic.UserID)
        [textField setText:[NSString stringWithFormat:@"回复%@:", comment.UserBasic.UserName]];
    else
        [textField setText:@""];
}
- (void)sendPrivateMessage:(UITapGestureRecognizer*)gesture
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    PrivateMessageViewController* privateMessageVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PrivateMessageViewController"];
    int userID = self.message.User.UserID;
    if (userID == selfUserInfo.UserID)
        return;
    privateMessageVC.otherUserID = userID;
    [self.navigationController pushViewController:privateMessageVC animated:YES];
}
#pragma mark - MHFacebookImageViewerDatasource delegate methods
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [_message.PhotoThumbnails count];
}
- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [_message.PhotoThumbnails objectAtIndex:index];
}
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
}
@end
