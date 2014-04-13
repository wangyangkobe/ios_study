//
//  MessageViewController.h
//  
//
//  Created by wy on 14-4-6.
//
//

#import <UIKit/UIKit.h>
#import "LogInViewController.h"
@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)changeTableView:(id)sender;
@end
