//
//  MXConfigController.m
//  Lines
//
//  Created by Paolo Bosetti on 19/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "MXConfigController.h"
#import "AppDelegate.h"

typedef enum { sectionLogs = 0, sectionMovies } tableSections;

@interface MXConfigController ()
@property(weak, nonatomic) IBOutlet UISwitch *enableChart;
@property NSArray *sectionTitles;
@property NSString *documentsDir;
@property(strong, atomic) UIDocumentInteractionController *docController;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
- (IBAction)shareFile:(id)sender;
@end

@implementation MXConfigController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  _sectionTitles = @[ @"Log files"]; //, @"Videos" ];
  self.documents = [MXDocumentsList
      documentsListAtPath:nil
                    forTypes:@[ MXLogDocument.class] //, MXMovieDocument.class ]
                    ];
  self.docController = [[UIDocumentInteractionController alloc] init];
  [self.docController setDelegate:self];
  [self.tableView reloadData];
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  self.shareButton.enabled = NO;
  self.fileDescription.text = @"No file selected.";
  self.textView.text = @"";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - UITableView dataSource

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//  return _sectionTitles;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _documents.types.count; //_sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  return [_documents.types[section] humanName];
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [_documents.list[[_documents sectionAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"documentsCell"
                                      forIndexPath:indexPath];
  [[cell textLabel]
      setText:[_documents documentAtIndexPath:indexPath].fileName];
  return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MXDocument *doc = [_documents documentAtIndexPath:indexPath];
  if ([doc isKindOfClass:MXLogDocument.class]) {
    NSString *data = [NSString stringWithContentsOfFile:doc.filePath
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    self.textView.text = data;
    self.fileDescription.text = doc.fileDescription;
    if ([self.enableChart isOn]) {
      [self.chartView reset];

      [self.chartView addSeries:@"x" withLabel:@"x pos"];
      [self.chartView.series[@"x"] addFromString:data xCol:0 yCol:3];
      [self.chartView.series[@"x"] setLineColor:[UIColor redColor]];

      [self.chartView addSeries:@"y" withLabel:@"y pos"];
      [self.chartView.series[@"y"] addFromString:self.textView.text
                                            xCol:0
                                            yCol:4];
      [self.chartView.series[@"y"] setLineColor:[UIColor greenColor]];

      [self.chartView autoRescaleOnSerie:@"y" xAxis:YES yAxis:NO];
    }
  }

  else if ([doc isKindOfClass:MXMovieDocument.class]) {
    MPMoviePlayerViewController *moviePlayerViewController =
        [[MPMoviePlayerViewController alloc] initWithContentURL:doc.fileURL];
    moviePlayerViewController.view.frame = self.view.bounds;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
    moviePlayerViewController.moviePlayer.controlStyle =
        MPMovieControlStyleFullscreen;
    moviePlayerViewController.moviePlayer.shouldAutoplay = YES;
    [moviePlayerViewController.moviePlayer prepareToPlay];
    moviePlayerViewController.moviePlayer.fullscreen = YES;
  }

  else {
    self.textView.text = @"Currently unsupported";
  }
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:NO];
  self.shareButton.enabled = YES;
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
  [[tableView cellForRowAtIndexPath:indexPath] setEditing:NO animated:NO];
  self.shareButton.enabled = NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSLog(@"deleting %@", indexPath);
  }
}

- (NSArray *)tableView:(UITableView *)tableView
    editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewRowAction *deleteAction = [UITableViewRowAction
      rowActionWithStyle:UITableViewRowActionStyleDestructive
                   title:@"Delete"
                 handler:^(UITableViewRowAction *action,
                           NSIndexPath *indexPath) {
                   [self.documents removeDocumentAtIndexPath:indexPath];
                   [self.tableView reloadData];
                 }];

  UITableViewRowAction *shareAction =
      [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                         title:@"Share"
                                       handler:^(UITableViewRowAction *action,
                                                 NSIndexPath *indexPath) {
                                         [self shareFile:indexPath];
                                       }];
  return @[ deleteAction, shareAction ];
}

#pragma mark - UIDocumentInteractionController delegate
- (void)documentInteractionController:
            (UIDocumentInteractionController *)controller
        willBeginSendingToApplication:(NSString *)application {
}

#pragma mark IBActions
- (IBAction)shareFile:(id)sender {
  if (sender == _shareButton) {
    MXDocument *doc =
        [_documents documentAtIndexPath:[_tableView indexPathForSelectedRow]];
    [_docController setURL:doc.fileURL];
    [_docController setUTI:[doc.class UTI]];
    [_docController presentOpenInMenuFromBarButtonItem:_shareButton
                                              animated:YES];
  } else if ([sender isKindOfClass:[NSIndexPath class]]) {
    MXDocument *doc = [_documents documentAtIndexPath:sender];
    [_docController setURL:doc.fileURL];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:sender];
    CGRect frame = cell.frame;
    UIView *view = _tableView.viewForBaselineLayout;
    [_docController presentOpenInMenuFromRect:frame inView:view animated:YES];
  }
}



- (IBAction)deleteAllFiles:(id)sender {
  
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Deleting all files"
                                                                 message:@"Do you really want to delete all files?"
                                                          preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {}];
  UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                      [self.documents removeAllDocuments];
                                                      [self.tableView reloadData];
                                                    }];
  
  [alert addAction:noAction];
  [alert addAction:yesAction];
  [self presentViewController:alert animated:YES completion:nil];
  
}
@end
