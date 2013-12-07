//
//  MainTabViewController.m
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MainTabViewController.h"
//#import "STHTTPRequest.h"
#import "MessageModel.h"
#import "JSONModelLib.h"
#import "UILabel+Extensions.h"
#import "NSString+Extensions.h"
#import "MessageCell.h"
#import "ActivityDetailViewController.h"
#import "SpeakerDetailViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MacroDefination.h"

//NSString* requestURL = @"http://101.78.230.95:8082/microbroadcast/test";
//NSString* requestURL = @"http:101.78.230.95:8082/microbroadcastDEV/message/getByID";
NSString* homePageUrl = @"http://101.78.230.95:8082/microbroadcastDEV";

@interface MainTabViewController ()
-(NSString*) dataFilePath; //归档文件的路径
-(void)applicationWillResignActive:(NSNotification*)notification;
//-(void)requestDataFromServer;
@end

@implementation MainTabViewController

@synthesize messageArray;
@synthesize messagePaginator;

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
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:
                                   [NSURL URLWithString:@"http://101.78.230.95:8082/microbroadcastDEV/user/checkUser"]];
#if SET_PROXY
    [request setProxyHost:@"jpyoip01.mgmt.ericsson.se"];
    [request setProxyPort:8080];
#endif
    [request setRequestMethod:@"POST"];
    [request setPostValue:@"1989424925" forKey:@"weiboID"];
    [request startSynchronous];
    NSLog(@"headers:%@", [request responseHeaders]);
    NSLog(@"response:%@", [request responseString]);
}
- (void)viewDidLoad
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    UIApplication* app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:app];
    
    [super viewDidLoad];
    messageArray = [[NSMutableArray alloc] init];
    
    // set up the paginator
    [self setupTableViewFooter];
    self.messagePaginator = [[MessagePaginator alloc] initWithPageSize:15 delegate:self];
    
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
                messageArray = [storedMessage mutableCopy];
                [self.tableView reloadData];
            });
        }
        else
        {
            //[self performSelectorOnMainThread:@selector(requestDataFromServer) withObject:nil waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messagePaginator fetchFirstPage];
                //[self.tableView reloadData];
            });
        }
    });
}

