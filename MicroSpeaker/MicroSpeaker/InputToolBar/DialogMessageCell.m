//
//  DialogMessageCell.m
//  MicroSpeaker
//
//  Created by wy on 13-12-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DialogMessageCell.h"

@implementation DialogMessageCell

- (id) init
{
	self = [super init];
	if(!self) return nil;
    
	self.headImageView = [[UIImageView alloc] init];
    sel
    
	return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
    
	self.connectingActivityIndicatorView.frame = CGRectMake(5.0, 10.0, 15.0, 15.0);
	self.selectedCheckmarkImageView.frame = CGRectMake(200.0, 10.0, 14.0, 14.0);
    
	[self.contentView bringSubviewToFront:self.selectedCheckmarkImageView];
}

@end
