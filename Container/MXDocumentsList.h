//
//  MXDocumentsList.h
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXDocument.h"

@interface MXDocumentsList : NSObject
@property NSMutableDictionary *list;
@property NSMutableDictionary *types;
@property NSString *folderPath;

+ (MXDocumentsList *)documentsListAtPath:(NSString *)path forTypes:(NSDictionary *)types;

- (void)scanFolder:(NSString *)path forExtensions:(NSArray *)extList;
- (MXDocument *)documentAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeDocumentAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)sectionAtIndex:(NSInteger)index;
@end
