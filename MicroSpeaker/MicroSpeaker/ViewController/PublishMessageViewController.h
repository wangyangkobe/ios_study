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
@interface PublishMessageViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SelectAreaViewControllerDelegate, FGalleryViewControllerDelegate, QiniuUploadDelegate>
{
    HPGrowingTextView* textView;
    
    UIButton* loadImageButton; //加载图像button
    
    CGFloat textViewDefaultHeight; //textView的默认高度
    
    NSMutableArray* localImagesPath;
    
    int areaID;
    NSString* areaName;
    
    FGalleryViewController *imageGallery;
    
    QiniuSimpleUploader* qiNiuUpLoader;
    
    NSMutableArray* qiNiuImagesPath;
}

@end
