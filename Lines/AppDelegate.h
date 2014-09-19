//
//  AppDelegate.h
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXCodeaViewController.h"
#import "Addons/MXAddon.h"


@class CodeaViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MXCodeaViewController *viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) MXAddon *codeaAddon;

@end
