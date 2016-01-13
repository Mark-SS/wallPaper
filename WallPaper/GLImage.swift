//
//  GLImage.swift
//  WallPaper
//
//  Created by gongliang on 16/1/12.
//  Copyright © 2016年 AB. All rights reserved.
//

import UIKit


extension UIImage {
    func gll_saveHomeScreenAndLockScreen() {
        
        self.gll_wallPaperVC().performSelector("setImageAsHomeScreenAndLockScreenClicked:", withObject: nil)
    }
    
    func gll_saveHomeScreen() {
        self.gll_wallPaperVC().performSelector("setImageAsHomeScreenClicked:", withObject: nil)
    }
    
    func gll_saveLockScreen() {
        self.gll_wallPaperVC().performSelector("setImageAsLockScreenClicked:", withObject: nil)
    }
    
    func gll_saveToPhotos() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    func gll_wallPaperVC() -> NSObject {
        let wallPaperClass = NSClassFromString("PLStaticWallpaperImageViewController") as! NSObject.Type
        let wallPaperInstance: NSObject = wallPaperClass.init()
        wallPaperInstance.performSelector(NSSelectorFromString("initWithUIImage:"), withObject: self)
        wallPaperInstance.setValue(true, forKeyPath: "allowsEditing")
        wallPaperInstance.setValue(true, forKeyPath: "saveWallpaperData")
        return wallPaperInstance
    }
}

