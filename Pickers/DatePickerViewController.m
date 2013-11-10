//
//  DatePickerViewController.m
//  Pickers
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController
@synthesize datePicker;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [datePicker setDate:[[NSDate alloc] init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateSelectPress:(id)sender {
    NSDate* date = [datePicker date];
    NSString* message = [NSString stringWithFormat:@"The date and time you selected is: %@", date];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Date And Time Selected" message:message delegate:nil cancelButtonTitle:@"Yes, I Did!" otherButtonTitles: nil];
    [alert show];
}
@end
