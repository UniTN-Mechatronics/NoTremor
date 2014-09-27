//
//  MXDocument.h
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MXDocument : NSObject
@property NSString *fileName;
@property NSString *fileExt;
@property NSString *folderPath;

- (instancetype)initWithFileName:(NSString *)name;
- (NSString *)filePath;
- (NSURL *)fileURL;
- (BOOL) delete;
- (BOOL) renameTo:(NSString *)newName;
- (UIView *)renderInView;
@end
