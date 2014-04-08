//
//  PrivateMessageViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-4-7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterModel.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface PrivateMessageViewController : UIViewController<UIBubbleTableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic, assign) long  otherUserID;

@end
