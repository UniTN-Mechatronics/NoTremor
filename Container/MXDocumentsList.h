//
//  MXDocumentsList.h
//  Lines
//
//  Created by Paolo Bosetti on 26/09/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXLogDocument.h"
#import "MXMovieDocument.h"

@interface MXDocumentsList : NSObject
@property NSMutableDictionary *list;
@property NSMutableArray *types;
@property NSString *folderPath;

+ (MXDocumentsList *)documentsListAtPath:(NSString *)path
                                forTypes:(NSArray *)types;

- (void)scanFolder:(NSString *)path forTypes:(NSArray *)types;
- (MXDocument *)documentAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeDocumentAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)sectionAtIndex:(NSInteger)index;
@end
