//
//  MXCodeaViewController.m
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import "MXCodeaViewController.h"
#import "AppDelegate.h"

@interface MXCodeaViewController ()
- (IBAction)connectStylus:(id)sender;

@end

@implementation MXCodeaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  //[self.stylusAddon searchStylus:self];
  //do something like background color, title, etc you self
  // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSLog(@"segue");
  //[[appDelegate stylusAddon] searchStylus:self];
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
}

- (IBAction)connectStylus:(id)sender {
  [[appDelegate stylusAddon] searchStylus:self];
}
@end
