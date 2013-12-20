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
@interface PublishMessageViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SelectAreaViewControllerDelegate>
{
    HPGrowingTextView* textView;
    
    UIButton* loadImageButton; //加载图像button
    
    CGFloat textViewDefaultHeight; //textView的默认高度
    
    NSMutableArray* imagesArray;
    
    int areaID;
    NSString* areaName;
    
}

@end
