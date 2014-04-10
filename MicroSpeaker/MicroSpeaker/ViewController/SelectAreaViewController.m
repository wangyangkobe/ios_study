//
//  SelectAreaViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-12-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "NetWorkConnection.h"
@interface SelectAreaViewController ()

@end

@implementation SelectAreaViewController

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
    self.title = @"请选择推送社区";
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        areasArray = [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getArea]];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [areasArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    static NSString *CellIdentifier = @"AreaTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    AreaModel* area = [areasArray objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@,%@", area.AreaName, area.City];
    if (self.areaId == area.AreaID) {
        cell.imageView.image = [UIImage imageNamed:@"checked"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"unchecked"];
    }
    return cell;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int row = [indexPath row];
    AreaModel* area = [areasArray objectAtIndex:row];
    self.areaId = area.AreaID;
    [self.delegate selectAreaViewController:self didFinishSelectAreaId:self.areaId
                                   areaName:[NSString stringWithFormat:@"%@,%@", area.AreaName, area.City]];
    [self.tableView reloadData];
}
@end
