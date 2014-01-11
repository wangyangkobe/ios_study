//
//  SaleDetailViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-1-4.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "MacroDefination.h"
#import "MHFacebookImageViewer.h"
@interface SaleDetailViewController : UITableViewController<MHFacebookImageViewerDatasource>
@property (retain, nonatomic) MessageModel* message;
@end
