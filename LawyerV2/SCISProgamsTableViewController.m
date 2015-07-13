//
//  SCISProgamsTableViewController.m
//  LawyerV2
//
//  Created by Administrator on 7/11/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "SCISProgamsTableViewController.h"
#import "AppDelegate.h"

@interface SCISProgamsTableViewController ()

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSMutableDictionary *dictTempData;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;

@end

@implementation SCISProgamsTableViewController

NSMutableData *_responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* NSError *error  = nil;
    NSURL *url = [NSURL URLWithString:@"http://regisscis.net/Regis2/webresources/regis2.program"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil) {
        //Parsing
        NSLog(@"Connected");
    } else {
        NSLog(@"Error: %@", error);
    }*/
    
    [self downloadData];
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
    self.arrData = [[NSMutableArray alloc] init];
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
    if ([elementName isEqualToString:@"program"]) {
        self.dictTempData = [[NSMutableDictionary alloc] init];
    }
    //Keep same element
    self.currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"program"]) {
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
    [self.foundValue setString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Store found characters
    if ([self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"id"]) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
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
