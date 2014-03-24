//
//  RegisterViewController.h
//  MicroSpeaker
//
//  Created by wy on 14-3-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;
- (IBAction)selectAreaBtnPressed:(id)sender;

- (IBAction)doRegisterBtn:(id)sender;

@end
