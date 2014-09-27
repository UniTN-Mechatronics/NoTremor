//
//  MXDocumentsList.m
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "MXDocumentsList.h"

@implementation MXDocumentsList

+ (MXDocumentsList *)documentsListAtPath:(NSString *)path forTypes:(NSDictionary *)types
{
  MXDocumentsList * docs = [[MXDocumentsList alloc] init];
  [docs scanFolder:path forExtensions:[types allKeys]];
  return docs;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    self.types = [NSMutableDictionary dictionaryWithDictionary:@{@".txt" : @"Logs", @".mp4" : @"Movies"}];
    self.list = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)scanFolder:(NSString *)path forExtensions:(NSArray *)extList
{
  if (path != nil) {
    self.folderPath = path;
  }
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *allItems = [manager contentsOfDirectoryAtPath:self.folderPath
                                                   error:nil];
  NSPredicate *fltr;
  NSArray *list;
  NSMutableArray *docsList;
  for (NSString *k in [self.types allKeys]) {
    fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH %@", k];
    list = [[NSArray alloc] initWithArray:[allItems filteredArrayUsingPredicate:fltr]];
    docsList = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [docsList addObject:[[MXDocument alloc] initWithFileName:obj]];
      [[docsList lastObject] setFolderPath:_folderPath];
      [[docsList lastObject] setFileExt:k];
    }];
    self.list[k] = docsList;
  }
}

- (MXDocument *)documentAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *key = [_types allKeys][indexPath.section];
  NSInteger idx = indexPath.row;
  MXDocument *doc = self.list[key][idx];
  return doc;
}

- (void)removeDocumentAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *key = [_types allKeys][indexPath.section];
  NSInteger idx = indexPath.row;
  MXDocument *doc = self.list[key][idx];
  [_list[key] removeObjectAtIndex:idx];
  [[NSFileManager defaultManager] removeItemAtPath:doc.filePath error:nil];
}

- (NSString *)sectionAtIndex:(NSInteger)index
{
  return [_list allKeys][index];
}

@end
