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
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"New Note" object:self userInfo:[NSDictionary dictionaryWithObject:self.noteTextField.text forKey:@"Note"]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*(void) tableView:(UITableView *)tableView commitEndingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [[NSUbiquitousKeyValueStore defaultStore] setArray:self.notes forKey:@"AVAILABLE_NOTES"];
    }
}*/
@end
