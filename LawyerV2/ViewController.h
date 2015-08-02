//
//  ViewController.h
//  LawyerV2
//
//  Created by Administrator on 7/5/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)exitView:(UIStoryboardSegue *)sender;

@property (weak, nonatomic) IBOutlet UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UIButton *twitButton;

- (IBAction)openFace:(id)sender;
- (IBAction)openTwit:(id)sender;

@end

