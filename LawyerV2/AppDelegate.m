//
//  AppDelegate.m
//  LawyerV2
//
//  Created by Administrator on 7/5/15.
//  Copyright (c) 2015 Student. All rights reserved.
//

#import "AppDelegate.h"
#import "Program.h"
#import "RestKit.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *))completionHandler {
    //Instantiate
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //Int Session Object
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    //Create a data task object to perform the data
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            //IF any error occurs
            NSLog(@"%@", [error localizedDescription]);
        } else {
            // If not errors
            NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
            
            //If its other that 200
            if (HTTPStatusCode != 200) {
                NSLog(@"HTTP status code = %ld", (long)HTTPStatusCode);
            }
            
            //Call the completion handler
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                completionHandler(data);
            }];
        }
    }];
    // Resume Tast
    [task resume];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeRestKit];
    return YES;
}

- (void)initializeRestKit {
    //tracing
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    //init object manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://regisscis.net/Regis2/webresources/regis2.program"]];
    [manager setRequestSerializationMIMEType:RKMIMETypeXML];
    [manager setAcceptHeaderWithMIMEType:@"application/xml"];
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"regis2.program" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) { NSLog(@"I worked!"); } failure:^(RKObjectRequestOperation *operation, NSError *error) { NSLog(@"It failed"); }];
    
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    manager.managedObjectStore = managedObjectStore;
    
    RKEntityMapping *programMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Program class]) inManagedObjectStore:manager.managedObjectStore];
    programMapping.identificationAttributes = @[@"id"];
    [programMapping addAttributeMappingsFromDictionary:@{@"name" : @"name"}];
    
    //create the persistence store
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"SCIS.sqlite"];
    NSLog(@"Database created");
    NSError *error;
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error];
    NSAssert(persistentStore, @"Failed persisten store: %@", error);
    [managedObjectStore createManagedObjectContexts];
    
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
