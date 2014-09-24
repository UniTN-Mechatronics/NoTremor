//
//  AppDelegate.mm
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import "AppDelegate.h"
#ifndef LUA_SCRIPTS
  #define LUA_SCRIPTS "Lines.codea"
#else
#define SCRIPT_NAME(n) #n
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _navController = (UINavigationController *)self.window.rootViewController;
  _codeaController = (MXCodeaViewController *)(_navController.topViewController);
  _stylusAddon = [[MXStylusAddon alloc] init];
  _codeaController.stylusAddon = _stylusAddon;
  NSString* projectPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Lines.codea"];
  [self.codeaController registerAddon:_stylusAddon];
  [self.codeaController loadProjectAtPath:projectPath];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
