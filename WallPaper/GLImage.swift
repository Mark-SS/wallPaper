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
        self.gll_wallPaperVC().performSelector("setImageAsHomeScreenAndLockScreenClicked:")
    }
    
    func gll_saveHomeScreen() {
        self.gll_wallPaperVC().performSelector("setImageAsHomeScreenClicked:")
    }
    
    func gll_saveLockScreen() {
        self.gll_wallPaperVC().performSelector("setImageAsLockScreenClicked:")
    }
    
    func gll_saveToPhotos() {
        UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil)
    }
    
    func gll_wallPaperVC() -> NSObject {
        let wallPaperClass = NSClassFromString("PLStaticWallpaperImageViewController") as! NSObject.Type
        let wallPaperInstance: NSObject = wallPaperClass.init()
        wallPaperInstance.setValue(true, forKey: "allowsEditing")
        wallPaperInstance.setValue(true, forKey: "saveWallpaperData")
        return wallPaperInstance
    }
}