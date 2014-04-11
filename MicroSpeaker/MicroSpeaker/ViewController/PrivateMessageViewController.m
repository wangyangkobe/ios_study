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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    letters = [[[NetWorkConnection sharedInstance] getLetterBetweenTwo:self.otherUserID sinceID:-1 maxID:-1 num:5 page:1] mutableCopy];
    
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 120;
    bubbleTable.showAvatars = YES;
    
    bubbleData = [[NSMutableArray alloc] init];
    
    NSBubbleData* messageData;
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
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
    
    [self configureToolBar];
    
    [self.bubbleTable reloadData];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self
     action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
         // [textField resignFirstResponder];
            [self.bubbleTable reloadData];
        }
        [self scrollToBottomAnimated:YES];
    }
}
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.bubbleTable numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
          atScrollPosition:UITableViewScrollPositionBottom
          animated:animated];
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
    CGRect keyBoardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        // set the content insets
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyBoardFrame.size.height, 0.0);
        self.bubbleTable.contentInset = contentInsets;
        self.bubbleTable.scrollIndicatorInsets = contentInsets;
        [self scrollToBottomAnimated:YES];

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

    [self.toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 40 - 20, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    [UIView commitAnimations];
}

@end
