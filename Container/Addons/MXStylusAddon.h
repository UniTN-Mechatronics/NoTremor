//
//  MXAddon.h
//  CodeaGames
//
//  Created by Paolo Bosetti on 17/09/14.
//  Copyright (c) 2014 UniTN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WacomDevice/WacomDeviceFramework.h>
#import "CodeaAddon.h"
#define  appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

@interface MXStylusAddon : NSObject <CodeaAddon, WacomDiscoveryCallback, WacomStylusEventCallback>

@property (strong, nonatomic) WacomDevice *stylus;
@property NSInteger minPressure, maxPressure;
@property CGFloat pressure;
@property struct lua_State *lua;

- (IBAction)searchStylus:(id)sender;
- (IBAction)stopSearchStylus:(id)sender;

static int mxTest(struct lua_State *state);
static int stylusPressure(struct lua_State *state);
static int normalizedStylusPressure(struct lua_State *state);
static int isStylusConnected(struct lua_State *state);

@end
