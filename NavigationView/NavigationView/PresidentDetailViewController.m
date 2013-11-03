//
//  PresidentDetailViewController.m
//  NavigationView
//
//  Created by yang on 13-11-3.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PresidentDetailViewController.h"

@interface PresidentDetailViewController ()

@end

@implementation PresidentDetailViewController

@synthesize presient;
@synthesize fieldLabels;
@synthesize tempValues;
@synthesize textFieldBeingEdited;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.fieldLabels = [[NSArray alloc] initWithObjects:@"Name:", @"From:", @"To:", @"Party:", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)save:(id)sender
{
  
}
-(IBAction)textFieldDone:(id)sender
{
  [sender resignFirstResponder];
}
#pragma mark - Table view data source

// - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
// {
//     // Return the number of sections.
//     return 1;
// }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return kNumberOfEditableRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PresidentDetialCellIdentifier = @"PresidentDetialCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PresidentDetialCellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PresidentDetialCellIdentifier];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,75,25)];
        label.textAlignment = UITextAlignmentRight;
        label.tag = kLabelTag;
        label.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview: label];
    
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
        textField.clearsOnBeginEditing = NO;
        [textField setDelegate:self];
        textField.returnKeyType = UIReturnKeyDone;
        [textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [cell.contentView addSubview:textField];
    }
  
    NSInteger row = [indexPath row];
    UILabel* label = (UILabel*)[cell viewWithTag:kLabelTag];
    UITextField* textField = nil;
    for (UIView* oneView in cell.contentView.subviews) {
        if ([oneView isKindOfClass:[UITextField class]]) {
            textField = (UITextField*)oneView;
        }
    }
    label.text = [fieldLabels objectAtIndex:row];
    
    NSNumber* rowAsNum = [[NSNumber alloc] initWithInt:row];
    switch (row) {
        case kNameRowIndex:
	  if ([[tempValues allKeys] containsObject:rowAsNum]) {
            textField.text = [tempValues objectForKey:rowAsNum];
            }
        else{
          textField.text = president.name;
        }
            break;
        case kFromYearRowIndex:
	  if ([[tempValues allKeys] containsObject:rowAsNum]) {
                textField.text = [tempValues objectForKey:rowAsNum];
            }
	  else
	    textField.text = president.fromYear;
            break;
    case kToYearRowIndex:
      	  if ([[tempValues allKeys] containsObject:rowAsNum]) {
                textField.text = [tempValues objectForKey:rowAsNum];
            }
	  else
	    textField.text = president.toYear;
            break;
    case kPartyIndex:
            	  if ([[tempValues allKeys] containsObject:rowAsNum]) {
                textField.text = [tempValues objectForKey:rowAsNum];
            }
	  else
	    textField.text = president.party;
            break;
        default:
            break;
    }

    if(textFieldBeingEdited == textField)
      textFieldBeingEdited = nil;
    textField.tag = row;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
