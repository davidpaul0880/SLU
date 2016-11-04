//
//  AppDelegate.h
//  SLU
//
//  Created by David Paul on 31/10/16.
//  Copyright © 2016 JP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property CLLocationManager* locationMgr;
@property CLLocationManager* bglocationMgr;
@property UIBackgroundTaskIdentifier backgroundUpdateTask;

@end
