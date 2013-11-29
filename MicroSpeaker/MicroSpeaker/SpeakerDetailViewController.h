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
@interface SpeakerDetailViewController : JMStaticContentTableViewController

@property(nonatomic, strong) MessageModel* message;

@end
