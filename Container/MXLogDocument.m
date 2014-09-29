//
//  MXLogDocument.m
//  Lines
//
//  Created by Paolo Bosetti on 29/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import "MXLogDocument.h"

@implementation MXLogDocument

+ (NSString *)humanName
{
  return @"Log file";
}

+ (NSArray *)extensions
{
  return @[@".txt", @".dat", @".log"];
}

+ (NSPredicate *)predicate
{
  return [NSPredicate predicateWithFormat:@"self ENDSWITH %@", self.extensions[0]];
}


- (instancetype)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

@end
