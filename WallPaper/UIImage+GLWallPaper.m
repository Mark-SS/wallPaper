//
//  UIImage+GLWallPaper.m
//  WallPaper
//
//  Created by gongliang on 15/12/9.
//  Copyright © 2015年 AB. All rights reserved.
//

#import "UIImage+GLWallPaper.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIImage (GLWallPaper)

#pragma clang diagnostic ignored "-Wundeclared-selector" //忽略警告

- (void)gl_saveHomeScreenAndLockScreen {
    [self.gl_wallPaperVC performSelector:@selector(setImageAsHomeScreenAndLockScreenClicked:) withObject:nil];
}

- (void)gl_saveHomeScreen {
    [self.gl_wallPaperVC performSelector:@selector(setImageAsHomeScreenClicked:) withObject:nil];
}

- (void)gl_saveLockScreen {
    [self.gl_wallPaperVC performSelector:@selector(setImageAsLockScreenClicked:) withObject:nil];
}

- (void)gl_saveToPhotos {
    UIImageWriteToSavedPhotosAlbum(self, nil,nil, NULL);
}

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (instancetype)gl_wallPaperVC
{
    Class wallPaperClass = NSClassFromString(@"PLStaticWallpaperImageViewController");
    id wallPaperInstance = [[wallPaperClass alloc] performSelector:NSSelectorFromString(@"initWithUIImage:") withObject:self];
    [wallPaperInstance setValue:@(YES) forKeyPath:@"allowsEditing"];
    [wallPaperInstance  setValue:@(YES) forKeyPath:@"saveWallpaperData"];
    
    return wallPaperInstance;
}

@end
