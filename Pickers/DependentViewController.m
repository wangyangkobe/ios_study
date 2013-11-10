//
//  DependentViewController.m
//  Pickers
//
//  Created by yang on 13-9-27.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DependentViewController.h"

@interface DependentViewController ()

@end

@implementation DependentViewController

@synthesize dependentPicker;
@synthesize states;
@synthesize zips;
@synthesize stateZips;

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
    
    //加载文件
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* plistPath = [bundle pathForResource:@"statedictionary" ofType:@"plist"];
    NSLog(@"path = %@", plistPath);
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"png"];
    NSLog(@"%@", imagePath);
    NSDictionary* dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    self.stateZips = dictionary;
    
    NSArray* components = [self.stateZips allKeys];
    NSArray* sorted = [components sortedArrayUsingSelector:@selector(compare:)];
    self.states = sorted;
    
    NSString* selectedStates = [self.states objectAtIndex:0];
    self.zips = [stateZips objectForKey:selectedStates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dependentSelectPress:(id)sender
{
    NSString* state = [self.states objectAtIndex:[dependentPicker selectedRowInComponent:0]];
    NSString* zip = [self.zips objectAtIndex:[dependentPicker selectedRowInComponent:1]];
    
    NSString* title = [NSString stringWithFormat:@"You selected zip code %@.", zip];
    NSString* message = [NSString stringWithFormat:@"%@ is in %@", zip, state];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Print", nil];
    [alert show];
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0)
    {
        return [self.states count];
    }
    else
        return [self.zips count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [self.states objectAtIndex:row];
    }
    return [self.zips objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) //此处实现两个pickerView的关联
    {
        NSString* selectedState = [self.states objectAtIndex:row];
        self.zips = [self.stateZips objectForKey:selectedState];
        [dependentPicker selectRow:0 inComponent:1 animated:YES];
        //刷新第2列
        [dependentPicker reloadComponent:1];
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Cancel Button was pressed!");
    }
    else{
        NSLog(@"Print Button was pressed!");
    }
}
@end
