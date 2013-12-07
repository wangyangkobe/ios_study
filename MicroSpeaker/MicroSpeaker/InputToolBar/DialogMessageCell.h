//
//  DialogMessageCell.h
//  MicroSpeaker
//
//  Created by wy on 13-12-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel* textLabel;
@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIButton* backButton;

@end
