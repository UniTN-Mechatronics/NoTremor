//
//  MXMovieDocument.m
//  Lines
//
//  Created by Paolo Bosetti on 29/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import "MXMovieDocument.h"

@implementation MXMovieDocument

+ (NSString *)humanName
{
  return @"Screen cap";
}

+ (NSArray *)extensions
{
  return @[@".mp4"];
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
