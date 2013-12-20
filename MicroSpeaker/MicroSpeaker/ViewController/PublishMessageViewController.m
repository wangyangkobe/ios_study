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

#define kImagePositionx @"positionX"
#define kImagePositiony @"positionY"

@interface PublishMessageViewController ()
@property (strong, nonatomic) NSArray* positonsArray;
@end

@implementation PublishMessageViewController

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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    textViewDefaultHeight = SCREEN_HEIGHT / 3;
    imagesArray = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(publishMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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
    UserInfoModel *selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    areaID = selfUserInfo.Area.AreaID;
    areaName =  [NSString stringWithFormat:@"%@,%@", selfUserInfo.Area.AreaName, selfUserInfo.Area.City];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
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
        if (0 == [imagesArray count])
            return;
        UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
		UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)];
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
    NSLog(@"call: %@, row = %d, section = %d", NSStringFromSelector(_cmd), row, section);
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
            textView.font = [UIFont systemFontOfSize:13];
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
        int count = [imagesArray count];
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
        NSLog(@"count:%d", count);
        if (count < 12)
            [loadImageButton setFrame:[[self.positonsArray objectAtIndex:count] CGRectValue]];
        
        [self removeImageViewsFromCell:cell];
        
        for (int i  = 0; i < count; i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithImage:
                                      [[UIImage imageWithContentsOfFile:[imagesArray objectAtIndex:i]]
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
        NSLog(@"areaName = %@", areaName);
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
    NSLog(@"%@", [mediaInfoArray description]);
    
    UIImage* originalImage = [mediaInfoArray objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSString* imageName = [NSString stringWithFormat:@"wy_%d", [imagesArray count]];
    NSString* imagePath = [self saveImage:originalImage withName:imageName];
    [imagesArray addObject:imagePath];
    
    [self.tableView reloadData];
    NSLog(@"Selected %d photos", imagesArray.count);
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
        int row = [imagesArray count] / 4;
        return 80 + 75 * row;
    }
    else{
        return 40;
    }
}

#pragma mark HPGrowingTextViewDelegate Methods
-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    NSLog(@"height = %f", height);
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
    return [imagesArray count];
}
- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [imagesArray objectAtIndex:index];
}
- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;
{
    return FGalleryPhotoSourceTypeLocal;
}
- (void)handleTrashButtonTouch:(id)sender {

    [imageGallery removeImageAtIndex:[imageGallery currentIndex]];
    [imagesArray removeObjectAtIndex:[imageGallery currentIndex]];
    [imageGallery reloadGallery];
    [self.tableView reloadData];
}

- (NSString*)saveImage:(UIImage *)image withName:(NSString *)name {
    
    //grab the data from our image
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    //get a path to the documents Directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Add out name to the end of the path with .PNG
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    //Save the file, over write existing if exists.
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
    return fullPath;
}
@end
