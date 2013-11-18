//
//  MainTableCell.m
//  MicroSpeaker
//
//  Created by yang on 13-11-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MainTableCell.h"

@implementation MainTableCell

@synthesize headImage;
@synthesize subjectLabel;
@synthesize userNameLabel;
@synthesize timeLabel;
@synthesize messageLabel;
@synthesize photoView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 自绘分割线
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Call MainTableCell:drawRect.");
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0xE2/255.0f green:0xE2/255.0f blue:0xE2/255.0f alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height - 1, rect.size.width, 1));
}
@end
