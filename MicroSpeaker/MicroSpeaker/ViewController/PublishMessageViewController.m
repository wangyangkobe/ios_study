//
//  PublishMessageViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-12-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PublishMessageViewController.h"
#import "MacroDefination.h"
#import "NetWorkConnection.h"
#import "NSString+Emoji.h"
@interface PublishMessageViewController ()
{
    float latitude;
    float longitude;
    int   upLoadedImageNum; //已经上传的图片数目
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray* localImagesPath;
    NSMutableArray* qiNiuImagesPath;
}
@property (strong, nonatomic) NSArray* positonsArray;
@end

@implementation PublishMessageViewController

//static LocationHelper* locationHelper;

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //  [locationHelper start];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //   [locationHelper stop];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //   locationHelper = [LocationHelper sharedInstance];
    
    textViewDefaultHeight = SCREEN_HEIGHT / 3;
    localImagesPath = [[NSMutableArray alloc] init];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(publishMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(cancelPublishMessage)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.positonsArray = [NSArray arrayWithObjects:
                          [NSValue valueWithCGRect:CGRectMake(5,   5, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(80,  5, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(155, 5, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(230, 5, 70, 70)],
                          
                          [NSValue valueWithCGRect:CGRectMake(5,   80, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(80,  80, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(155, 80, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(230, 80, 70, 70)],
                          
                          [NSValue valueWithCGRect:CGRectMake(5,   155, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(80,  155, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(155, 155, 70, 70)],
                          [NSValue valueWithCGRect:CGRectMake(230, 155, 70, 70)],
                          
                          nil];
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    oneTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    areaID = selfUserInfo.Area.AreaID;
    areaName =  [NSString stringWithFormat:@"%@,%@", selfUserInfo.Area.AreaName, selfUserInfo.Area.City];
    
    qiNiuImagesPath = [NSMutableArray array];
    
    self.title = @"微喇叭广播";
    
    upLoadedImageNum = 0;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/4.0);
    [activityIndicator setHidesWhenStopped:YES];
    activityIndicator.color = [UIColor blueColor];
    [self.tableView addSubview: activityIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
}

-(void)cancelPublishMessage
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"是否保存消息?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
    [alertView show];
}
-(void)publishMessage
{
    NSLog(@"local images path:%@", [localImagesPath description]);
    [textView resignFirstResponder];
    latitude  = 0.0;//locationHelper.currentLocation.coordinate.latitude;
    longitude = 0.0;//locationHelper.currentLocation.coordinate.longitude;
    
    if (upLoadedImageNum < [localImagesPath count])
    {
        [activityIndicator setHidden:NO];
        [activityIndicator startAnimating];
        [self uploadFile:[localImagesPath objectAtIndex:upLoadedImageNum]
                  bucket:QiniuBucketName
                     key:[NSString generateQiNiuFileName]];
    }
    else //没有图片要上传
    {
        [self sendMessageToServer];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // return ![NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"];
    return YES;
}
-(void)backGroundTap
{
    [textView resignFirstResponder];
}

#pragma mark - UIAlertView delegate method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex) //是,需要进行存档
    {
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    int row = [indexPath row];
    int section = [indexPath section];
    if (0 == row && 2 == section) {
        SelectAreaViewController* selectController = [[SelectAreaViewController alloc] init];
        selectController.areaId = areaID;
        selectController.delegate = self;
        [self.navigationController pushViewController:selectController animated:YES];
    }
    else if(0 == row && section == 0)
    {
        [textView becomeFirstResponder];
    }
    else
    {
        if (0 == [localImagesPath count])
            return;
        UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
		UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(handleTrashButtonTouch:)];
        NSArray *barItems = [NSArray arrayWithObjects:trashButton, nil];
		
		imageGallery = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [self.navigationController pushViewController:imageGallery animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    int section = [indexPath section];
    if (0 == row && 0 == section)
    {
        static NSString *TextCellIdentifier = @"TextViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, textViewDefaultHeight)];
            textView.isScrollable = NO;
            textView.minNumberOfLines = 1;
            textView.maxNumberOfLines = 100;
            textView.returnKeyType = UIReturnKeySend;
            textView.font = [UIFont systemFontOfSize:14];
            textView.layer.cornerRadius =5.0;
            textView.layer.masksToBounds = YES;
            textView.delegate = self;
            textView.placeholder = @"亲，请输入您想说的话......";
            textView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:textView];
        }
        [textView becomeFirstResponder];
        return cell;
    }
    else if (1 == section && 0 == row)
    {
        int count = [localImagesPath count];
        static NSString* ImageCellIdentifier = @"LoadImageCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ImageCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ImageCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            loadImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [loadImageButton setImage:[UIImage imageNamed:@"loadImage"] forState:UIControlStateNormal];
            
            [loadImageButton addTarget:self action:@selector(loadPicture) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:loadImageButton];
        }
        NSLog(@"%@ images count:%d", NSStringFromSelector(_cmd), count);
        if (count < 4)
            [loadImageButton setFrame:[[self.positonsArray objectAtIndex:count] CGRectValue]];
        
        [self removeImageViewsFromCell:cell];
        
        for (int i  = 0; i < MIN(count, 4); i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithImage:
                                      [[UIImage imageWithContentsOfFile:[localImagesPath objectAtIndex:i]]
                                       imageByScalingAndCroppingForSize:CGSizeMake(70, 70)]];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setFrame:[[self.positonsArray objectAtIndex:i] CGRectValue]];
            [cell.contentView addSubview:imageView];
        }
        
        return  cell;
    }
    else
    {
        static NSString* AreaCellIdentifier = @"AreaCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AreaCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AreaCellIdentifier];
            cell.textLabel.text = @"推送社区";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            
            UILabel* areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 235, 40)];
            [areaLabel setBackgroundColor:[UIColor clearColor]];
            [areaLabel setTag:10000];
            areaLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:areaLabel];
        }
        UILabel* label = (UILabel*)[cell viewWithTag:10000];
        label.text = areaName;
        
        return cell;
    }
}
-(void)removeImageViewsFromCell:(UITableViewCell*)cell
{
    for (UIView* view in [cell.contentView subviews])
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            @autoreleasepool {
                [view removeFromSuperview];
            }
        }
    }
}
-(void)loadPicture
{
    UIActionSheet* chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2 == buttonIndex) //取消
        return;
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (0 == buttonIndex) //拍照
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            NSLog(@"模拟器无法打开相机!");
    }
    else if(1 == buttonIndex)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(id)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSDictionary *mediaInfoArray = (NSDictionary *)info;
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), [mediaInfoArray description]);
    
    UIImage* originalImage = [mediaInfoArray objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSString* imageName = [NSString stringWithFormat:@"wy_%d", [localImagesPath count]];
    NSString* imagePath = [UIImage saveImage:originalImage withName:imageName];
    [localImagesPath addObject:imagePath];
    
    //  [self uploadFile:imagePath bucket:QiniuBucketName key:imageName];
    
    [self.tableView reloadData];
}

