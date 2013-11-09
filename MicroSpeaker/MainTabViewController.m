//
//  MainTabViewController.m
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MainTabViewController.h"
#import "MainTableCell.h"
#import "STHTTPRequest.h"
#import "UserInfo.h"
#import "Message.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* requestURL = @"http://101.78.230.95:8082/microbroadcast/test";
@interface MainTabViewController ()

@end

@implementation MainTabViewController

@synthesize userInfoArr;

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
    userInfoArr = [[NSMutableArray alloc] init];
    
    //设置cell之间的fenge类型
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
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
    NSLog(@"count%d", [userInfoArr count]);
    return [userInfoArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"111111%@", userInfoArr);
    static NSString* MainTableCellIdentifier = @"MainTableCellIdentifier";
    static BOOL isNibRegistered = NO;
    if (!isNibRegistered) {
        UINib* nib = [UINib nibWithNibName:@"MainCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:MainTableCellIdentifier];
        isNibRegistered = YES;
    }
    NSInteger row = [indexPath row];
    MainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:MainTableCellIdentifier];
    //cell.headImage.image = [UIImage imageNamed:@"apple.png"];
    
    [cell.headImage setImageWithURL:[NSURL URLWithString:[[userInfoArr objectAtIndex:row] userHeadPic]]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.subjectLabel.text = @"wang yang";
    cell.userNameLabel.text = [[userInfoArr objectAtIndex:row] userName];
    NSLog(@"%@", cell.userNameLabel.text);
    cell.timeLabel.text = [[NSDate date] description];
    cell.messageLabel.text = @"缘分像一本书。翻的不经意会错过童话，读得太认真又会流干眼泪。";
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath");
    return 150;
}
- (void)refresh {
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
}

- (void)addItem {
    // Add a new time
    //request the data
    /*__block STHTTPRequest* request = [STHTTPRequest requestWithURLString:requestURL];
    __block NSMutableArray* userArr = [[NSMutableArray alloc] init];
    request.completionBlock = ^(NSDictionary* headers, NSString* jsonStr)
    {
        NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary* userInfoDict = nil;
        for (id entry in jsonArray)
        {
            userInfoDict = [entry objectForKey:@"User"];
            userInfo.userName = [userInfoDict objectForKey:@"UserName"];
            userInfo.userId   = [[userInfoDict objectForKey:@"UserID"] integerValue];
            userInfo.userGender = [[userInfoDict objectForKey:@"Gender"] boolValue];
            userInfo.userHeadPic = [userInfoDict objectForKey:@"HeadPic"];
	    
            [userArr addObject:userInfo];
            NSLog(@"%@", [userArr description]);
        }
        NSLog(@"end");
    };

    request.errorBlock = ^(NSError* error)
    {
        NSLog(@"Error: %@", [error description]);
    };
    
    [request startAsynchronous];*/
    
    STHTTPRequest* request = [STHTTPRequest requestWithURLString:requestURL];
    NSError *error = nil;
    NSString *jsonStr = [request startSynchronousWithError:&error];
    
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    UserInfo* userInfo = [[UserInfo alloc] init];
    NSDictionary* userInfoDict = nil;
    for (id entry in jsonArray)
    {
      /*  userInfoDict = [entry objectForKey:@"User"];
        
        userInfo.userName = [userInfoDict objectForKey:@"UserName"];
        userInfo.userId   = [[userInfoDict objectForKey:@"UserID"] integerValue];
        userInfo.userGender = [[userInfoDict objectForKey:@"Gender"] boolValue];
        userInfo.userHeadPic = [userInfoDict objectForKey:@"HeadPic"];
        
        UserInfo* userInfo = [[UserInfo alloc] initWithName:[userInfoDict objectForKey:@"UserName"]
                                                    headpic:[userInfoDict objectForKey:@"HeadPic"]                                                         
                                                    user_id:[[userInfoDict   objectForKey:@"UserID"] integerValue]
                                                     gender:[[userInfoDict objectForKey:@"Gender"] boolValue]];
       // NSLog(@"%@", [userInfo description]);
        [userInfoArr addObject:userInfo];
            NSLog(@"ttttttttt%@", [userInfoArr description]);*/
        [userInfoArr addObject:addObject:[[Message alloc] initWithMessageDict:message]];
    }

    [self.tableView reloadData];

    [self stopLoading];
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
