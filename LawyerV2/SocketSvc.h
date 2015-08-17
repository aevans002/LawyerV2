//
//  SocketSvc.h
//  LawyerV2
//
//  Created by Administrator on 8/16/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketSvc : NSObject <NSStreamDelegate>

- (void) connect;
- (void) send:(NSString *)msg;
- (void) disconnect;
- (NSString *)retrieve;

@end
