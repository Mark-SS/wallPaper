//
//  UIImage+GLWallPaper.h
//  WallPaper
//
//  Created by gongliang on 15/12/9.
//  Copyright © 2015年 AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GLWallPaper)

- (void)gl_saveHomeScreenAndLockScreen;

- (void)gl_saveHomeScreen;

- (void)gl_saveLockScreen;

- (void)gl_saveToPhotos;

@end
