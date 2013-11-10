//
//  CustomViewController.m
//  Pickers
//
//  Created by wy on 13-11-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController

@synthesize picker;
@synthesize winLabel;
@synthesize column1, column2, column3, column4, column5;
@synthesize spinButton;

@synthesize crunchSoundID, winSoundID;

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
    
    UIImage* seven = [UIImage imageNamed:@"seven.png"];
    UIImage* bar = [UIImage imageNamed:@"bar.png"];
    UIImage* crown = [UIImage imageNamed:@"crown.png"];
    UIImage* cherrty = [UIImage imageNamed:@"cherry"];
    UIImage* apple = [UIImage imageNamed:@"apple.png"];
    
    for (int i = 1; i <= 5; i++)
    {
        UIImageView* sevenView = [[UIImageView alloc] initWithImage:seven];
        UIImageView* barView = [[UIImageView alloc] initWithImage:bar];
        UIImageView* crownView = [[UIImageView alloc] initWithImage:crown];
        UIImageView* cherrtyView = [[UIImageView alloc] initWithImage:cherrty];
        UIImageView* appleView = [[UIImageView alloc] initWithImage:apple];
        
        NSArray* imageViewArray = [[NSArray alloc] initWithObjects:sevenView, barView, crownView, cherrtyView, appleView, nil];
        NSString* filedName = [NSString stringWithFormat:@"column%d", i];
        
        //Key-Value coding
        [self setValue:imageViewArray forKey:filedName];
    }
    srandom(time(NULL));
    
    self.picker.dataSource = self;
    self.picker.delegate = self;
    
    //加载声音文件
    NSString* path = [[NSBundle mainBundle] pathForResource:@"win" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &winSoundID);
    
    path = [[NSBundle mainBundle] pathForResource:@"crunch" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &crunchSoundID);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Picker DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.column1 count];
}

#pragma mark Picker Delegate Methods
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString* arrayName = [NSString stringWithFormat:@"column%d", component + 1];
    //Key-Value Coding
    NSArray* array = [self valueForKey:arrayName];
    return [array objectAtIndex:row];
}
- (IBAction)spin:(id)sender
{
    BOOL win = NO;
    int numInRow = 1;
    int lastValue = -1;
    for (int i = 0; i < 5; i++)
    {
        int newValue = rand() % [self.column1 count];
        if (lastValue == newValue) {
            numInRow++;
        }
        else
        {
            numInRow = 1;
        }
        lastValue = newValue;
        [picker selectRow:newValue inComponent:i animated:YES];
        [picker reloadComponent:i];
        if (numInRow >= 3)
        {
            win = YES;
        }
    }
    spinButton.hidden = YES;
    AudioServicesPlaySystemSound(crunchSoundID);
    if(win)
        [self performSelector:@selector(PlayWinSound) withObject:nil afterDelay:.5];
    else
        [self performSelector:@selector(showButton) withObject:nil afterDelay:.5];
    
    winLabel.text = @"";
}
-(void)showButton
{
    spinButton.hidden = NO;
}
-(void)PlayWinSound
{
    AudioServicesPlaySystemSound(winSoundID);
    winLabel.text = @"WIN!";
    [self performSelector:@selector(showButton) withObject:nil afterDelay:1.5];
}
@end
