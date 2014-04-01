//
//  PublishSaleViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-1-2.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "PublishSaleViewController.h"
#import "UIImage+Extensions.h"
#import "NetWorkConnection.h"
#import "SelectAreaViewController.h"
#import "NSString+Extensions.h"
#import "MacroDefination.h"
#import "HPGrowingTextView.h"
#import "UserInfoModel.h"
#define textViewDefaultHeight 44*2

@interface PublishSaleViewController ()<StringInputTableViewCellDelegate, SimplePickerInputTableViewCellDelegate, HPGrowingTextViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    NSArray* positonsArray;
    UIButton* loadImageButton;
    
    NSMutableArray* localImagesPath;
    NSMutableArray* qiNiuImagesPath;
    int upLoadImageNumber; //已上传的图像数目
    
    NSArray* commerceTypesArray;
    NSMutableArray* commerceTypesName;
    NSString* selectCommerceType; //商品类型
    
    int selectAreaID; //推送的社区
    NSString* selectAreaName;
    NSMutableArray* areaNamesArray;
    
    UITextField* priceTextField;
    NSString* telNumber;
    
    QiniuSimpleUploader* qiNiuUpLoader;
    
    HPGrowingTextView* descriptionTextView;
    
    NSString* themeStr;
    
    UserInfoModel* selfUserInfo;
    
    UIActivityIndicatorView* activityIndicator;
}

@end

