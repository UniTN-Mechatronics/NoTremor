//
//  MXLogDocument.m
//  Lines
//
//  Created by Paolo Bosetti on 29/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import <UIKit/UIKit.h>
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

+ (NSString *)UTI
{
  return @"public.plain-text";
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)renderInView:(UIView *)view
{
  if (view.subviews.count > 0) {
    [[view subviews][0] removeFromSuperview];
  }
  UITextView *textView = [[UITextView alloc] init];
  textView.userInteractionEnabled = YES;
  textView.editable = NO;
  textView.scrollEnabled = YES;
  textView.font = [UIFont fontWithName:@"Courier New" size:14.0];
  textView.text = [NSString stringWithContentsOfFile:self.filePath
                                            encoding:NSUTF8StringEncoding
                                               error:NULL];
  [textView sizeToFit];
  [view insertSubview:textView atIndex:0];
}

@end
