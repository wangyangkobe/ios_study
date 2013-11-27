//
//  ActivityDetailViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageModel.h"
#import "JMStaticContentTableViewController.h"
#import "FGalleryViewController.h"
@interface ActivityDetailViewController : JMStaticContentTableViewController<FGalleryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, atomic) MessageModel* message;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

-(void) shareActivity;
@end
