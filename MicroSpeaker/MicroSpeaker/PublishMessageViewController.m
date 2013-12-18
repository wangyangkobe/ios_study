//
//  PublishMessageViewController.m
//  MicroSpeaker
//
//  Created by wy on 13-12-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PublishMessageViewController.h"
#import "MacroDefination.h"

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    defaultHeight = SCREEN_HEIGHT / 3;
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
                          nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"call: %@", NSStringFromSelector(_cmd));
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
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
            textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, defaultHeight)];
            textView.isScrollable = NO;
            textView.minNumberOfLines = 1;
            textView.maxNumberOfLines = 100;
            textView.returnKeyType = UIReturnKeySend;
            textView.font = [UIFont systemFontOfSize:13];
            textView.layer.cornerRadius =5.0;
            textView.layer.masksToBounds = YES;
            textView.delegate = self;
            [cell.contentView addSubview:textView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //   [textView becomeFirstResponder];
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
            [loadImageButton setImage:[UIImage imageNamed:@"sharemoreAdd"] forState:UIControlStateNormal];
    
            [loadImageButton addTarget:self action:@selector(loadPicture) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:loadImageButton];
        }
        [loadImageButton setFrame:[[self.positonsArray objectAtIndex:count] CGRectValue]];
        
        [self removeImageViewsFromCell:cell];
        
        for (int i  = 0; i < count; i++) {
            UIImageView* imageView = [[UIImageView alloc] initWithImage:[imagesArray objectAtIndex:i]];
            [imageView setFrame:[[self.positonsArray objectAtIndex:i] CGRectValue]];
            NSLog(@"image = %@", [imagesArray objectAtIndex:i]);
            [cell.contentView addSubview:imageView];
        }

        return  cell;
    }
    // Configure the cell...
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    return cell;
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
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if (0 == buttonIndex) //拍照
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        else
            NSLog(@"模拟器无法打开相机!");
    }
    else
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
    
    NSLog(@"%@", [mediaInfoArray objectForKey:@"UIImagePickerControllerReferenceURL"]);
    [imagesArray addObject:[[mediaInfoArray objectForKey:@"UIImagePickerControllerOriginalImage"] copy]];
    
    [self.tableView reloadData];
    NSLog(@"Selected %d photos", imagesArray.count);
}

#pragma mark UITableView DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row     = [indexPath row];
    int section = [indexPath section];
    if (0 == section && 0 == row) {
        return defaultHeight;
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
    if (height > defaultHeight)
    {
        defaultHeight = height;
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
@end
