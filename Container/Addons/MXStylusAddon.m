//
//  MXAddon.mm
//  CodeaGames
//
//  Created by Paolo Bosetti on 17/09/14.
//  Copyright (c) 2014 UniTN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXStylusAddon.h"
#import "lua.h"
#import "AppDelegate.h"

static MXStylusAddon *mxAddonInstance;

@interface MXStylusAddon ()
@property BOOL luaReceiveEnabled;
@end

@implementation MXStylusAddon

- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"Initializing MXStylusAddon %lu", (unsigned long)self.hash);
    [[WacomManager getManager] registerForNotifications:self];
  }
  mxAddonInstance = self;
  _lua = nil;
  return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
  _lua = L;
  NSLog(@"MXStylusAddon Registering Functions");
  lua_pushboolean(L, YES);
  lua_setglobal(L, "STYLUS_ADDON");
  lua_register(L, "mxTest", mxTest);
  lua_register(L, "stylusPressure", lua_stylusPressure);
  lua_register(L, "normalizedStylusPressure", lua_normalizedStylusPressure);
  lua_register(L, "isStylusConnected", lua_isStylusConnected);
  self.luaReceiveEnabled = YES;
}

- (void) codea:(CodeaViewController*)controller willCloseLuaState:(struct lua_State*)L
{
  NSLog(@"MXStylusAddon resetting Lua");
  _lua = nil;
  self.luaReceiveEnabled = NO;
}

- (void) codeaWillDrawFrame:(CodeaViewController *)controller withDelta:(CGFloat)deltaTime
{
  if (!self.luaReceiveEnabled) {
    return;
  }
  BOOL hideNavbar = NO;
  if (_lua && lua_gettop(_lua) == 0) {
    lua_getglobal(_lua, "hideNavbar");
    if (!lua_isnil(_lua, -1))
      hideNavbar = lua_toboolean(_lua, 1);
    lua_pop(_lua, 1);
  }
  if ([[appDelegate navController] navigationBar].hidden != hideNavbar)
      [[appDelegate navController] setNavigationBarHidden:hideNavbar animated:YES];
}

- (BOOL)isStylusConnected
{
  return [_stylus isCurrentlyConnected];
}

- (GLfloat) normalizedPressure
{
  GLfloat v = (_pressure - _minPressure) / (_maxPressure - _minPressure);
  return v;
}

#pragma mark - Lua functions

static int mxTest(struct lua_State *state)
{
  NSLog(@"mxTest called");
  lua_pushfstring(state, "example string");
  return 1;
}

static int lua_stylusPressure(struct lua_State *state)
{
  if ([mxAddonInstance isStylusConnected])
    lua_pushinteger(state, (lua_Integer)mxAddonInstance.pressure);
  else
    lua_pushinteger(state, (lua_Integer)0);
  return 1;
}

static int lua_normalizedStylusPressure(struct lua_State *state)
{
  lua_Number v;
  if ([mxAddonInstance isStylusConnected]) {
    v = (lua_Number)[mxAddonInstance normalizedPressure];
    lua_pushnumber(state, v);
  }
  else
    lua_pushnumber(state, (lua_Number)0);
  return 1;
}

static int lua_isStylusConnected(struct lua_State *state)
{
  lua_pushboolean(state, [mxAddonInstance isStylusConnected]);
  return 1;
}


#pragma mark - Wacom

- (void) discoveryStatePoweredOff
{
  
}

- (void) stylusEvent:(WacomStylusEvent *)stylusEvent
{
  self.pressure = stylusEvent.getPressure;
//  TouchManager *tm = [[WacomManager getManager] currentlyTrackedTouches];
//  NSLog(@"r=%f", tm.theStylusTouch.associatedTouch.majorRadius);
}

- (void) deviceDiscovered:(WacomDevice *)device
{
  NSLog(@"Found device %@", device.description);
  self.stylus = device;
  self.minPressure = [device getMinimumPressure];
  self.maxPressure = [device getMaximumPressure];
  [[WacomManager getManager] selectDevice:device];
  [self stopSearchStylus:self];
  [[[appDelegate codeaController] stylusButton] setTitle:@"Found Stylus"];
  [[[appDelegate codeaController] stylusButton] setEnabled:NO];

}

- (void) deviceConnected:(WacomDevice *)device
{
  [[[appDelegate codeaController] stylusButton] setTitle:@"Stylus Connected"];
}

- (void) deviceDisconnected:(WacomDevice *)device
{
  [[[appDelegate codeaController] stylusButton] setEnabled:YES];
  [[[appDelegate codeaController] stylusButton] setTitle:@"Connect Stylus"];
}


#pragma mark - Outlets
- (IBAction)searchStylus:(id)sender {
  if ([[WacomManager getManager] isDiscoveryInProgress]) {
    [self stopSearchStylus:self];
    [[[appDelegate codeaController] stylusButton] setTitle:@"Connect Stylus"];
  }
  else {
    NSLog(@"searching stylus");
    if (_stylus.isCurrentlyConnected)
      [[WacomManager getManager] deselectDevice:_stylus];
    
    [[[appDelegate codeaController] stylusButton] setTitle:@"Searching Stylus"];
    [[WacomManager getManager] startDeviceDiscovery];
  }
}

- (IBAction)stopSearchStylus:(id)sender
{
  NSLog(@"stop searching stylus");
  [[WacomManager getManager]  stopDeviceDiscovery];
}


@end
