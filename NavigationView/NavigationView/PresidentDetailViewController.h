//
//  PresidentDetailViewController.h
//  NavigationView
//
//  Created by yang on 13-11-3.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "President.h"
#define kNumberOfEditableRows 4
#define kNameRowIndex 0
#define kFromYearRowIndex 1
#define kToYearRowIndex 2
#define kPartyIndex 3

#define kLabelTag 4096
@interface PresidentDetailViewController : UITableViewController<UITextFieldDelegate>
{
    President* president;
    NSArray* fieldLabels;
    NSMutableDictionary* tempValues;
    UITextField* textFieldBeingEdited;
}

@property(nonatomic, retain) President* presient;
@property(nonatomic, retain) NSArray* fieldLabels;
@property(nonatomic, retain) NSMutableDictionary* tempValues;
@property(nonatomic, retain) UITextField* textFieldBeingEdited;

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)textFieldDone:(id)sender;

@end
