//
//  MXDocument.h
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MXDocument : NSObject {
  @protected
}

@property NSString *fileName;
@property NSString *fileExt;
@property NSString *folderPath;
@property (readonly) NSString *humanName;

+ (NSString *)humanName;
+ (NSArray *)extensions;
+ (NSString *)UTI;
+ (NSMutableArray *)filterFileNames:(NSArray *)list atPath:(NSString *)path;

- (instancetype)initWithFileName:(NSString *)name;
- (NSString *)filePath;
- (NSURL *)fileURL;
- (BOOL) delete;
- (BOOL) renameTo:(NSString *)newName;
- (void)renderInView:(UIView *)view;
- (NSString *)fileDescription;
@end
