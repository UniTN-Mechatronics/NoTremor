//
//  MXDocument.m
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import "MXDocument.h"

@implementation MXDocument

+ (NSString *)humanName
{
  return @"Generic file";
}

+ (NSArray *)extensions
{
  return @[@""];
}

+ (NSString *)UTI
{
  return @"public.plain-text";
}

+ (NSMutableArray *)filterFileNames:(NSArray *)list atPath:(NSString *)path
{
  NSPredicate    *filter;
  NSMutableArray *shortList = [NSMutableArray arrayWithCapacity:list.count];
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:list.count];
  
  for (NSString *ext in [self extensions]) {
    filter = [NSPredicate predicateWithFormat:@"self ENDSWITH %@", ext];
    [shortList removeAllObjects];
    [shortList addObjectsFromArray:[list filteredArrayUsingPredicate:filter]];
    for (NSString *fileName in shortList) {
      [result addObject:[[self alloc] initWithFileName:fileName]];
      [[result lastObject] setFileExt:ext];
      [[result lastObject] setFolderPath:path];
    }
  }
  
  return result;
}


- (id)init
{
  self = [super init];
  if (self) {
    self.folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    _humanName = [self.class humanName];
  }
  return self;
}

- (instancetype)initWithFileName:(NSString *)name
{
  self = [self init];
  if (self) {
    self.fileName = name;
  }
  return self;
}

- (NSString *)filePath
{
  return [self.folderPath stringByAppendingPathComponent:_fileName];
}

- (NSURL *)fileURL
{
  return [NSURL fileURLWithPath:[self filePath]];
}



- (BOOL) delete
{
  return NO;
}

- (BOOL) renameTo:(NSString *)newName
{
  return NO;
}


- (void)renderInView:(UIView *)view
{
  [view addSubview:[[UIView alloc] init]];
}

- (NSString *)fileDescription
{
  NSDictionary *attr = [[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath error:nil];
  return [NSString stringWithFormat:@"%@ (%lu kb)", self.fileName, [attr[NSFileSize] integerValue]  / 1024];
}

@end
