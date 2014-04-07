//
//  PrivateMessageViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-4-7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "PrivateMessageViewController.h"

@interface PrivateMessageViewController ()<UITextFieldDelegate>
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

#pragma mark - UIBubbleTableViewDataSource implementation
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}
- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
