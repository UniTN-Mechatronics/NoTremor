//
//  MXCodeaViewController.h
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "CodeaViewController.h"
#import "Addons/MXAddon.h"

@interface MXCodeaViewController : CodeaViewController
@property (strong, nonatomic) MXAddon *codeaAddon;

- (IBAction)configure:(id)sender;

@end
