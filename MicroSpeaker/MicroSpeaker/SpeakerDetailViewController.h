//
//  SpeakerDetailViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-11-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageModel.h"
#import "EmojiKeyBoardView.h"

@interface SpeakerDetailViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, EmojiKeyboardViewDelegate>
{
    UIToolbar*   toolBar;
    UITextField* textField;
    UIButton*    faceButton;  //表情按钮
    UIButton*    sendButton;  //表情按钮
    
    BOOL emojiKeyBoardShow;  //系统键盘显示
    
    EmojiKeyBoardView* emojiKeyBoard;
    
    NSMutableArray* commentsArray;
    
    int replyCommentID;
}

@property(nonatomic, strong) MessageModel* message;

-(IBAction)backGroundTap; //触摸view的background关闭键盘

@end
