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
    UserInfoModel* selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    long userID = _selectedLetter.User.UserID;
    letters = [[[NetWorkConnection sharedInstance] getLetterBetweenTwo:userID sinceID:-1 maxID:-1 num:5 page:1] mutableCopy];
    
    bubbleTable.bubbleDataSource = self;
    bubbleTable.snapInterval = 120;
    bubbleTable.showAvatars = YES;
    bubbleTable.typingBubble = NSBubbleTypingTypeMe;
    
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
            messageData.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:element.FromUser.HeadPic]]];
        }
        else
        {
            messageData = [[NSBubbleData alloc] initWithText:element.Text date:createDate type:BubbleTypeMine];
            messageData.avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:element.FromUser.HeadPic]]];
        }
        
        [bubbleData addObject:messageData];
    }
    
    [bubbleTable reloadData];
    
    [self configureToolBar];
    
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bubbleTable layoutSubviews];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configureToolBar
{
    textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 5, 250, 30)];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
	textField.font = [UIFont systemFontOfSize:13.0f];
    textField.backgroundColor = [UIColor whiteColor];
    textField.returnKeyType = UIReturnKeySend;
    [self.toolBar addSubview:textField];
    
    faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setFrame:CGRectMake(0, 5, 30, 30)];
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [faceButton addTarget:self action:@selector(showFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:faceButton];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(280, 5, 40, 30)];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [sendButton addTarget:self action:@selector(sendTextAction) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)backGroundTap
{
    [textField resignFirstResponder];
    [self.toolBar setFrame:CGRectMake(0, SCREEN_HEIGHT - TOOLBAR_HEIGHT, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
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
-(void)inputKeyboardWillShow:(NSNotification *)notification
{
    NSLog(@"call: %s", __FUNCTION__);
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        [self.toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - 44 - 40 - 20, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    }];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    NSLog(@"call: %s", __FUNCTION__);
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.toolBar setFrame:CGRectMake(0, keyBoardFrame.origin.y - 44, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
    NSLog(@"frame = %@", NSStringFromCGRect(self.toolBar.frame));
    [self.view addSubview:self.toolBar];
}

@end
