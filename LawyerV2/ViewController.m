//
//  ViewController.m
//  LawyerV2
//
//  Created by Administrator on 7/5/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitView:(UIStoryboardSegue *)sender {
    
}



- (IBAction)openFace:(id)sender {
    SLComposeViewController *view = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [self presentViewController:view animated:YES completion:nil];
    
}

- (IBAction)openTwit:(id)sender {
    SLComposeViewController *view = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:view animated:YES completion:nil];
}
@end
