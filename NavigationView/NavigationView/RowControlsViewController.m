//
//  RowControlsViewController.m
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "RowControlsViewController.h"

@interface RowControlsViewController ()

@end

@implementation RowControlsViewController

@synthesize dataList;

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
    self.dataList = [[NSArray alloc] initWithObjects:@"R2-D2", @"C3PO", @"Tik-Tok", @"Robby",
                     @"Rosie", @"Uniblab", @"Bender", @"Marvin", @"Tobor", @"HAL", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonTapped:(id)sender
{
    NSLog(@"Tapped Button pressed!");
    UIButton* senderButton = (UIButton*)sender;
    UITableViewCell* buttonCell = (UITableViewCell*)[senderButton superview];
    NSUInteger buttonRow = [[(UITableView*)self.view indexPathForCell:buttonCell] row];
    NSString* buttonTitle = [dataList objectAtIndex:buttonRow];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You tapped the button" message:[NSString stringWithFormat:@"You tapped the button for %@", buttonTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
#pragma mark Table Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *controlRowIdentifier = @"ControlRowIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:controlRowIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:controlRowIdentifier];
        UIImage* buttonUpImage = [UIImage imageNamed:@"button_up.png"];
        UIImage* buttonDownImage = [UIImage imageNamed:@"button_down.png"];
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 0.0, buttonUpImage.size.width, buttonUpImage.size.height);
        [button setBackgroundImage:buttonUpImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonDownImage forState:UIControlStateHighlighted];
        [button setTitle:@"Tap" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
    cell.textLabel.text = [dataList objectAtIndex:[indexPath row]];
    return cell;
}
#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* rowTitle = [dataList objectAtIndex:[indexPath row]];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You tapped the button" message:[NSString stringWithFormat:@"You tapped the button for %@", rowTitle] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
