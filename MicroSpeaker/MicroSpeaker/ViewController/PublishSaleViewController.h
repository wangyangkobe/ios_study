//
//  PublishSaleViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-1-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringInputTableViewCell.h"
#import "SimplePickerInputTableViewCell.h"
#import "QiniuSimpleUploader.h"
#import "QiniuPutPolicy.h"
#import "QiniuConfig.h"
@interface PublishSaleViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, QiniuUploadDelegate>

@end
