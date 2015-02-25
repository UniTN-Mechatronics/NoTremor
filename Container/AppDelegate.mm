//
//  AppDelegate.mm
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  _navController = (UINavigationController *)self.window.rootViewController;
  _codeaController =
      (MXCodeaViewController *)(_navController.topViewController);
  _stylusAddon = [[MXStylusAddon alloc] init];
  _codeaController.stylusAddon = _stylusAddon;
  NSString *projectName =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CodeaFolder"];
  NSLog(@"Loading Codea project %@", projectName);
  NSString *projectPath = [[[NSBundle mainBundle] bundlePath]
      stringByAppendingPathComponent:projectName];
  NSLog(@"Project path: %@", projectPath);
  //  self.codeaController = [[MXCodeaViewController alloc]
  //  initWithProjectAtPath:projectPath];
  [self.codeaController loadProjectAtPath:projectPath];
  [self.codeaController registerAddon:_stylusAddon];
  [self.codeaController restart];
  _codeaController.title = [projectName componentsSeparatedByString:@"."][0];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  [_stylusAddon stopSearchStylus:self];
  if (_stylusAddon.stylus)
    [[WacomManager getManager] deselectDevice:_stylusAddon.stylus];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  //[_stylusAddon searchStylus:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  if (_stylusAddon.stylus)
    [[WacomManager getManager] reconnectToStoredDevices];
  //    [[WacomManager getManager] selectDevice:_stylusAddon.stylus];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  if (_stylusAddon.stylus)
    [[WacomManager getManager] deselectDevice:_stylusAddon.stylus];
}

@end
