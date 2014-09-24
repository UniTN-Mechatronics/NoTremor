//
//  MXConfigController.m
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MXConfigController.h"
#import "AppDelegate.h"

typedef enum 
{
  sectionLogs = 0,
  sectionMovies
} tableSections;

@interface MXConfigController ()
@property NSArray *sectionTitles;
@property NSString *documentsDir;
@property (strong, atomic) UIDocumentInteractionController* docController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
- (IBAction)shareFile:(id)sender;
@end

@implementation MXConfigController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  _sectionTitles = @[@"Log files", @"Videos"];
  self.docController = [[UIDocumentInteractionController alloc] init];
  [self.docController setDelegate:self];
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
    case sectionLogs:
      r = _logFiles.count;
      break;
    case sectionMovies:
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
  [[cell textLabel] setText:[self fileNameForIndexPath:indexPath]];
  return cell;
}

- (NSString *)fileNameForIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case sectionLogs:
      return _logFiles[indexPath.row];
      break;
    case sectionMovies:
      return _movieFiles[indexPath.row];
      break;
    default:
      break;
  }
  return @"Undefined";
}

- (NSString *)filePathForIndexPath:(NSIndexPath *)indexPath
{
  return [self.documentsDir stringByAppendingPathComponent:[self fileNameForIndexPath:indexPath]];
}

- (NSURL *)fileURLForIndexPath:(NSIndexPath *)indexPath
{
  return [NSURL fileURLWithPath:[self filePathForIndexPath:indexPath]];
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *filePath = [self filePathForIndexPath:indexPath];
  if (indexPath.section == sectionLogs) {
    self.textView.text = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
  }

  else if (indexPath.section == sectionMovies) {
    NSURL    *fileURL  = [NSURL fileURLWithPath:filePath];
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
    moviePlayerViewController.view.frame = self.view.bounds;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    moviePlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    moviePlayerViewController.moviePlayer.shouldAutoplay = YES;
    [moviePlayerViewController.moviePlayer prepareToPlay];
    moviePlayerViewController.moviePlayer.fullscreen=YES;
  }

  else {
    self.textView.text = @"Currently unsuported";
  }
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:NO];
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
                                                                          NSString *filePath = [self filePathForIndexPath:indexPath];
                                                                          if (indexPath.section == sectionLogs) {
                                                                            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                                                                            [self.logFiles removeObjectAtIndex:indexPath.row];
                                                                          }
                                                                          else if (indexPath.section == sectionMovies) {
                                                                            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
                                                                            [self.movieFiles removeObjectAtIndex:indexPath.row];
                                                                          }
                                                                          [tableView reloadData];
                                                                        }];
  
  UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                         title:@"Share"
                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                         NSURL *fileURL = [self fileURLForIndexPath:indexPath];
                                                                         [self.docController setURL:fileURL];
                                                                         [self.docController setDelegate:self];
                                                                         [self.docController presentOpenInMenuFromBarButtonItem:self.shareButton animated:YES];
                                                                       }];
  return @[deleteAction, shareAction];
}


#pragma mark - UIDocumentInteractionController delegate
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application
{
  
}


#pragma mark IBActions
- (IBAction)shareFile:(id)sender {
  NSURL *fileURL = [self fileURLForIndexPath:[_tableView indexPathForSelectedRow]];
  [_docController setURL:fileURL];
  [_docController presentOpenInMenuFromBarButtonItem:_shareButton animated:YES];
}
@end
