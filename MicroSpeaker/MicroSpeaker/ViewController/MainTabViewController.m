//
//  MainTabViewController.m
//  MicroSpeaker
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "MainTabViewController.h"
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
#import "KxMenu.h"
#import "PublishMessageViewController.h"
#import "PublishActivityViewController.h"

#import "MHFacebookImageViewer.h"

@interface MainTabViewController ()<MHFacebookImageViewerDatasource>
-(NSString*) dataFilePath; //归档文件的路径
-(void)applicationWillResignActive:(NSNotification*)notification;
@end

@implementation MainTabViewController

@synthesize messagesArray;
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
    BOOL checkResut = [[NetWorkConnection sharedInstance] checkUser:WEIBO_ID];
    if (checkResut) {
        UserInfoModel* selfUserInfo = [[NetWorkConnection sharedInstance] showSelfUserInfo];
       
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selfUserInfo];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedObject forKey:SELF_USERINFO];
        [defaults synchronize];
    }
    
}

- (void)viewDidLoad
{
    NSLog(@"call: %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UIApplication* app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:app];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefresh)
                                                 name:@"publishMessageSuccess" object:nil];
    
    [super viewDidLoad];
    messagesArray = [[NSMutableArray alloc] init];
    
    // set up the paginator
    [self setupTableViewFooter];
    self.messagePaginator = [[MessagePaginator alloc] initWithPageSize:15 delegate:self];
    
    __block NSMutableArray* storedMessages;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        if (data != nil)
        {
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            storedMessages = [unarchiver decodeObjectForKey:kDataKey];
            [unarchiver finishDecoding];
            NSLog(@"%d", [storedMessages count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                messagesArray = [storedMessages mutableCopy];
                [self.tableView reloadData];
            });
        }
        else
        {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.messagePaginator fetchFirstPage];
            });
        }
    });
    
    //添加导航栏左边的发布信息按钮
    UIBarButtonItem* publishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                   target:self
                                                                                   action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem =  publishButton;
}

-(void)applicationWillResignActive:(NSNotification*) notification
{
    //当app变成inActive时（进入backgroud），将数据存储起来
    NSMutableData* data = [[NSMutableData alloc] init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:[messagesArray subarrayWithRange:NSMakeRange(0, 15)] forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
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
    return [messagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel* message = [messagesArray objectAtIndex:[indexPath row]];
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
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightPos, SCREEN_WIDTH, 0)];
    [cell.contentView addSubview:messageLabel];
    [messageLabel setTag:5];
    messageLabel.text = message.Text;
    [messageLabel sizeToFitFixedWidth:310 lines:3];
    
    //construct the photoViews to show images
    int stopFlag = 1;
    float textHeight = [NSString calculateTextHeight:message.Text];
    for (NSString* imagePath in message.PhotoThumbnails) {
        if (stopFlag == 4)
            break;
        UIImageView* photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5 * stopFlag + 90 * (stopFlag-1),
                                                                               heightPos + textHeight, 90, 90)];
        [cell.contentView addSubview:photoView];
        __weak UIImageView* weakPhotoView = photoView;
        [photoView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [weakPhotoView setImage:[image imageByScalingAndCroppingForSize:CGSizeMake(90, 90)]];
        }];
        [photoView setContentMode:UIViewContentModeScaleToFill];
        photoView.tag = 1000;
        
        //处理点击图片进行浏览
        photoView.clipsToBounds = YES;
        [photoView setupImageViewerWithDatasource:self initialIndex:stopFlag - 1 onOpen:^{
            NSLog(@"OPEN!");
        } onClose:^{
            NSLog(@"CLOSE!");
        }];
        
        stopFlag++;
    }
    
    //设置选中cell的style
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel* message = [messagesArray objectAtIndex:[indexPath row]];
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
        return 60 + textHeight + 90 + 5;
    }
}

//重写PullRefreshTableViewController中的pullDownRefresh方法，实现下拉获取新的消息
- (void)pullDownRefresh
{
    if (0 == [messagesArray count])
        return;
    long sinceId = ((MessageModel*)messagesArray[0]).MessageID;
    [self performSelector:@selector(getNewMessageBySinceID:) withObject:[NSNumber numberWithLong:sinceId] afterDelay:1.0];
}

- (void)getNewMessageBySinceID:(NSNumber*) sinceId
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
        UserInfoModel *selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];

        NSArray* newMessages = [[NetWorkConnection sharedInstance] getMessageByAreaID:selfUserInfo.Area.AreaID
                                                                             sinceID:[sinceId longValue]];
        for (MessageModel* message in [newMessages reverseObjectEnumerator])
        {
            [messagesArray insertObject:message atIndex:0];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self stopLoading];
        });
    });
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    NSInteger row = [indexPath row];
    
    MessageModel* selectedMessage = [messagesArray objectAtIndex:row];
    if (selectedMessage.Type == 2)
    {
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
    label.font = [UIFont boldSystemFontOfSize:14];
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
        [self.footerLabel setFont:[UIFont systemFontOfSize:14]];
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
    if ([messagesArray count] == 0) {
        self.messagePaginator.lastMessageId = -1; //去从第一页获取
    }
    else{ //获取最后一条消息还要早的消息
        MessageModel* lastMessage = (MessageModel*)[messagesArray lastObject];
        self.messagePaginator.lastMessageId = lastMessage.MessageID;
    }
    [self.messagePaginator fetchNextPage];
    [self.footerActivityIndicator startAnimating];
}

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
    [messagesArray addObjectsFromArray:results];
    
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

-(void)showMenu
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"大声说" image:nil target:self action:@selector(showController:)],
      [KxMenuItem menuItem:@"搞活动" image:nil target:self action:@selector(showController:)],
      ];
    
    for (KxMenuItem* item in menuItems){
        item.alignment = NSTextAlignmentCenter;
    }
    
    [KxMenu setTintColor:[UIColor whiteColor]];
  //  [KxMenu showMenuInView:self.view fromRect:CGRectMake(0, -30, 30, 30) menuItems:menuItems];
    [KxMenu showMenuInView:[[UIApplication sharedApplication].delegate window] fromRect:CGRectMake(0, 30, 30, 30) menuItems:menuItems];
}
-(void)showController:(id)sender{
    KxMenuItem* menuItem = (KxMenuItem*)sender;
    if ([menuItem.title isEqualToString:@"大声说"]) {
        PublishMessageViewController* controller = [[PublishMessageViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        PublishActivityViewController* controller = [[PublishActivityViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark - MHFacebookImageViewerDatasource delegate methods
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    UITableViewCell* cell = (UITableViewCell*)[[imageViewer.senderView superview] superview];
    int rowIndex = [[self.tableView indexPathForCell:cell] row];
    MessageModel* currentMessage = [messagesArray objectAtIndex:rowIndex];
    return [currentMessage.PhotoThumbnails count];
}
- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    UITableViewCell* cell = (UITableViewCell*)[[imageViewer.senderView superview] superview];
    int rowIndex = [[self.tableView indexPathForCell:cell] row];
    MessageModel* currentMessage = [messagesArray objectAtIndex:rowIndex];
    return [currentMessage.PhotoThumbnails objectAtIndex:index];
}
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    NSLog(@"INDEX IS %i",index);
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
}
@end