#pragma mark UITableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = [indexPath row];
    int section = [indexPath section];
    if (0 == section && 0 == row) {
        return textViewDefaultHeight;
    }
    else if(1 == section && 0 == row)
    {
        int row = [localImagesPath count] / 4;
        return 80 + 75 * row;
    }
    else{
        return 40;
    }
}

#pragma mark HPGrowingTextViewDelegate Methods
-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    NSLog(@"growing TextView height = %f", height);
    if (height > textViewDefaultHeight)
    {
        textViewDefaultHeight = height;
        [self tableViewNeedsToUpdateHeight];
    }
}
- (void)tableViewNeedsToUpdateHeight
{
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:animationsEnabled];
}

#pragma mark - SelectAreaViewController delelgate
-(void)selectAreaViewController:(SelectAreaViewController *)viewController didFinishSelectAreaId:(int)Id areaName:(NSString *)Name
{
    areaID = Id;
    areaName = Name;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    return [localImagesPath count];
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImagesPath objectAtIndex:index];
}
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;
{
    return FGalleryPhotoSourceTypeLocal;
}
- (void)handleTrashButtonTouch:(id)sender
{
    int deletedImageIndex = [imageGallery currentIndex];
    [imageGallery removeImageAtIndex:deletedImageIndex];
    [localImagesPath removeObjectAtIndex:deletedImageIndex];
    
    [imageGallery reloadGallery];
    [self.tableView reloadData];
}

