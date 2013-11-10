//
//  CustomViewController.h
//  Pickers
//
//  Created by wy on 13-11-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface CustomViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray* column1;
    NSArray* column2;
    NSArray* column3;
    NSArray* column4;
    NSArray* column5;
}

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UIButton *spinButton;

@property (retain, nonatomic) NSArray* column1;
@property (retain, nonatomic) NSArray* column2;
@property (retain, nonatomic) NSArray* column3;
@property (retain, nonatomic) NSArray* column4;
@property (retain, nonatomic) NSArray* column5;

@property(nonatomic) SystemSoundID crunchSoundID;
@property(nonatomic) SystemSoundID winSoundID;

- (IBAction)spin:(id)sender;
@end
