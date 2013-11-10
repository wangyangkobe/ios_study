//
//  DatePickerViewController.h
//  Pickers
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController
- (IBAction)dateSelectPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
