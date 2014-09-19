//
//  AppDelegate.mm
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _navController = (UINavigationController *)self.window.rootViewController;
  _viewController = (MXCodeaViewController*)(_navController.topViewController); //[[CodeaViewController alloc] init];
  _codeaAddon = [[MXAddon alloc] init];
  _viewController.codeaAddon = _codeaAddon;
  NSString* projectPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Lines.codea"];
  [self.viewController registerAddon:_codeaAddon];
  [self.viewController loadProjectAtPath:projectPath];
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
