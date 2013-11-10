//
//  DobuleViewController.h
//  Pickers
//
//  Created by yang on 13-9-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DobuleViewController : UIViewController<UIPickerViewAccessibilityDelegate, UIPickerViewDataSource>{
    NSArray* fillingTypes;
    NSArray* breadTypes;
}
@property (weak, nonatomic) IBOutlet UIPickerView *doublePicker;
@property (strong, nonatomic) NSArray* fillingTypes;
@property (strong, nonatomic) NSArray* breadTypes;
- (IBAction)doubleSelectPressed:(id)sender;

@end
