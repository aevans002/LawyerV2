//
//  SCISProgamsTableViewController.m
//  LawyerV2
//
//  Created by Administrator on 7/11/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "SCISProgamsTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "RestKit.h"
#import "Program.h"

#define kCLIENTID @"Your ID"
#define kCLIENTNAME @"Your Name"


@interface SCISProgamsTableViewController ()

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableDictionary *dictTempData; //current section
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;
@property (nonatomic, strong) NSMutableDictionary *xmlWeather; //completed parse


@end

@implementation SCISProgamsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;
NSMutableData *_responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Using xmlAfn for AFNetworking
    //[self downloadData];
    //[self xmlAfn];
}

- (NSFetchedResultsController *)fetchedResultsController{
    if (!_fetchedResultsController) {
        NSLog(@"Fetched Stuff");
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Program class])];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"program.name" ascending:YES]];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext sectionNameKeyPath:@"program.name" cacheName:@"Program"];
        self.fetchedResultsController.delegate = self;
        
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        NSLog(@"%@",[self.fetchedResultsController fetchedObjects]);
        NSAssert(!error, @"Error performing fetch request: %@", error);
        
    }
    return _fetchedResultsController;
}

/*-(void)configureRestKit {
    //init AFNet
    NSURL *baseURL = [NSURL URLWithString:@"http://regisscis.net/Regis2/webresources/regis2.program"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    //init restkit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    //setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Program class]];
    [venueMapping addAttributeMappingsFromArray:@[@"id"]];
    //register mappings
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:venueMapping method:RKRequestMethodGET pathPattern:@"program" keyPath:@"program.name" statusCodes:[NSIndexSet indexSetWithIndex:200]];
                                                [objectManager addResponseDescriptor:responseDescriptor];
}

-(void) loadPrograms {
    NSString *clientID = kCLIENTID;
    NSString *clientName = kCLIENTNAME;
    
    NSDictionary *queryParams = @{@"client_id" : clientID,
                                  @"client_name" : clientName};
    
    
}*/

-(void)xmlAfn {
 /*   NSString *string = [NSString stringWithFormat:@"http://regisscis.net/Regis2/webresources/regis2.program"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //Make sure to set response
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseData) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseData;
        [XMLParser setShouldProcessNamespaces:YES];
        NSLog(@"Found XML");
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error retriving data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"Lost XML");
    }];

    [operation start];*/
}



-(void)downloadData{
    //Preping the URL
    NSString *URLString = [NSString stringWithFormat:@"http://regisscis.net/Regis2/webresources/regis2.program"];
    NSURL *url = [NSURL URLWithString:URLString];
    //Dowload
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
       //Make sure there is data
        if(data != nil) {
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            //Initialize the mutable string
            self.foundValue = [[NSMutableString alloc] init];
            //Start parsing
            [self.xmlParser parse];
        }
    }];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    //Initialize array
    NSLog(@"Make Contact");
   // self.arrData = [[NSMutableArray alloc] init];
    self.xmlWeather = [NSMutableDictionary dictionary];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    //Reload the table view
    NSLog(@"Make Contact");
    [self.tableView reloadData];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //If current element is same as selected element
   /* if ([elementName isEqualToString:@"program"]) {
        self.dictTempData = [[NSMutableDictionary alloc] init];
    }*/
    //Keep same element
    self.currentElement = elementName;
    
    if ([qName isEqual:@"program"]) {
        self.dictTempData = [NSMutableDictionary dictionary];
    }
    self.foundValue = [NSMutableString string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {  //Edited out code from previous week
    /*if ([elementName isEqualToString:@"program"]) {
        //If closing element equals string
        [self.arrData addObject:[[NSDictionary alloc] initWithDictionary:self.dictTempData]];
    } else if ([elementName isEqualToString:@"id"]) {
        [self.dictTempData setObject:[NSString stringWithString:self.foundValue] forKey:@"id"];
    } else if ([elementName isEqualToString:@"name"]) {
        [self.dictTempData setObject:[NSString stringWithString:self.foundValue] forKey:@"name"];
    } else {
        NSLog(@"%@", elementName);
    }
    
    //Clear info
    [self.foundValue setString:@""];*/
    
    //1
    if ([qName isEqualToString:@"current_condition"] || [qName isEqualToString:@"request"]) {
        self.xmlWeather[qName] = @[self.dictTempData];
        self.dictTempData = nil;
    }
    //2
    else if ([qName isEqualToString:@"program"]) {
        NSMutableArray *array = self.xmlWeather[@"program"] ?: [NSMutableArray array];
        
        [array addObject:self.dictTempData];
        
        self.xmlWeather[@"program"] = array;
        
        self.dictTempData = nil;
    }
    //3
    else if ([qName isEqualToString:@"id"] || [qName isEqualToString:@"name"]) {
    [self.dictTempData setObject:[NSString stringWithString:self.foundValue] forKey:@"id"];
        NSDictionary *dictionary = @{@"value": self.foundValue};
        NSArray *array = @[dictionary];
        self.dictTempData[qName] = array;
        //Able to see parsed data but haven't found proper way to display on Table
        NSLog(@"%@", _foundValue);
    }
    //4
    else if (qName) {
        self.dictTempData[qName] = self.foundValue;
    }
    self.currentElement = nil;
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Store found characters
    if (!self.currentElement)
        return;
    if ([self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"id"]) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
    
    
    [self.foundValue appendFormat:@"%@", string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [[self.arrData objectAtIndex:indexPath.row] objectForKey:@"id"];
    cell.detailTextLabel.text = [[self.arrData objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //TODO
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
}


@end
