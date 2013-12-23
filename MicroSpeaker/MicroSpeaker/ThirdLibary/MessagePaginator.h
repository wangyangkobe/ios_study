//
//  MessagePaginator.h
//  MicroSpeaker
//
//  Created by wy on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMPaginator.h"
#import "MessageModel.h"
#import "UserInfoModel.h"
@interface MessagePaginator : NMPaginator
{
    UserInfoModel* selfUserInfo;
}

@end
