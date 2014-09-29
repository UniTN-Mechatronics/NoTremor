//
//  MXConfigController.h
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Addons/MXStylusAddon.h"
#import "MXDocumentsList.h"

@interface MXConfigController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableArray *logFiles;
@property (strong, nonatomic) NSMutableArray *movieFiles;
@property (strong, nonatomic) MXDocumentsList *documents;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UILabel *fileDescription;
@end
