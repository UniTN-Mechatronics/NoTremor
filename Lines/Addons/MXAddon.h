//
//  MXAddon.h
//  CodeaGames
//
//  Created by Paolo Bosetti on 17/09/14.
//  Copyright (c) 2014 UniTN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CodeaAddon.h"

@interface MXAddon : NSObject<CodeaAddon>
@property long value;
static int mxTest(struct lua_State *state);
static int stylusPressure(struct lua_State *state);

@end