#pragma mark - QiniuUploadDelegate
// Upload completed successfully.
- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSString *key = [ret objectForKey:@"key"];
    NSString* path = [QiniuDomian stringByAppendingString:key];
    NSLog(@"qi niu image path:%@", path);
    
    [qiNiuImagesPath addObject:path];
    upLoadedImageNum++;
    if(upLoadedImageNum < [localImagesPath count]){
        [self uploadFile:[localImagesPath objectAtIndex:upLoadedImageNum]
                  bucket:QiniuBucketName
                     key:[NSString generateQiNiuFileName]];
    }
    if ([qiNiuImagesPath count] == [localImagesPath count]) {
        [self sendMessageToServer];
    }
}

// Upload failed.
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    NSString *message = @"";
    
    // For first-time users, this is an easy-to-forget preparation step.
    if ([QiniuAccessKey hasPrefix:@"<Please"])
    {
        message = @"Please replace kAccessKey, kSecretKey and kBucketName with proper values.";
    }
    else {
        message = [NSString stringWithFormat:@"Failed uploading %@ with error: %@",  filePath, error];
        //继续重传
        [self uploadFile:filePath bucket:QiniuBucketName key:[NSString generateQiNiuFileName]];
    }
}

- (NSString *)tokenWithScope:(NSString *)scope
{
    QiniuPutPolicy *policy = [QiniuPutPolicy new] ;
    policy.scope = scope;
    return [policy makeToken:QiniuAccessKey secretKey:QiniuSecretKey];
}

-(void)upLoadMutilImages:(NSArray*)imagesPath bucket:(NSString *)bucket
{
    for (NSString* imagePath in imagesPath)
    {
        [self uploadFile:imagePath bucket:bucket key:[NSString generateQiNiuFileName]];
    }
}
- (void)uploadFile:(NSString *)filePath bucket:(NSString *)bucket key:(NSString *)key
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        if(qiNiuUpLoader == nil)
            qiNiuUpLoader = [QiniuSimpleUploader uploaderWithToken:[self tokenWithScope:bucket]];
        qiNiuUpLoader.delegate = self;
        [qiNiuUpLoader uploadFile:filePath key:key extra:nil];
    }
}

-(void)sendMessageToServer
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:qiNiuImagesPath options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [[textView text] stringByReplacingEmojiUnicodeWithCheatCodes]);
    [[NetWorkConnection sharedInstance] publishMessage:1
                                              fromTime:nil
                                                toTime:nil
                                                 theme:nil
                                       activityAddress:nil
                                                   tel:nil
                                                 price:nil
                                          commerceType:nil
                                                  text:[[textView text] stringByReplacingEmojiUnicodeWithCheatCodes]
                                                areaID:areaID
                                                   lat:0 long:0
                                               address:@"淞虹路"
                                   locationDescription:@"天山西路"
                                                  city:selfUserInfo.City
                                              province:selfUserInfo.Province
                                               country:nil
                                                   url:jsonString
                                               pushNum:50];
    
    [activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
    //通知父视图获取最新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"publishMessageSuccess" object:self userInfo:nil];
    
}
@end
