//
//  AppDelegate.h
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXCodeaViewController.h"
#import "MXConfigController.h"
#import "Addons/MXStylusAddon.h"
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@class CodeaViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) UINavigationController *navController;
@property(strong, nonatomic) MXCodeaViewController *codeaController;
@property(strong, nonatomic) UIViewController *configController;
@property(strong, nonatomic) MXStylusAddon *stylusAddon;

@end
