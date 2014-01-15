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
#import "PublishSaleViewController.h"
#import "MHFacebookImageViewer.h"
#import "SaleDetailViewController.h"
#import "PublishBuyViewController.h"

@interface MainTabViewController ()<MHFacebookImageViewerDatasource>{
    UserInfoModel* selfUserInfo;
}
-(NSString*) dataFilePath; //归档文件的路径
-(void)applicationWillResignActive:(NSNotification*)notification;
@end

@implementation MainTabViewController

@synthesize messagesArray;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self)
//    {
//        // Custom initialization
//    }
//    return self;
//}

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
        selfUserInfo = [[NetWorkConnection sharedInstance] showSelfUserInfo];
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:selfUserInfo];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:encodedObject forKey:SELF_USERINFO];
        [defaults synchronize];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _pullTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    _pullTableView.dataSource = self;
    _pullTableView.delegate = self;
    _pullTableView.pullDelegate = self;
    self.view = _pullTableView;
    
    NSLog(@"call: %@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    UIApplication* app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:app];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullDownRefresh)
                                                 name:@"publishMessageSuccess" object:nil];
    
    messagesArray = [[NSMutableArray alloc] init];
    
    __block NSMutableArray* storedMessages;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData* data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
        if (data != nil){
            NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            storedMessages = [unarchiver decodeObjectForKey:kDataKey];
            [unarchiver finishDecoding];
            messagesArray = [storedMessages mutableCopy];
            NSLog(@"%d", [storedMessages count]);
        }
        else{
            NSArray* fetchNewMessage = [[NetWorkConnection sharedInstance] getMessageByAreaID:selfUserInfo.Area.AreaID
                                                                                     PageSize:15
                                                                                         Page:1];
            messagesArray = [fetchNewMessage mutableCopy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_pullTableView reloadData];
        });
    });
    
    //添加导航栏左边的发布信息按钮
    UIBarButtonItem* publishButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                   target:self
                                                                                   action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem =  publishButton;
}

-(void)applicationWillResignActive:(NSNotification*) notification{
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

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:1.5f];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:3.0f];
}

#pragma mark - Refresh and load more methods
- (void)refreshTable {
    if (0 == [messagesArray count])
        return;
    self.pullTableView.pullTableIsRefreshing = YES;
    long sinceId = ((MessageModel*)messagesArray[0]).MessageID;
    [self getNewMessageBySinceID:[NSNumber numberWithLong:sinceId]];
}

