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
#import "MessageModel.h"
#import "JSONModelLib.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString* requestURL = @"http://101.78.230.95:8082/microbroadcast/test";

@interface MainTabViewController ()
-(NSString*) dataFilePath; //归档文件的路径
-(void)applicationWillResignActive:(NSNotification*)notification;
-(void)requestDataFromServer;
@end

@implementation MainTabViewController

@synthesize messageArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
}

-(NSString*) dataFilePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths lastObject];
    return [documentsDirectory stringByAppendingPathComponent:kFileName];
}
-(void)loadView
{
    [super loadView];
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - 50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner setHidesWhenStopped:YES];
    [self.view addSubview:spinner];
}
- (void)viewDidLoad
{
    UIApplication* app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:app];
    
    [super viewDidLoad];
    
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    messageArray = [[NSMutableArray alloc] init];
    heightCache = [[NSMutableDictionary alloc] init];
    
    [spinner startAnimating];
    __block NSMutableArray* storedMessage;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        
        if (data != nil)
        {
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            storedMessage = [unarchiver decodeObjectForKey:kDataKey];
            [unarchiver finishDecoding];
            NSLog(@"%d", [storedMessage count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                messageArray = storedMessage;
                [spinner stopAnimating];
                [self.tableView reloadData];
            });
        }
        else
        {
            [self performSelectorOnMainThread:@selector(requestDataFromServer) withObject:nil waitUntilDone:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [self.tableView reloadData];
            });
        }
    });
}

-(void)applicationWillResignActive:(NSNotification*) notification
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:messageArray forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
    NSLog(@"path = %@", [self dataFilePath]);
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
    NSLog(@"count%d", [messageArray count]);
    return [messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* MainTableCellIdentifier = @"MainTableCellIdentifier";
    static BOOL isNibRegistered = NO;
    if (!isNibRegistered)
    {
        UINib* nib = [UINib nibWithNibName:@"MainCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:MainTableCellIdentifier];
        isNibRegistered = YES;
    }
    NSInteger row = [indexPath row];
    MainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:MainTableCellIdentifier];
    
    MessageModel* message = [messageArray objectAtIndex:row];
    
    cell.userNameLabel.text = message.User.UserName;
    cell.timeLabel.text = message.CreateAt;
    [cell.headImage setImageWithURL:[NSURL URLWithString:message.User.HeadPic]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.messageLabel.text = message.Text;
    if (message.Type == 2)
    {
        cell.subjectLabel.text = message.Activity.Theme;
    }
    else
    {
        NSString* str = message.Location.LocationDescription;
        cell.subjectLabel.text = [NSString stringWithFormat:@"在%@ 大声说", str];
    }
    
    [cell.photoView setContentMode:UIViewContentModeScaleAspectFit];
    [cell.photoView setImageWithURL:[NSURL URLWithString:message.PhotoThumbnail]];
    
    
    //设置选中cell的style
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel* message = [messageArray objectAtIndex:[indexPath row]];
    NSString* photoURL = message.PhotoThumbnail;
    if (photoURL == nil)
        return 110;
    else
    {
        NSLog(@"heightForRowAtIndexPath");
        // NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
        // UIImage* image = [UIImage imageWithData:imageData];
        return 110 + 90;
    }
}

-(void)requestDataFromServer
{
    STHTTPRequest* request = [STHTTPRequest requestWithURLString:requestURL];
    NSError *error = nil;
    NSString *jsonStr = [request startSynchronousWithError:&error];
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary* entry in jsonArray)
    {
        [messageArray addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
    }
}
- (void)refresh
{
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
}

- (void)addItem
{
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
    
    for (id entry in jsonArray)
    {
        [messageArray addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
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