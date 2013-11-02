//
//  CheckListViewController.m
//  NavigationView
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CheckListViewController.h"

@interface CheckListViewController ()

@end

@implementation CheckListViewController

@synthesize checkLists;
@synthesize lastIndexPath;
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
    checkLists = [[NSArray alloc] initWithObjects:@"Who Hash", @"Bubba Gump Shrimp Etouffee", @"Who Pudding", @"Scooby Snakes", @"Everlasting Gobstopper", @"Green Eggs and Ham", @"Soylent Green", @"Hard Tack", @"Lembas Bread", nil];
    self.title = self.titleData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.checkLists count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* checkListViewIdentifier = @"CheckListViewController";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:checkListViewIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:checkListViewIdentifier];
    }
    NSInteger newSelectRow = [indexPath row];
    NSInteger oldSelectRow = [self.lastIndexPath row];
    
    cell.textLabel.text = [self.checkLists objectAtIndex:newSelectRow];
    cell.accessoryType = (newSelectRow == oldSelectRow && lastIndexPath != nil) ?UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nowSelectRow = [indexPath row];
    int oldSelectRow = (lastIndexPath == nil) ? -1 : [self.lastIndexPath row];
    
    if (nowSelectRow != oldSelectRow)
    {
        UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
