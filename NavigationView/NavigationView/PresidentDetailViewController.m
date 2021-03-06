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
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.tempValues = [[NSMutableDictionary alloc] init];
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
    if (textFieldBeingEdited != nil) {
        NSNumber* tagAsNum = [[NSNumber alloc] initWithInt:textFieldBeingEdited.tag];
        [tempValues setObject:textFieldBeingEdited.text forKey:tagAsNum];
    }
    
    for (NSNumber* key in [tempValues allKeys]) {
        switch ([key intValue]) {
            case kNameRowIndex:
                president.name = [tempValues objectForKey:key];
                break;
            case kFromYearRowIndex:
                president.fromYear = [tempValues objectForKey:key];
                break;
            case kToYearRowIndex:
                president.toYear = [tempValues objectForKey:key];
                break;
            case kPartyIndex:
                president.party = [tempValues objectForKey:key];
                break;
            default:
                break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
    NSArray* allControllers = self.navigationController.viewControllers;
    for (id c in allControllers) {
        NSLog(@"%@", c);
    }
    NSLog(@"haha");
    UITableViewController* parent = [allControllers lastObject];
    [parent.tableView reloadData];
    [self.parentViewController.view reloadInputViews];
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
        label.textAlignment = NSTextAlignmentLeft;
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


#pragma mark - Table view delegate
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark Text Field Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [tempValues setObject:textField forKey:[[NSNumber alloc] initWithInt:textField.tag]];
}
@end
