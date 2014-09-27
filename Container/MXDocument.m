//
//  MXDocument.m
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import "MXDocument.h"

@implementation MXDocument

- (id)init
{
  self = [super init];
  if (self) {
    self.folderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
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


- (UIView *)renderInView
{
  return [[UIView alloc] init];
}

@end
