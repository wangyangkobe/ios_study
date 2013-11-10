//
//  DobuleViewController.m
//  Pickers
//
//  Created by yang on 13-9-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DobuleViewController.h"

@interface DobuleViewController ()

@end

@implementation DobuleViewController

@synthesize doublePicker;
@synthesize fillingTypes;
@synthesize breadTypes;

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
    self.fillingTypes = [[NSArray alloc] initWithObjects:@"Ham", @"Turkey", @"Peanut Butter", @"Tuna Salad", @"Nutella", @"Roast Beef", @"Vegemite", nil];
    
    self.breadTypes = [[NSArray alloc] initWithObjects:@"White", @"Whole Wheat", @"Rye", @"Sourdough", @"Seven Grain", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doubleSelectPressed:(id)sender {
    NSInteger fillingRow = [doublePicker selectedRowInComponent:0];
    NSInteger breadRow = [doublePicker selectedRowInComponent:1];
    
    NSString* filling = [fillingTypes objectAtIndex:fillingRow];
    NSString* bread = [breadTypes objectAtIndex:breadRow];
    
    NSString* message = [NSString stringWithFormat:@"You %@ on %@ bread will be right up.", filling, bread];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Thank you for your order!" message:message delegate:nil cancelButtonTitle:@"Great!" otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark Picker Data Source Methods
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2; //表示有2列
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) //表示第一列
    {
        return [self.fillingTypes count];
    }
    else
        return [self.breadTypes count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0)
    {
        return [self.fillingTypes objectAtIndex:row];
    }
    else
    {
        return [self.breadTypes objectAtIndex:row];
    }
}
@end
