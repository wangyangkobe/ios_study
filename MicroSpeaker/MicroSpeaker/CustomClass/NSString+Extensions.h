//
//  NSString+Extensions.h
//  MicroSpeaker
//
//  Created by wy on 13-11-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

+(CGFloat) calculateTextHeight:(NSString*) str;
+ (NSString *) randomAlphanumericStringWithLength:(NSInteger)length;

-(BOOL) containsString: (NSString*) substring;
+(NSString*) generateQiNiuFileName;
@end
