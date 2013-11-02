//
//  MoveAndDeleteViewController.m
//  NavigationView
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MoveAndDeleteViewController.h"

@interface MoveAndDeleteViewController ()

@end

@implementation MoveAndDeleteViewController

@synthesize dataList;
@synthesize childTableView;

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
    if (dataList == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"computers" ofType:@"plist"];
        self.dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    if([self.titleData isEqualToString:@"Move Me"])
    {
        UIBarButtonItem* moveButton = [[UIBarButtonItem alloc] initWithTitle:@"Move" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMove)];
        self.navigationItem.rightBarButtonItem = moveButton;
    }
    else
    {
        UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleDelete)];
        self.navigationItem.rightBarButtonItem = deleteButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)toggleMove
{
    [self.childTableView setEditing:!self.childTableView.editing animated:YES];
    
    if (self.childTableView.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Move"];
    }
}

-(IBAction)toggleDelete
{
    [self.childTableView setEditing:!self.childTableView.editing animated:YES];
    
    if (self.childTableView.editing) {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }
    else{
        [self.navigationItem.rightBarButtonItem setTitle:@"Delete"];
    }
}
#pragma mark Table Data Source Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* MoveAndDeleteViewIdentifier = @"MoveAndDeleteViewIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:MoveAndDeleteViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoveAndDeleteViewIdentifier];
        if ([self.titleData isEqualToString:@"Move Me"]) {
            cell.showsReorderControl = YES;
        }
        else{
            cell.showsReorderControl = NO;
        }
    }
    cell.textLabel.text = [dataList objectAtIndex:[indexPath row]];
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;//如果返回NO，那么就禁止改行的移动
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.titleData isEqualToString:@"Move Me"]) {
        return UITableViewCellEditingStyleNone;//表示改行不支持插入或者删除
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger sourceRow = [sourceIndexPath row];
    NSUInteger destinationRow = [destinationIndexPath row];
    
    id object = [dataList objectAtIndex:sourceRow];
    [dataList removeObjectAtIndex:sourceRow];
    [dataList insertObject:object atIndex:destinationRow];
}

#pragma mark Table View Data Source Methods
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataList removeObjectAtIndex:[indexPath row]];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
}
@end
