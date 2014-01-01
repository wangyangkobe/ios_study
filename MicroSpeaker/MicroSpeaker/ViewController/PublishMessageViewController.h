//
//  PublishMessageViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-12-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "UIImage+Extensions.h"
#import "UserInfoModel.h"
#import "SelectAreaViewController.h"
#import "FGalleryViewController.h"
#import "QiniuSimpleUploader.h"
#import "QiniuPutPolicy.h"
#import "QiniuConfig.h"
#import "LocationHelper.h"
#import "NSString+Extensions.h"

@interface PublishMessageViewController : UITableViewController<HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SelectAreaViewControllerDelegate, FGalleryViewControllerDelegate, QiniuUploadDelegate, UIAlertViewDelegate>
{
    HPGrowingTextView* textView;
    
    UIButton* loadImageButton; //加载图像button
    
    CGFloat textViewDefaultHeight; //textView的默认高度
    
    int areaID;
    NSString* areaName;
    
    FGalleryViewController *imageGallery;
    
    QiniuSimpleUploader* qiNiuUpLoader;
    
    UserInfoModel* selfUserInfo;
}

@end
