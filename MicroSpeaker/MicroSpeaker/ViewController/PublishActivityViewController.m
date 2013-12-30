//
//  PublishActivityViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-12-28.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PublishActivityViewController.h"

@interface PublishActivityViewController ()

@end

@implementation PublishActivityViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    self.hidesBottomBarWhenPushed = YES;
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row || 1 == row) {
        static NSString *CellIdentifier = @"StringInputCell";
        StringInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (0 == row)
            cell.textField.placeholder = @"填写主题";
        else{
            cell.textLabel.text = @"地点:";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
        cell.delegate = self;
        return cell;
    }
    else if(2 == row || 3 == row){
        static NSString *CellIdentifier = @"DateInputCell";
        DateInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[DateInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        if(row == 1)
            cell.textLabel.text = @"开始时间:";
        else
            cell.textLabel.text = @"结束时间:";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.delegate = self;
        return cell;
    }
    else if(4 == row){
        static NSString *CellIdentifier = @"AreaInputCell";
        SimplePickerInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"推送到:";
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        [cell setValue:@"Value 1"];
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - StringInputTableViewCellDelegate
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    NSLog(@"value:%@", value);
}
#pragma mark - DateInputTableViewCellDelegate
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value{
    cell.dateValue = value;
   // cell.detailTextLabel.text = [value description];
    NSLog(@"data: %@", [value description]);
}
#pragma mark - SimplePickerInputTableViewCellDelegate
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value{
    NSLog(@"value = %@", value);
}
@end
