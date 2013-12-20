//
//  NSString+Extensions.m
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

+(CGFloat)calculateTextHeight:(NSString *)str
{
    CGSize textSize = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17]
                      constrainedToSize:CGSizeMake(300, 63)
                          lineBreakMode:NSLineBreakByTruncatingTail];
    return textSize.height;
}
@end
