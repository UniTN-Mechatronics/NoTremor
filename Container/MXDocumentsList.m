//
//  MXDocumentsList.m
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import "MXDocumentsList.h"

@implementation MXDocumentsList

+ (MXDocumentsList *)documentsListAtPath:(NSString *)path
                                forTypes:(NSArray *)types {
  MXDocumentsList *docs = [[MXDocumentsList alloc] init];
  [docs scanFolder:path forTypes:types];
  return docs;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.folderPath =
        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    self.types = [NSMutableArray
        arrayWithObjects:MXLogDocument.class, MXMovieDocument.class, nil];
    self.list = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (void)scanFolder:(NSString *)path forTypes:(NSArray *)types {
  if (path != nil)
    self.folderPath = path;
  if (types != nil)
    self.types = (NSMutableArray *)types;
  NSFileManager *manager = [NSFileManager defaultManager];
  NSArray *allItems =
      [manager contentsOfDirectoryAtPath:self.folderPath error:nil];

  for (Class k in self.types) {
    NSMutableArray *docsList =
        [k filterFileNames:allItems atPath:self.folderPath];
    [self.list setObject:docsList forKey:[k humanName]];
  }
}

- (MXDocument *)documentAtIndexPath:(NSIndexPath *)indexPath {
  NSString *key = [_types[indexPath.section] humanName];
  NSInteger idx = indexPath.row;
  MXDocument *doc = self.list[key][idx];
  return doc;
}

- (void)removeDocumentAtIndexPath:(NSIndexPath *)indexPath {
  NSString *key = [_types[indexPath.section] humanName];
  NSInteger idx = indexPath.row;
  MXDocument *doc = self.list[key][idx];
  [_list[key] removeObjectAtIndex:idx];
  [[NSFileManager defaultManager] removeItemAtPath:doc.filePath error:nil];
}

- (NSString *)sectionAtIndex:(NSInteger)index {
  return [_list allKeys][index];
}

@end
