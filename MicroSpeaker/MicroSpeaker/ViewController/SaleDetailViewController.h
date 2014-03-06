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
@interface SaleDetailViewController : UIViewController<MHFacebookImageViewerDatasource, UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) MessageModel* message;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberBtn;

@property (weak, nonatomic) IBOutlet UIButton *privateMessageBtn;
- (IBAction)pressPhoneNumber:(id)sender;
- (IBAction)sendPrivateMessage:(id)sender;
@end
