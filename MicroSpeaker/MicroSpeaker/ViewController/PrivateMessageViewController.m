//
//  PrivateMessageViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-4-7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "PrivateMessageViewController.h"

@interface PrivateMessageViewController ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray* letters;
    NSMutableArray *bubbleData;
    
    UITextField* textField;
    UIButton*    faceButton;  //表情按钮
    UIButton*    sendButton;  //表情按钮
    UserInfoModel* selfUserInfo;
    UIRefreshControl* refreshControl;
}

@end

@implementation PrivateMessageViewController

@synthesize bubbleTable;

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
    [self configureToolBar];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadMoreData:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to load more."];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [self.bubbleTable addSubview:refreshControl];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 120;
    bubbleTable.showAvatars = YES;
    
    bubbleData = [[NSMutableArray alloc] init];
    
    __block NSBubbleData* messageData;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        letters = [[[NetWorkConnection sharedInstance] getLetterBetweenTwo:self.otherUserID
                                                                   sinceID:-1
                                                                     maxID:-1
                                                                       num:5
                                                                      page:1] mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Letter* element in letters)
            {
                NSDate* createDate = [dateFormat dateFromString:element.CreateAt];
                if (element.FromUser.UserID != selfUserInfo.UserID)
                {
                    messageData = [[NSBubbleData alloc] initWithText:element.Text date:createDate type:BubbleTypeSomeoneElse];
                }
                else
                {
                    messageData = [[NSBubbleData alloc] initWithText:element.Text date:createDate type:BubbleTypeMine];
                }
                messageData.imageURL = element.FromUser.HeadPic;
                [bubbleData addObject:messageData];
            }
            
            [self.bubbleTable reloadData];
        });
    });
    
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([bubbleData count] > 4)
    {
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
        self.bubbleTable.contentInset = contentInsets;
        self.bubbleTable.scrollIndicatorInsets = contentInsets;
        [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [faceButton addTarget:self action:@selector(showFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:faceButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(280, 7, 40, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendPrivateMessage) forControlEvents:UIControlEventTouchUpInside];
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
- (void)loadMoreData:(UIRefreshControl*)sender
{
    if (sender.refreshing)
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"loading data..."];
        [self performSelector:@selector(handleLoadData) withObject:nil afterDelay:2.0f];
    }
}
- (void)handleLoadData
{
    [refreshControl endRefreshing];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to load more."];
    if ([bubbleData count] <= 3)
        return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        int firstLetterID = ((Letter*)[letters objectAtIndex:0]).LetterID;
        NSArray* result = [[NetWorkConnection sharedInstance] getLetterBetweenTwo:self.otherUserID
                                                                          sinceID:-1
                                                                            maxID:firstLetterID
                                                                              num:5
                                                                             page:1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSBubbleData* messageData;
            for (Letter* element in [result reverseObjectEnumerator])
            {
                NSDate* createDate = [dateFormat dateFromString:element.CreateAt];
                if (element.FromUser.UserID != selfUserInfo.UserID)
                {
                    messageData = [[NSBubbleData alloc] initWithText:element.Text date:createDate type:BubbleTypeSomeoneElse];
                }
                else
                {
                    messageData = [[NSBubbleData alloc] initWithText:element.Text date:createDate type:BubbleTypeMine];
                }
                messageData.imageURL = element.FromUser.HeadPic;
                [bubbleData addObject:messageData];
            }
            
            [self.bubbleTable reloadData];
        });
    });
}
- (IBAction)backGroundTap
{
    [textField resignFirstResponder];
}
- (void)sendPrivateMessage
{
    if (textField.text != nil)
    {
        BOOL result = [[NetWorkConnection sharedInstance] sendLetter:self.otherUserID text:textField.text];
        if (result)
        {
            NSBubbleData* data = [[NSBubbleData alloc] initWithText:textField.text date:[NSDate date] type:BubbleTypeMine];
            data.imageURL = selfUserInfo.HeadPic;
            [bubbleData addObject:data];
            textField.text = @"";
            [self.bubbleTable reloadData];
        }
        [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    }
}

#pragma mark - UITextFieldDelegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendPrivateMessage];
    return YES;
}
#pragma mark - UIBubbleTableViewDataSource implementation
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}
- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark 监听键盘的显示与隐藏
- (void)inputKeyboardWillShow:(NSNotification *)notification
{
    NSLog(@"call: %s", __FUNCTION__);
    CGRect keyBoardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        // set the content insets
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardFrame.size.height + 130, 0.0);
        self.bubbleTable.contentInset = contentInsets;
        self.bubbleTable.scrollIndicatorInsets = contentInsets;
        [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
        
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
    // set the content insets
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 44, 0.0);
    self.bubbleTable.contentInset = contentInsets;
    self.bubbleTable.scrollIndicatorInsets = contentInsets;
    [self.bubbleTable scrollBubbleViewToBottomAnimated:YES];
    
    [self.toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 40 - 20, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [UIView commitAnimations];
}
@end
