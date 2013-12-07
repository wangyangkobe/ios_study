//
//  FaceToolBar.h
//  TestKeyboard
//
//  Created by wangjianle on 13-2-26.
//  Copyright (c) 2013年 wangjianle. All rights reserved.
//
#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define keyboardHeight 216
#define toolBarHeight 45
#define choiceBarHeight 35
#define facialViewWidth 300
#define facialViewHeight 170
#define buttonWh 34
#import <UIKit/UIKit.h>
#import "FaceView.h"
#import "HPGrowingTextView.h"

@protocol InputToolBarDelegate <UIToolbarDelegate>
-(void)sendTextAction:(NSString *)inputText;
@end

@interface InputToolBar : UIToolbar<FaceViewDelegate,HPGrowingTextViewDelegate, UIScrollViewDelegate>
{
    UIToolbar*  toolBar;
    HPGrowingTextView* textView;
    UIButton* faceButton;  //表情按钮
    UIButton* sendButton;  //表情按钮
    
    BOOL isKeyboardShow; //键盘时候显示
}

@property(nonatomic, retain)UIView *theSuperView;
@property(nonatomic, weak) NSObject<InputToolBarDelegate>* delegate;

@end
