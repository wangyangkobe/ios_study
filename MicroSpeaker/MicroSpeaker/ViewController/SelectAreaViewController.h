//
//  SelectAreaViewController.h
//  MicroSpeaker
//
//  Created by wy on 13-12-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectAreaViewController;

@protocol SelectAreaViewControllerDelegate <NSObject>

-(void)selectAreaViewController:(SelectAreaViewController*)viewController didFinishSelectAreaId:(int)Id areaName:(NSString*)Name;

@end

@interface SelectAreaViewController : UITableViewController
{
    NSArray* areasArray;
}
@property(nonatomic, assign) int areaId;
@property(nonatomic, weak) id<SelectAreaViewControllerDelegate> delegate;
@end
