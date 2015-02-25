//
//  CodeaViewController.h
//  Lines
//
//  Created by Paolo Bosetti on giovedì 18 settembre 2014
//  Copyright (c) Paolo Bosetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CodeaAddon;

typedef enum CodeaViewMode {
  CodeaViewModeStandard,
  CodeaViewModeFullscreen,
  CodeaViewModeFullscreenNoButtons,
} CodeaViewMode;

@interface CodeaViewController : UIViewController

@property(nonatomic, assign) CodeaViewMode viewMode;
@property(nonatomic, assign) BOOL paused;

- (instancetype)initWithProjectAtPath:(NSString *)path;

- (void)setViewMode:(CodeaViewMode)viewMode animated:(BOOL)animated;

- (void)loadProjectAtPath:(NSString *)path;

- (void)registerAddon:(id<CodeaAddon>)addon;

- (void)restart;

@end
