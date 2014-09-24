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


@implementation MXStylusAddon

- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"Initializing MXStylusAddon %lu", (unsigned long)self.hash);
    [[WacomManager getManager] registerForNotifications:self];
  }
  mxAddonInstance = self;
  return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
  NSLog(@"MXStylusAddon Registering Functions");
  lua_pushboolean(L, YES);
  lua_setglobal(L, "STYLUS_ADDON");
  lua_register(L, "mxTest", mxTest);
  lua_register(L, "stylusPressure", lua_stylusPressure);
  lua_register(L, "normalizedStylusPressure", lua_normalizedStylusPressure);
  lua_register(L, "isStylusConnected", lua_isStylusConnected);
}

- (void) codea:(CodeaViewController*)controller willCloseLuaState:(struct lua_State*)L
{
  NSLog(@"MXStylusAddon resetting Lua");
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
- (void) stylusEvent:(WacomStylusEvent *)stylusEvent
{
  self.pressure = stylusEvent.getPressure;
}

- (void) deviceDiscovered:(WacomDevice *)device
{
  NSLog(@"Found device %@", device.description);
  self.stylus = device;
  self.minPressure = [device getMinimumPressure];
  self.maxPressure = [device getMaximumPressure];
  [[WacomManager getManager] stopDeviceDiscovery];
  [[WacomManager getManager] selectDevice:device];
  [[[appDelegate codeaController] stylusButton] setTitle:@"Stylus connected"];
  [[[appDelegate codeaController] stylusButton] setEnabled:NO];

}

- (void) discoveryStatePoweredOff
{
}


#pragma mark - Outlets
- (IBAction)searchStylus:(id)sender {
  NSLog(@"searching stylus");
  if (_stylus.isCurrentlyConnected)
    [[WacomManager getManager] deselectDevice:_stylus];
  [[WacomManager getManager] startDeviceDiscovery];
}

- (IBAction)stopSearchStylus:(id)sender
{
  NSLog(@"stop searching stylus");
  [[WacomManager getManager] stopDeviceDiscovery];
}


@end
