//
//  FirstLevelViewController.m
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "FirstLevelViewController.h"
#import "SecondLevelViewController.h"
@interface FirstLevelViewController ()

@end

@implementation FirstLevelViewController

@synthesize controllers;

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
    controllers = [[NSArray alloc]initWithObjects:@"Disclosure Buttons", @"Check One", @"Row Controls", @"Move Me", @"Delete Me", @"Detail Edit", nil];
    self.title= @"First Level";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.controllers count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* topLevelViewController = @"FirstLevelViewController";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:topLevelViewController];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topLevelViewController];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.controllers objectAtIndex:[indexPath row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    SecondLevelViewController* secondView = nil;
    switch (row) {
        case 0:
            secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureButtonViewController"];
                        break;
        case 1:
            secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckListViewController"];
            break;
        case 2:
            secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"RowControlViewController"];
            break;
        case 3:
        case 4:
            secondView = [self.storyboard instantiateViewControllerWithIdentifier:@"MoveAndDeleteViewController"];
            break;
        case 5:
            secondView =[self.storyboard instantiateViewControllerWithIdentifier:@"PresidentsViewController"];
            break;
        default:
            break;
    }
    secondView.titleData = [self.controllers objectAtIndex:[indexPath row]];
    secondView.title = secondView.titleData;
    //[self.navigationController presentViewController:secondView animated:YES completion:nil];
    
    [self.navigationController pushViewController:secondView animated:YES];
}

@end
