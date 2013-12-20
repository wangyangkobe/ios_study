//
//  UILabel+Extensions.m
//
//
//  Created by wy on 13-11-24.
//
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)

- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth lines:(int)lineNumbers
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.numberOfLines = lineNumbers;
    [self sizeToFit];
}

@end
