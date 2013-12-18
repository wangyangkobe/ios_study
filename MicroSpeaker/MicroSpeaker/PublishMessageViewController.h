//
//  PublishMessageViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-12-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@interface PublishMessageViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, HPGrowingTextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    HPGrowingTextView* textView;
    
    UIButton* loadImageButton; //加载图像button
    
    CGFloat defaultHeight; //textView的默认高度
    
    NSMutableArray* imagesArray;
    
}

@end
