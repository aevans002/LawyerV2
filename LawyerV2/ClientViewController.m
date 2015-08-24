//
//  PreClientViewController.m
//  LawyerV2
//
//  Created by Administrator on 8/9/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "ClientViewController.h"
#import "SRWebSocket.h"
@interface ClientViewController () <SRWebSocketDelegate>

@end

@implementation ClientViewController
@synthesize notes;

NSInputStream *inputStreamO;
NSOutputStream *outputStreamO;
bool isOpen = NO;


SRWebSocket *_webSocket;

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
    /*CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"http://www.regisscis.net", 8080, &readStream, &writeStream);
    inputStreamO = (__bridge NSInputStream *)readStream;
    outputStreamO = (__bridge NSOutputStream *)writeStream;
    
    [inputStreamO setDelegate:self];
    [outputStreamO setDelegate:self];
    [inputStreamO scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStreamO scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStreamO open];
    [outputStreamO open];*/
    
    if (isOpen == NO) {
        [self createConnection];
    } else if (isOpen == YES) {
        [self disconnect];
    }
    
    
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
    [_webSocket class];
    _webSocket = nil;
    isOpen = NO;
    
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

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"WebSocket connected");
    self.title = @"Connected";
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket failed with error %@", error);
    self.title = @"Connection failed";
    _webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Recieved msg: %@", message);
}

-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.title = @"Connection Closed";
    _webSocket = nil;
}

-(void) createConnection {
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://echo.websocket.org"]]];
    _webSocket.delegate = self;
    
    self.title = @"Opening socket connection...";
    [_webSocket open];
    isOpen = TRUE;
    
}

-(void)sendMessage:(NSString*)message {
    [_webSocket send:message];
}


/*(void) tableView:(UITableView *)tableView commitEndingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[NSUbiquitousKeyValueStore defaultStore] setArray:self.notes forKey:@"AVAILABLE_NOTES"];
    }
}*/
@end