@implementation PublishSaleViewController

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
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;
    self.hidesBottomBarWhenPushed = YES;
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    positonsArray = [NSArray arrayWithObjects:
                     [NSValue valueWithCGRect:CGRectMake(5,   10, 70, 70)],
                     [NSValue valueWithCGRect:CGRectMake(80,  10, 70, 70)],
                     [NSValue valueWithCGRect:CGRectMake(155, 10, 70, 70)],
                     [NSValue valueWithCGRect:CGRectMake(230, 10, 70, 70)], nil];
    
    self.title = @"转让物品";
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(publishSaleMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    localImagesPath = [NSMutableArray array];
    upLoadImageNumber = 0;
    qiNiuImagesPath = [NSMutableArray array];
    commerceTypesName = [NSMutableArray array];
    
    areaNamesArray = [NSMutableArray array];
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        commerceTypesArray = [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getCommerceType]];
        for (CommerceTypeModel* element in commerceTypesArray) {
            [commerceTypesName addObject:element.TypeName];
        }
        
        for (AreaModel* element in [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getArea]]) {
            [areaNamesArray addObject:[NSString stringWithFormat:@"%@,%@", element.AreaName, element.City]];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
        selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    });
    
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    oneTap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0);
    [activityIndicator setHidesWhenStopped:YES];
    activityIndicator.color = [UIColor blueColor];
    [self.tableView addSubview: activityIndicator];
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row)
    {
        static NSString* CellIdentifier = @"LoadImageCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            loadImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [loadImageButton setImage:[UIImage imageNamed:@"loadImage"] forState:UIControlStateNormal];
            
            [loadImageButton addTarget:self action:@selector(loadPicture) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:loadImageButton];
        }
        int imageCount = [localImagesPath count];
        NSLog(@"image count = %d", imageCount);
        if (imageCount < 4)
            [loadImageButton setFrame:[[positonsArray objectAtIndex:imageCount] CGRectValue]];
        else
            [loadImageButton removeFromSuperview];
        
        for (int i  = 0; i < MIN(imageCount, 4); i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithImage:
                                      [[UIImage imageWithContentsOfFile:[localImagesPath objectAtIndex:i]]
                                       imageByScalingAndCroppingForSize:CGSizeMake(70, 70)]];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            [imageView setFrame:[[positonsArray objectAtIndex:i] CGRectValue]];
            [cell.contentView addSubview:imageView];
        }
        return cell;
    }
    else if(1 == row){
        static NSString* CellIdentifier = @"NameCellIdentifier";
        StringInputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"标  题:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textField.placeholder = @"建议填写商品品牌和名称...      ";
        cell.textField.textColor = [UIColor blueColor];
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
    }
    else if(2 == row)
    {
        static NSString *CellIdentifier = @"DescriptionTextViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            descriptionTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, textViewDefaultHeight)];
            descriptionTextView.isScrollable = YES;
            descriptionTextView.minNumberOfLines = 1;
            descriptionTextView.maxNumberOfLines = 4;
            descriptionTextView.returnKeyType = UIReturnKeySend;
            descriptionTextView.font = [UIFont systemFontOfSize:14];
            descriptionTextView.delegate = self;
            descriptionTextView.placeholder = @"10-800个字，介绍一下具体情况";
            descriptionTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:descriptionTextView];
        }
        return cell;
    }
    else if(3 == row)
    {
        static NSString* CellIdentifier = @"TypeCellIdentifier";
        SimplePickerInputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.values = commerceTypesName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"分  类:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        if (selectCommerceType == nil)
            [cell setValue:@"请选择分类"];
        else
            [cell setValue:selectCommerceType];
        
        cell.delegate = self;
        
        return cell;
    }
    else if(4 == row)
    {
        static NSString* CellIdentifier = @"PriceCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 12, 200, 44)];
            priceTextField.textAlignment = NSTextAlignmentRight;
            priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:priceTextField];
            priceTextField.delegate = self;
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 44)];
            [label setText:@"左右"];
            label.font = [UIFont systemFontOfSize:18];
            [cell.contentView addSubview:label];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"价  格:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        priceTextField.placeholder = @"数字填写，不能为0和负数";
        return cell;
    }
    else if(5 == row)
    {
        static NSString* CellIdentifier = @"PhoneNumberCellIdentifier";
        StringInputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"联系电话:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textField.placeholder = @"只能填写手机或固话号码";
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        cell.textField.returnKeyType = UIReturnKeyDone;
        return cell;
    }
    else if(6 == row){
        static NSString* CellIdentifier = @"AreaCellIdentifier";
        SimplePickerInputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.values = areaNamesArray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"推送社区:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        if (selectAreaName == nil)
            [cell setValue:@"请选择社区"];
        else
            [cell setValue:selectAreaName];
        
        cell.delegate = self;
        return cell;
    }
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    if (0 == row) {
        return 90;
    }
    else if(2 == row)
    {
        return textViewDefaultHeight;
    }
    else
        return 44;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 5)
        return NO;
    else
        return YES;
}
-(void)loadPicture
{
    UIActionSheet* chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [chooseImageSheet showInView:self.view];
}
#pragma mark - UIGestureRecognizerDelegate method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
-(void)backGroundTap
{
    [self.view endEditing:YES];
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
    UIImage* scaleImage = [originalImage imageByScalingAndCroppingForSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSString* imageName = [NSString stringWithFormat:@"wy_%d", [localImagesPath count]];
    NSString* imagePath = [UIImage saveImage:scaleImage withName:imageName];
    [localImagesPath addObject:imagePath];
    
    [self.tableView reloadData];
}

#pragma mark - StringInputTableViewCellDelegate
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    NSLog(@"value====:%@", value);
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    int selcetRow = [indexPath row];
    if (5 == selcetRow) {
        telNumber = value;
    }
    else if(1 == selcetRow)
    {
        themeStr = value;
    }
}
#pragma mark - SimplePickerInputTableViewCellDelegate
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    int selcetRow = [indexPath row];
    if (3 == selcetRow) {
        selectCommerceType = [NSString stringWithFormat:@"%d", [commerceTypesName indexOfObject:value]];
    }
    else if(6 == selcetRow)
    {
        selectAreaName = value;
        if ([selectAreaName containsString:@"复旦大学"]) {
            selectAreaID = 1;
        }
        else if([selectAreaName containsString:@"华东理工大学"]){
            selectAreaID = 2;
        }
    }
}
-(void)publishSaleMessage
{
    [activityIndicator startAnimating];
    if (telNumber != nil && selectCommerceType != nil && priceTextField.text != nil && descriptionTextView.text != nil)
    {
        if ([localImagesPath count] > 0)
            [self uploadFile:[localImagesPath objectAtIndex:upLoadImageNumber] bucket:QiniuBucketName key:[NSString generateQiNiuFileName]];
        else
            [self sendMessageToServer];
    }
    else{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"错误提示!"
                                                            message:@"请输入完整信息!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}
#pragma mark - QiniuUploadDelegate
// Upload completed successfully.
- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSString* path = [QiniuDomian stringByAppendingString:[ret objectForKey:@"key"]];
    NSLog(@"qi niu image path:%@", path);
    
    [qiNiuImagesPath addObject:path];
    upLoadImageNumber++;
    if(upLoadImageNumber < [localImagesPath count]){
        [self uploadFile:[localImagesPath objectAtIndex:upLoadImageNumber]
                  bucket:QiniuBucketName
                     key:[NSString generateQiNiuFileName]];
    }
    if ([qiNiuImagesPath count] == [localImagesPath count]) {
        [self sendMessageToServer];
    }
}
-(void)sendMessageToServer
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:qiNiuImagesPath options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[NetWorkConnection sharedInstance] publishMessage:4
                                              fromTime:nil
                                                toTime:nil
                                                 theme:themeStr
                                       activityAddress:nil
                                                   tel:telNumber
                                                 price:[priceTextField text]
                                          commerceType:selectCommerceType
                                                  text:[descriptionTextView text]
                                                areaID:selectAreaID
                                                   lat:0
                                                  long:0
                                               address:@"淞虹路"
                                   locationDescription:@"天山西路"
                                                  city:selfUserInfo.City
                                              province:selfUserInfo.Province
                                               country:nil
                                                   url:jsonString
                                               pushNum:50];
    
    [activityIndicator stopAnimating];
    //通知父视图获取最新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"publishMessageSuccess" object:self userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES ];
}
// Upload failed.
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    NSString *message = @"";
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

- (void)uploadFile:(NSString *)filePath bucket:(NSString *)bucket key:(NSString *)key
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSLog(@"%@, %@", filePath, key);
    if ([manager fileExistsAtPath:filePath]) {
        if(qiNiuUpLoader == nil)
            qiNiuUpLoader = [QiniuSimpleUploader uploaderWithToken:[self tokenWithScope:bucket]];
        qiNiuUpLoader.delegate = self;
        [qiNiuUpLoader uploadFile:filePath key:key extra:nil];
    }
}
@end
