//
//  PublishBuyViewController.m
//  MicroSpeaker
//
//  Created by wy on 14-1-11.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "PublishBuyViewController.h"

#define TextViewDefaultHeight 44*3

@interface PublishBuyViewController ()<StringInputTableViewCellDelegate, HPGrowingTextViewDelegate, SimplePickerInputTableViewCellDelegate, UIGestureRecognizerDelegate>
{
    HPGrowingTextView* descriptionTextView;
    NSArray* commerceTypesArray;
    NSMutableArray* commerceTypesName;
    NSString* selectCommerceType; //商品类型,整数字符串
    
    int selectAreaID; //推送的社区
    NSString* selectAreaName;
    NSMutableArray* areaNamesArray;
    
    UITextField* priceTextField;
    NSString* telNumber;
    NSString* themeStr;
}

@end

@implementation PublishBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (!self)
        return nil;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"求购物品";
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(publishBuyMessage)];
    self.navigationItem.rightBarButtonItem = rightButton;
    commerceTypesArray = [NSMutableArray array];
    commerceTypesName  = [NSMutableArray array];
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        commerceTypesArray = [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getCommerceType]];
        for (CommerceTypeModel* element in commerceTypesArray) {
            [commerceTypesName addObject:element.TypeName];
        }
        
        for (AreaModel* element in [NSArray arrayWithArray:[[NetWorkConnection sharedInstance] getArea]]) {
            [areaNamesArray addObject:[NSString stringWithFormat:@"%@,%@", element.AreaName, element.City]];
        }
    });
    UITapGestureRecognizer* oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTap)];
    oneTap.delegate = self;
    oneTap.numberOfTouchesRequired = 1;
    oneTap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:oneTap];  //通过鼠标手势来实现键盘的隐藏
}
#pragma mark - UIGestureRecognizerDelegate method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}
-(void)backGroundTap {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        return TextViewDefaultHeight;
    }
    else{
        return 44;
    }
}
#pragma mark UITableView delegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    if (0 == row) {
        static NSString* CellIdentifier = @"ThemeCellIdentifier";
        StringInputTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.placeholder = @"输入物品名称";
        cell.textField.textColor = [UIColor blueColor];
        cell.textField.textAlignment = NSTextAlignmentLeft;
        return cell;
    }
    else if(1 == row){
        static NSString* CellIdentifier = @"DescriptionCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            descriptionTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, TextViewDefaultHeight)];
            descriptionTextView.isScrollable = YES;
            descriptionTextView.minNumberOfLines = 1;
            descriptionTextView.maxNumberOfLines = 4;
            descriptionTextView.returnKeyType = UIReturnKeySend;
            descriptionTextView.font = [UIFont systemFontOfSize:16];
            descriptionTextView.delegate = self;
            descriptionTextView.placeholder = @"请输入物品描述";
            descriptionTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:descriptionTextView];
        }
        return cell;
    }
    else if(2 == row){
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
    else if (3 == row){
        static NSString* CellIdentifier = @"PriceCellIdentifier";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 12, 200, 44)];
            priceTextField.textAlignment = NSTextAlignmentRight;
            priceTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.contentView addSubview:priceTextField];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 44)];
            label.font = [UIFont systemFontOfSize:18];
            [label setText:@"左右"];
            [cell.contentView addSubview:label];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"价  格:";
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        priceTextField.placeholder = @"数字填写，不能为0和负数";
        return cell;
    }
    else if(4 == row){
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    return cell;
}

#pragma mark - StringInputTableViewCellDelegate
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    int selcetRow = [indexPath row];
    NSLog(@"value = %@", value);
    if (4 == selcetRow) {
        telNumber = value;
    }
    else if (0 == selcetRow){
        themeStr = value;
    }
}
#pragma mark - SimplePickerInputTableViewCellDelegate
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    int selcetRow = [indexPath row];
    if (2 == selcetRow) {
        selectCommerceType = [NSString stringWithFormat:@"%d", [commerceTypesName indexOfObject:value]];;
    }
    
}
-(void)publishBuyMessage{
    [self.view endEditing:YES]; //使键盘hidden，不然有bug，telNumStr可能为空
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:SELF_USERINFO];
    UserInfoModel* selfUserInfo = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    [[NetWorkConnection sharedInstance] publishMessage:3
                                              fromTime:nil
                                                toTime:nil
                                                 theme:themeStr
                                       activityAddress:nil
                                                   tel:telNumber
                                                  price:priceTextField.text
                                           commerceType:selectCommerceType
                                                  text:descriptionTextView.text
                                                areaID:selfUserInfo.Area.AreaID
                                                   lat:0.0
                                                  long:0.0
                                               address:@"淞虹路"
                                   locationDescription:@"天山西路"
                                                  city:selfUserInfo.City
                                              province:selfUserInfo.Province
                                               country:nil
                                                   url:nil
                                               pushNum:50];
    //通知父视图获取最新数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"publishMessageSuccess" object:self userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES ];
    
}
@end