- (void)loadMoreDataToTable
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MessageModel* lastMessage = [messagesArray lastObject];
       NSArray* loadMoreRes =  [[NetWorkConnection sharedInstance] getMessageByAreaID:selfUserInfo.Area.AreaID
                                                                               PageSize:15
                                                                                  maxID:lastMessage.MessageID];
        __block NSInteger fromIndex = [messagesArray count];
        [messagesArray addObjectsFromArray:loadMoreRes];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            
            for(NSDictionary *result in loadMoreRes){
                [indexPaths addObject:[NSIndexPath indexPathForRow:fromIndex inSection:0]];
                fromIndex++;
            }
            
            [_pullTableView beginUpdates];
            [_pullTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
            [_pullTableView endUpdates];
       //     [_pullTableView scrollToRowAtIndexPath:indexPaths[0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.pullTableView.pullTableIsLoadingMore = NO;
        });
    });
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
    else if(4 == message.Type)
    {
        NSString* str = message.Location.LocationDescription;
        cell.subjectLabel.text = [NSString stringWithFormat:@"在%@,转让", str];
    }
    else
    {
        NSString* str = message.Location.LocationDescription;
        cell.subjectLabel.text = [NSString stringWithFormat:@"在%@,求购:", str];
    }
    
    if (1 == message.Type || message.Type == 2) {
        [cell.userNameLabel setText:message.User.UserName];
        NSString* genderPic = (message.User.Gender == 0) ? @"gender_boy_big.png" : @"gender_girl_big.png";
        [cell.genderImageView setImage:[UIImage imageNamed:genderPic]];
    }
    else
    {
        [cell.userNameLabel removeFromSuperview];
        [cell.genderImageView removeFromSuperview];
        UILabel* saleTheme = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 250, 15)];
        saleTheme.text = message.Theme;
        [cell.contentView addSubview:saleTheme];
        [saleTheme setTag:1111];
    }
    
    //construct a lable show message
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, heightPos, SCREEN_WIDTH, 0)];
    [cell.contentView addSubview:messageLabel];
    [messageLabel setTag:5];
    if (1 == message.Type || 2 == message.Type) {
        messageLabel.text = message.Text;
    }
    else
    {
        messageLabel.text = [NSString stringWithFormat:@"%@;联系电话:%@", message.Text, message.Tel];
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 5, 70, 40)];
        priceLabel.text = [NSString stringWithFormat:@"%@元", message.Price];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont boldSystemFontOfSize:18];
        [cell.contentView addSubview:priceLabel];
        [priceLabel setTag:1112];
    }
    [messageLabel sizeToFitFixedWidth:310 lines:3];
    
    //construct the photoViews to show images
    int stopFlag = 1;
    float textHeight = [NSString calculateTextHeight:messageLabel.text];
    for (NSString* imagePath in message.PhotoThumbnails) {
        if (stopFlag == 4)
            break;
        UIImageView* photoView = [[UIImageView alloc] initWithFrame:CGRectMake(5 * stopFlag + 90 * (stopFlag-1),
                                                                               heightPos + textHeight, 90, 90)];
        [cell.contentView addSubview:photoView];
        __weak UIImageView* weakPhotoView = photoView;
        [photoView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"placeholder"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
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
    
    float textHeight = 0;
    if (message.Type == 4 || message.Type == 3) {
        textHeight = [NSString calculateTextHeight:[NSString stringWithFormat:@"%@;联系电话:%@", message.Text, message.Tel]];
    }
    else
        textHeight = [NSString calculateTextHeight:message.Text];
    
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

- (void)getNewMessageBySinceID:(NSNumber*) sinceId{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray* newMessages = [[NetWorkConnection sharedInstance] getMessageByAreaID:selfUserInfo.Area.AreaID
                                                                              sinceID:[sinceId longValue]];
        for (MessageModel* message in [newMessages reverseObjectEnumerator])
        {
            [messagesArray insertObject:message atIndex:0];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (_pullTableView.pullTableIsRefreshing == YES) {
                _pullTableView.pullTableIsRefreshing = NO;
                [_pullTableView reloadData];
            }
        });
    });
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
    
    NSInteger row = [indexPath row];
    
    MessageModel* selectedMessage = [messagesArray objectAtIndex:row];
    if (ActivityMessage == selectedMessage.Type)
    {
        ActivityDetailViewController* subViewController = [[ActivityDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
    else if(SpeakerMessage == selectedMessage.Type){
        SpeakerDetailViewController* subViewController = [[SpeakerDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
    else if(SaleMessage == selectedMessage.Type){
        SaleDetailViewController* subViewController = [[SaleDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
    else{
        //可以共用同一个类
        SaleDetailViewController* subViewController = [[SaleDetailViewController alloc] init];
        subViewController.message = selectedMessage;
        [self.navigationController pushViewController:subViewController animated:YES];
    }
}


-(void)showMenu
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"大声说"   image:nil target:self action:@selector(showController:)],
      [KxMenuItem menuItem:@"搞活动"   image:nil target:self action:@selector(showController:)],
      [KxMenuItem menuItem:@"转让物品" image:nil target:self action:@selector(showController:)],
      [KxMenuItem menuItem:@"求购物品" image:nil target:self action:@selector(showController:)],
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
    else if([menuItem.title isEqualToString:@"搞活动"]){
        PublishActivityViewController* controller = [[PublishActivityViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([menuItem.title isEqualToString:@"转让物品"]){
        PublishSaleViewController* controller = [[PublishSaleViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        PublishBuyViewController* controller = [[PublishBuyViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
#pragma mark - MHFacebookImageViewerDatasource delegate methods
- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    UITableViewCell* cell = (UITableViewCell*)[[imageViewer.senderView superview] superview];
    int rowIndex = [[self.pullTableView indexPathForCell:cell] row];
    MessageModel* currentMessage = [messagesArray objectAtIndex:rowIndex];
    return [currentMessage.PhotoThumbnails count];
}
- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    UITableViewCell* cell = (UITableViewCell*)[[imageViewer.senderView superview] superview];
    int rowIndex = [[self.pullTableView indexPathForCell:cell] row];
    MessageModel* currentMessage = [messagesArray objectAtIndex:rowIndex];
    return [currentMessage.PhotoThumbnails objectAtIndex:index];
}
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    NSLog(@"INDEX IS %i",index);
    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
}
@end