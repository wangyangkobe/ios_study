//
//  MainTableCell.m
//  MicroSpeaker
//
//  Created by yang on 13-11-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MessageCell.h"
#import "MessageModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UILabel+Extensions.h"
#import "NSString+Extensions.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self.contentView addSubview:_headImageView];
        _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 220, 20)];
        [(UIView*)self addSubview:_subjectLabel];
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 105, 25)];
        [self.contentView addSubview:_userNameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 30, 105, 25)];
        [self.contentView addSubview:_timeLabel];

        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, 280, 0)];
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) prepareForReuse
{
    UIView *photoView = [self.contentView viewWithTag:100];
    [photoView removeFromSuperview];
}
// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Call MainTableCell:drawRect.");
 /*   CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));*/
}
@end
