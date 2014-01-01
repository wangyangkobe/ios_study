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
+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}
@end
