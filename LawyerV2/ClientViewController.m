//
//  PreClientViewController.m
//  LawyerV2
//
//  Created by Administrator on 8/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "ClientViewController.h"

@interface ClientViewController ()

@end

@implementation ClientViewController
@synthesize notes;

NSInputStream *inputStreamO;
NSOutputStream *outputStreamO;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeDidChange:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:store];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddNewNote:) name:@"New Note" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didAddNewNote:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *noteStr = [userInfo valueForKey:@"Note"];
  //  [self.notes addObject:noteStr];
    
    //Update data
    [[NSUbiquitousKeyValueStore defaultStore] setArray:self.notes forKey:@"AVAILABLE_NOTES"];
    
    //Reload
    [self.tableView reloadData];
}


- (IBAction)save:(id)sender {
    //Notify the previous view to save changes locally
   /* [[NSNotificationCenter defaultCenter]
     postNotificationName:@"New Note" object:self userInfo:[NSDictionary dictionaryWithObject:self.noteTextField.text forKey:@"Note"]];
    [self dismissViewControllerAnimated:YES completion:nil];*/
    
    
    //Added some code to connect to regis
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"http://www.regisscis.net", 8080, &readStream, &writeStream);
    inputStreamO = (__bridge NSInputStream *)readStream;
    outputStreamO = (__bridge NSOutputStream *)writeStream;
    
    [inputStreamO setDelegate:self];
    [outputStreamO setDelegate:self];
    [inputStreamO scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStreamO scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStreamO open];
    [outputStreamO open];
}

- (void) send:(NSString *)msg {
    
    NSData *data = [[NSData alloc] initWithData:[msg dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStreamO write:[data bytes] maxLength:[data length]];
    
}

- (void) disconnect {
    
    [inputStreamO close];
    [outputStreamO close];
    [inputStreamO removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStreamO removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStreamO setDelegate:nil];
    [outputStreamO setDelegate:nil];
    inputStreamO = nil;
    outputStreamO = nil;
    
}

- (NSString *) retrieve {
    NSString *msg;
    
    uint8_t buffer[1024];
    int len = 0;
    while ([inputStreamO hasBytesAvailable]) {
        len = [inputStreamO read:buffer maxLength:sizeof(buffer)];
        if (len>0) {
            NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
            if (outputStreamO != nil) {
                return msg;
            }
        }
    }
    return msg;
}


/*(void) tableView:(UITableView *)tableView commitEndingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[NSUbiquitousKeyValueStore defaultStore] setArray:self.notes forKey:@"AVAILABLE_NOTES"];
    }
}*/
@end
