//
//  DisclosureButtonViewController.m
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DisclosureButtonViewController.h"

@interface DisclosureButtonViewController ()

@end

@implementation DisclosureButtonViewController

@synthesize list;

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
    self.list = [[NSArray alloc] initWithObjects:@"Toy Story", @"A Bug's Life", @"Toy Story 2",
                 @"Monsters, Inc", @"Finding Nemo", @"The Incredibles", @"Cars", @"Ratatouille", @"WALL-E", @"Up", @"Toy Story 3", @"Car 2", @"Brave", nil];
    self.title = self.titleData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* disclosureButtonViewController = @"DisclosureButtonViewController";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:disclosureButtonViewController];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:disclosureButtonViewController];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.text = [self.list objectAtIndex:[indexPath row]];
    return cell;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hey, do you see the disclosure button?" message:@"If you're trying to drill down, touch that instead" delegate:nil cancelButtonTitle:@"Won't happen again" otherButtonTitles: nil];
    [alert show];
}
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (disclosureDetail == nil)
    {
        disclosureDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureDetailViewController"];
    }
    disclosureDetail.title = @"Disclosure Button Pressed";
    NSString* selectedMovie = [list objectAtIndex:[indexPath row]];
    NSString* detailMessage = [[NSString alloc] initWithFormat:@"You pressed the disclosure button for %@", selectedMovie];
    disclosureDetail.message = detailMessage;
    disclosureDetail.title = selectedMovie;
    [self.navigationController pushViewController:disclosureDetail animated:YES];
}
@end
