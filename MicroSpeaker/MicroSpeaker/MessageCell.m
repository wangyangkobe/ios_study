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
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        [self.contentView addSubview:_headImageView];
        _subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 25)];
        [_subjectLabel setTextColor:[UIColor blueColor]];
        [_subjectLabel setFont:[UIFont systemFontOfSize:19]];
        [self.contentView addSubview:_subjectLabel];
        
        _genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 30, 15, 15)];
        [self.contentView addSubview:_genderImageView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 250, 15)];
        [_userNameLabel setFont:[UIFont systemFontOfSize:11]];
        [_userNameLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_userNameLabel];
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
    [[self.contentView viewWithTag:1] removeFromSuperview];
    [[self.contentView viewWithTag:2] removeFromSuperview];
    [[self.contentView viewWithTag:3] removeFromSuperview];
    [[self.contentView viewWithTag:4] removeFromSuperview];
    [[self.contentView viewWithTag:5] removeFromSuperview];
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
