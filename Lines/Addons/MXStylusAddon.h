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

@interface MXStylusAddon : NSObject <CodeaAddon, UITableViewDataSource, WacomDiscoveryCallback,WacomStylusEventCallback>

@property long value;
@property (strong, nonatomic) NSMutableArray *mDevices;
@property (strong, nonatomic) WacomDevice *currentStylus;

@property (weak, nonatomic) IBOutlet UITableView *stylusTable;
- (IBAction)searchStylus:(id)sender;
- (IBAction)stopSearchStylus:(id)sender;

static int mxTest(struct lua_State *state);
static int stylusPressure(struct lua_State *state);

@end
