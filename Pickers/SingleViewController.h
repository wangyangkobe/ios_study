//
//  SingleViewController.h
//  Pickers
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray* pickerData;
}

- (IBAction)singleSelectPress:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *singlePicker;
@property (retain, nonatomic) NSArray* pickerData;
@end
