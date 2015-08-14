//
//  ClientViewController.m
//  LawyerV2
//
//  Created by Administrator on 8/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "PostClientViewController.h"

@interface PostClientViewController ()

@end

@implementation PostClientViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Notify the previouse view to save the changes locally
    [[NSNotificationCenter defaultCenter] postNotificationName:@"New Note" object:self userInfo:[NSDictionary dictionaryWithObject:self.noteTextField.text forKey:@"Note"]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
