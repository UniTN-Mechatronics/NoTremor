//
//  MXCodeaViewController.h
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "CodeaViewController.h"
#import "MXConfigController.h"
#import "Addons/MXStylusAddon.h"

@interface MXCodeaViewController : CodeaViewController
@property (strong, nonatomic) IBOutlet MXStylusAddon *stylusAddon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stylusButton;

@end
