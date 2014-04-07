//
//  LetterModel.h
//  MicroSpeaker
//
//  Created by wy on 14-4-7.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "UserModel.h"

@interface Letter : JSONModel<NSCopying, NSCopying>

@property(strong, nonatomic) NSString*  CreateAt;
@property(strong, nonatomic) UserModel* FromUser;
@property(strong, nonatomic) UserModel* ToUser;
@property(assign, nonatomic) int        LetterID;
@property(strong, nonatomic) NSString*  Text;

@end



@interface LetterModel : JSONModel<NSCopying, NSCopying>

@property(nonatomic, copy) Letter*    Letter;
@property(nonatomic, copy) UserModel* User;

@end
