//
//  SpeakerViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpeakerViewController : UIViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UIImageView *genderPic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property(nonatomic, strong) MessageModel* message;
- (IBAction)pressReplyButton:(id)sender;

@end
