//
//  PreClientViewController.h
//  LawyerV2
//
//  Created by Administrator on 8/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientViewController : UIViewController <NSStreamDelegate>
@property (strong) NSString *notes;

- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
