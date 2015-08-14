//
//  AppDelegate.h
//  LawyerV2
//
//  Created by Administrator on 7/5/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
//Hopefully no conflicts
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong) Note *doc;
@property (strong) NSMetadataQuery *query;


-(void)loadDocument;
+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;


@end

