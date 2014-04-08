//
//  MessageViewController.m
//
//
//  Created by wy on 14-4-6.
//
//

#import "MessageViewController.h"
#import "DAPagesContainer.h"
#import "PrivateMessageViewController.h"
@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* letterContacts;
}

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[UserConfig shareInstance] isLogIn] == NO)
    {
        LogInViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:loginVC];
        return;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息中心";
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    UITableViewController* privateMessageVC = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    privateMessageVC.tableView.delegate = self;
    privateMessageVC.tableView.dataSource = self;
    privateMessageVC.title = @"私信";
    
    self.pagesContainer.topBarBackgroundColor = [UIColor lightGrayColor];
    self.pagesContainer.topBarHeight =  30;
    self.pagesContainer.viewControllers = @[privateMessageVC];
    
    letterContacts = [[[NetWorkConnection sharedInstance] getLetterContacts] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [letterContacts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"PrivateMessageCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView* headPic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        headPic.layer.masksToBounds = YES; //没这句话它圆不起来
        headPic.layer.cornerRadius = 5.0;
        [headPic setTag:8000];
        [cell.contentView addSubview:headPic];
        
        UILabel* userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 200, 30)];
        [userName setTag:8001];
        [userName setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:userName];
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 200, 15)];
        [textLabel setTag:8002];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:textLabel];
        
        
        UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 45, 200, 15)];
        [timeLabel setTag:8003];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [timeLabel setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:timeLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LetterModel* element = [letterContacts objectAtIndex:indexPath.row];
    UIImageView* headPic = (UIImageView*)[cell.contentView viewWithTag:8000];
    [headPic setImageWithURL:[NSURL URLWithString:element.User.HeadPic]
            placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    
    UILabel* userName = (UILabel*)[cell.contentView viewWithTag:8001];
    [userName setText:element.User.UserName];
    
    UILabel* text = (UILabel*)[cell.contentView viewWithTag:8002];
    [text setText:element.Letter.Text];
    
    UILabel* time = (UILabel*)[cell.contentView viewWithTag:8003];
    [time setText:element.Letter.CreateAt];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    PrivateMessageViewController* privateMessageVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"PrivateMessageViewController"];
    
    LetterModel* selectedLetter = (LetterModel*)[letterContacts objectAtIndex:indexPath.row];
    privateMessageVC.otherUserID = selectedLetter.User.UserID;
    
    [privateMessageVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:privateMessageVC animated:YES];
}
@end
