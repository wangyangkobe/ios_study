//
//  PresidentsViewController.m
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PresidentsViewController.h"
#import "President.h"
@interface PresidentsViewController ()

@end

@implementation PresidentsViewController

@synthesize presidentList;

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
    NSString* path = [[NSBundle mainBundle] pathForResource:@"presidents" ofType:@"plist"];
    NSData* data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    self.presidentList = [unarchiver decodeObjectForKey:@"Presidents"];
    [unarchiver finishDecoding];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table Data Soucre Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [presidentList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* PresidentsListViewIdentifier = @"PresidentsListViewIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:PresidentsListViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PresidentsListViewIdentifier];
    }
    President* president = [self.presidentList objectAtIndex:[indexPath row]];
    cell.textLabel.text = [president name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", president.fromYear, president.toYear];
    return cell;
}
@end
