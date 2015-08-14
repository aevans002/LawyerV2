//
//  Note.m
//  LawyerV2
//
//  Created by Administrator on 8/13/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "Note.h"

@implementation Note

@synthesize noteContent;

//Called when the app reads data from system file
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([contents length] > 0) {
        self.noteContent = [[NSString alloc]
                            initWithBytes:[contents bytes] length:[contents length] encoding:NSUTF8StringEncoding];
    } else {
        //Default content
        self.noteContent = @"Empty";
    }
    return YES;
}

//Called whenever app saves
- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([self.noteContent length] == 0) {
        self.noteContent = @"Empty";
    }
    return [NSData dataWithBytes:[self.noteContent UTF8String] length:[self.noteContent length]];
}



@end
