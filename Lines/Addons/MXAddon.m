//
//  MXAddon.mm
//  CodeaGames
//
//  Created by Paolo Bosetti on 17/09/14.
//  Copyright (c) 2014 UniTN. All rights reserved.
//

#import "MXAddon.h"
#import "lua.h"

MXAddon *mxAddonInstance;


@implementation MXAddon

- (id)init
{
  self = [super init];
  if (self) {
    NSLog(@"Initializing MXAddon");
    _value = 0;
  }
  mxAddonInstance = self;
  return self;
}

- (void) codea:(CodeaViewController*)controller didCreateLuaState:(struct lua_State*)L
{
  NSLog(@"MXAddon Registering Functions");
  lua_register(L, "mxTest", mxTest);
  lua_register(L, "stylusPressure", stylusPressure);
}

- (void) codea:(CodeaViewController*)controller willCloseLuaState:(struct lua_State*)L
{
  NSLog(@"MXAddon resetting Lua");
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

@end
