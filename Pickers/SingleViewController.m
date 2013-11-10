//
//  SingleViewController.m
//  Pickers
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SingleViewController.h"

@interface SingleViewController ()

@end

@implementation SingleViewController
@synthesize singlePicker;
@synthesize pickerData;

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
    NSArray* array = [[NSArray alloc] initWithObjects:@"Luke", @"Leia", @"Han", @"Chewbacca", @"Artoo", @"Lando", nil];
    self.pickerData = array;
    //singlePicker.dataSource = self;
    //singlePicker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singleSelectPress:(id)sender
{
    NSInteger row = [singlePicker selectedRowInComponent:0];
    NSString* selected = [pickerData objectAtIndex:row];
    NSString* title = [NSString stringWithFormat:@"You selected %@.", selected];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:@"Thank you for choosing." delegate:nil cancelButtonTitle:@"You are welcome." otherButtonTitles:nil];
    [alert show];
}

#pragma mart Picker Delegate Methods
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerData objectAtIndex:row];
}

#pragma mark -
#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerData count];
}
@end
