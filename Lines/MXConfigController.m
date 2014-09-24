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
@property NSArray *sectionTitles;
@property NSString *documentsDir;
@end

@implementation MXConfigController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  _sectionTitles = @[@"Log files", @"Videos"];

  self.documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *allItems = [manager contentsOfDirectoryAtPath:self.documentsDir error:nil];
  NSPredicate * fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.txt'"];
  if (!self.logFiles) {
    self.logFiles = [[NSMutableArray alloc] initWithArray:[allItems filteredArrayUsingPredicate:fltr]];
  }
  fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp4'"];
  if (!self.movieFiles) {
    self.movieFiles = [[NSMutableArray alloc] initWithArray:[allItems filteredArrayUsingPredicate:fltr]];
  }
  [self.tableView reloadData];
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


#pragma mark - UITableView dataSource

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//  return _sectionTitles;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return _sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return self.sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger r = 0;
  switch (section) {
    case 0:
      r = _logFiles.count;
      break;
    case 1:
      r = _movieFiles.count;
      break;
    default:
      break;
  }
  return r;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  switch (indexPath.section) {
    case 0:
      [[cell textLabel] setText:_logFiles[indexPath.row]];
      break;
    case 1:
      [[cell textLabel] setText:_movieFiles[indexPath.row]];
      break;
    default:
      break;
  }
  return cell;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    NSString *fileName = [self.documentsDir stringByAppendingPathComponent:_logFiles[indexPath.row]];
    NSLog(@"opening %@", fileName);
    self.textView.text = [NSString stringWithContentsOfFile:fileName
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
  }
  else {
    self.textView.text = @"Currently unsuported";
  }
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:NO];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSLog(@"deleting %@", indexPath);
  }
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                          title:@"Delete"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                          if (indexPath.section == 0) {
                                                                            NSString *fileName = [self.documentsDir stringByAppendingPathComponent:_logFiles[indexPath.row]];
                                                                            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
                                                                            [self.logFiles removeObjectAtIndex:indexPath.row];
                                                                          }
                                                                          else if (indexPath.section == 1) {
                                                                            NSString *fileName = [self.documentsDir stringByAppendingPathComponent:_movieFiles[indexPath.row]];
                                                                            [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
                                                                            [self.movieFiles removeObjectAtIndex:indexPath.row];
                                                                          }
                                                                          [tableView reloadData];
                                                                        }];
  
//  UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                         title:@"Share"
//                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//                                                                         NSString *fileName = [self.documentsDir stringByAppendingPathComponent:_logFiles[indexPath.row]];
//                                                                         UIDocumentInteractionController* docController = [[UIDocumentInteractionController alloc] init];
//                                                                         docController.name = fileName;
//                                                                         [docController presentPreviewAnimated:YES];
//                                                                       }];
  return @[deleteAction];
}


@end
