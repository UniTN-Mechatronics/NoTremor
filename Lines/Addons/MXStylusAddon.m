//
//  MXAddon.mm
//  CodeaGames
//
//  Created by Paolo Bosetti on 17/09/14.
//  Copyright (c) 2014 UniTN. All rights reserved.
//

#import "MXStylusAddon.h"
#import "lua.h"

MXStylusAddon *mxAddonInstance;


@implementation MXStylusAddon

- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"Initializing MXStylusAddon %lu", (unsigned long)self.hash);
    [[WacomManager getManager] registerForNotifications:self];
    _mDevices = [[NSMutableArray alloc] init];
    _value = 0;
  }
  mxAddonInstance = self;
  return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
  NSLog(@"MXStylusAddon Registering Functions");
  lua_register(L, "mxTest", mxTest);
  lua_register(L, "stylusPressure", stylusPressure);
}

- (void) codea:(CodeaViewController*)controller willCloseLuaState:(struct lua_State*)L
{
  NSLog(@"MXStylusAddon resetting Lua");
}


static int mxTest(struct lua_State *state)
{
  NSLog(@"mxTest called");
  lua_pushfstring(state, "example string");
  return 1;
}

static int stylusPressure(struct lua_State *state)
{
  lua_pushinteger(state, mxAddonInstance.value);
  return 1;
}

#pragma mark - Wacom
- (void) stylusEvent:(WacomStylusEvent *)stylusEvent
{
  
}

- (void) deviceDiscovered:(WacomDevice *)device
{
  NSLog(@"Found device %@", device.description);
  [self.mDevices addObject:device];
  [self.stylusTable reloadData];
  [self.stylusTable setNeedsDisplay];
}

- (void) discoveryStatePoweredOff
{
  
}

#pragma mark - UITableView dataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  WacomDevice * selectedDevice = self.mDevices[[indexPath indexAtPosition:1]];
  NSLog(@"inserting device %@", selectedDevice.description);
  [[cell textLabel] setText:[selectedDevice getName]];
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.mDevices.count;
}

#pragma mark - Outlets
- (IBAction)searchStylus:(id)sender {
  NSLog(@"searching stylus");
  [self.mDevices removeAllObjects];
  [[WacomManager getManager] startDeviceDiscovery];
}

- (IBAction)stopSearchStylus:(id)sender
{
  NSLog(@"stop searching stylus");
  [[WacomManager getManager] stopDeviceDiscovery];
}


@end
