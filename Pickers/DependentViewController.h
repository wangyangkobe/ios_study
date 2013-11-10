//
//  DependentViewController.h
//  Pickers
//
//  Created by yang on 13-9-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependentViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>{
    NSArray* states;
    NSArray* zips;
    NSDictionary* stateZips;
}
@property (weak, nonatomic) IBOutlet UIPickerView *dependentPicker;
@property (retain, nonatomic) NSArray* states;
@property (retain, nonatomic) NSArray* zips;
@property (retain, nonatomic) NSDictionary* stateZips;
- (IBAction)dependentSelectPress:(id)sender;
@end
