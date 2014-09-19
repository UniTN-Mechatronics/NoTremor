//
//  MXCodeaViewController.m
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "MXCodeaViewController.h"

@interface MXCodeaViewController ()

@end

@implementation MXCodeaViewController

- (void)viewDidLoad {
  [super viewDidLoad];
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
  _codeaAddon.value++;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)configure:(id)sender {
  NSLog(@"pinch action");
}

@end
