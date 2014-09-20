//
//  MXConfigController.m
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "MXConfigController.h"
#import "AppDelegate.h"

@interface MXConfigController ()
@property (weak, nonatomic) IBOutlet UITableView *stylusTable;

@end

@implementation MXConfigController

- (void)viewDidLoad {
  [super viewDidLoad];
  [_stylusTable setDataSource:[appDelegate stylusAddon]];
  [appDelegate stylusAddon].stylusTable = _stylusTable;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [[appDelegate stylusAddon] stopSearchStylus:self];
}


@end
