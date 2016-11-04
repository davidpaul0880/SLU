//
//  AppDelegate.m
//  SLU
//
//  Created by David Paul on 31/10/16.
//  Copyright © 2016 JP. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize locationMgr, bglocationMgr, backgroundUpdateTask;

- (void)redirectLogToDocuments
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [allPaths objectAtIndex:0];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"logFile.txt"];
    
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"app delegate received significant location change");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[UIApplication sharedApplication] applicationIconBadgeNumber]+1];
    
    [self endBackgroundUpdateTask];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //write all logs to file in Document folder
    [self redirectLogToDocuments];
    
    NSLog(@"app launched with option %@", launchOptions);
    
    
    locationMgr = [[CLLocationManager alloc] init];
    [locationMgr setDelegate:self];
    [locationMgr requestAlwaysAuthorization];
    
    [locationMgr setAllowsBackgroundLocationUpdates:YES];
    [locationMgr startMonitoringSignificantLocationChanges];
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [locationMgr stopMonitoringSignificantLocationChanges];
    [self startAnotherManager];
    
    
    NSLog(@"me on bg ....");
}


- (void) startAnotherManager
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self beginBackgroundUpdateTask];
        
        bglocationMgr = [[CLLocationManager alloc] init];
        [bglocationMgr setDelegate:self];
        bglocationMgr.activityType = CLActivityTypeFitness;
        [bglocationMgr requestAlwaysAuthorization];
        [bglocationMgr setAllowsBackgroundLocationUpdates:YES];
        [bglocationMgr startMonitoringSignificantLocationChanges];
        
        // Do something with the result
        
        
        //[self endBackgroundUpdateTask];
    });
}
- (void) beginBackgroundUpdateTask {
    
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void) endBackgroundUpdateTask {
    
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"kill me ....");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
