//
//  PublishActivityViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-12-28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "DateInputTableViewCell.h"
#import "SimplePickerInputTableViewCell.h"
@interface PublishActivityViewController : UITableViewController<StringInputTableViewCellDelegate, DateInputTableViewCellDelegate, SimplePickerInputTableViewCellDelegate>

@end
