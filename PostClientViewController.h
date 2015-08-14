//
//  ClientViewController.h
//  LawyerV2
//
//  Created by Administrator on 8/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostClientViewController : UITableViewController
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@end