-(void)applicationWillResignActive:(NSNotification*) notification
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:[messageArray subarrayWithRange:NSMakeRange(0, 15)] forKey:kDataKey];
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
    return [messageArray count];
    //return [self.messagePaginator.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel* message = [messageArray objectAtIndex:[indexPath row]];
    static NSString* cellIdentifier = @"CellIdentifier";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:message.User.HeadPic]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    float heightPos = 55;
    if (message.Type == 2)
    {
        cell.subjectLabel.text = message.Activity.Theme;
        
        UIImageView* timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 55, 20, 20)];
        [cell.contentView addSubview:timeImageView];
        [timeImageView setImage:[UIImage imageNamed:@"group_list_clock_src.png"]];
        timeImageView.tag = 1;
        
        UILabel *activityTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 55, 310, 20)];
        [cell.contentView addSubview:activityTimeLabel];
        activityTimeLabel.text = [NSString stringWithFormat:@"活动时间:%@", message.CreateAt];
        [activityTimeLabel setTextColor:[UIColor redColor]];
        [activityTimeLabel setTag:2];
        
        UIImageView* locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 75, 20, 20)];
        [cell.contentView addSubview:locationImageView];
        [locationImageView setImage:[UIImage imageNamed:@"group_list_location_src.png"]];
        [locationImageView setTag:3];
        
        UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 75, 310, 20)];
        [cell.contentView addSubview:locationLabel];
        locationLabel.text = message.Location.LocationAddress;
        [locationLabel setTextColor:[UIColor grayColor]];
        
        [locationLabel setTag:4];
        heightPos += ACTIVITY_LABEL_HEIGHT; //40 stand for the height of locationLabel and activityTimeLabel
    }
    else
    {
        NSString* str = message.Location.LocationDescription;
        cell.subjectLabel.text = [NSString stringWithFormat:@"在%@大声说:", str];
    }
    
    [cell.userNameLabel setText:message.User.UserName];
    NSString* genderPic = (message.User.Gender == 0) ? @"gender_boy_big.png" : @"gender_girl_big.png";
    [cell.genderImageView setImage:[UIImage imageNamed:genderPic]];
    
    
    //construct a lable show message
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightPos, 320, 0)];
    [cell.contentView addSubview:messageLabel];
    [messageLabel setTag:5];
    messageLabel.text = message.Text;
    [messageLabel sizeToFitFixedWidth:310 lines:3];
    
    //construct the photoViews
    if (message.PhotoThumbnail != nil)
    {
        float textHeight = [NSString calculateTextHeight:message.Text];
        UIImageView* photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, heightPos + textHeight, 90, 90)];
        [cell.contentView addSubview:photoView];
        [photoView setImageWithURL:[NSURL URLWithString:message.PhotoThumbnail]];
        [photoView setContentMode:UIViewContentModeScaleToFill];
        photoView.tag = 100;
    }
    
    //设置选中cell的style
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel* message = [messageArray objectAtIndex:[indexPath row]];
    NSString* photoURL = message.PhotoThumbnail;
    
    float textHeight = [NSString calculateTextHeight:message.Text];
    
    if (message.Type == 2)
    {
        textHeight += ACTIVITY_LABEL_HEIGHT;
    }
    if (photoURL == nil)
        return 60 + textHeight;
    else
    {
        NSLog(@"heightForRowAtIndexPath");
        // NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]];
        // UIImage* image = [UIImage imageWithData:imageData];
        return 60 + textHeight + 90 + 5;
    }
}
/*
 -(void)requestDataFromServer
 {
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestURL]];
 [request startSynchronous];
 NSError *error = [request error];
 if (error != nil)
 {
 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
 [alert show];
 return;
 }
 NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
 options:NSJSONReadingMutableContainers
 error:nil];
 for (NSDictionary* entry in jsonArray)
 {
 [messageArray addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
 }
 }*/
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
     
     [request startAsynchronous];
     
     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:requestURL]];
     [request startSynchronous];
     
     NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:[request responseData]
     options:NSJSONReadingMutableContainers
     error:nil];
     for (id entry in jsonArray)
     {
     [messageArray addObject:[[MessageModel alloc] initWithDictionary:entry error:nil]];
     }
     
     [self.tableView reloadData];
     
     [self stopLoading];*/
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    NSInteger row = [indexPath row];
    MessageModel* selectedMessage = [messageArray objectAtIndex:row];
    
    if (selectedMessage.Type == 2)
    {
        // ActivityDetailViewController* subViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailViewController"];
        ActivityDetailViewController* subViewController = [[ActivityDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }else{
        SpeakerDetailViewController* subViewController = [[SpeakerDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
}

#pragma mark - for NMPaginator
- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    self.footerLabel = label;
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(160, 22);
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.color = [UIColor blueColor];
    activityIndicatorView.hidesWhenStopped = YES;
    
    self.footerActivityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    
    self.tableView.tableFooterView = footerView;
}

- (void)updateTableViewFooter
{
    if ([self.messagePaginator.results count] != 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"%d results out of %d",
                                 [self.messagePaginator.results count], self.messagePaginator.total];
    } else
    {
        self.footerLabel.text = @"";
    }
    
    [self.footerLabel setNeedsDisplay];
}
- (void)fetchNextPage
{
    [self.messagePaginator fetchNextPage];
    [self.footerActivityIndicator startAnimating];
}
#pragma mark - end

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        // ask next page only if we haven't reached last page
        if(![self.messagePaginator reachedLastPage])
        {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark - Paginator delegate methods
- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    // update tableview footer
    [self updateTableViewFooter];
    [self.footerActivityIndicator stopAnimating];
    
    // update tableview content
    // easy way : call [tableView reloadData];
    // nicer way : use insertRowsAtIndexPaths:withAnimation:
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger i = [self.messagePaginator.results count] - [results count];
    [messageArray addObjectsFromArray:results];
    
    for(NSDictionary *result in results)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
}

- (void)paginatorDidReset:(id)paginator
{
    [self.tableView reloadData];
    [self updateTableViewFooter];
}

- (void)paginatorDidFailToRespond:(id)paginator
{
    // Todo
}
@end