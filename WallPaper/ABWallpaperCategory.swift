//
//  ABWallpaperCategory.swift
//  WallPaper
//
//  Created by gongliang on 16/1/20.
//  Copyright © 2016年 AB. All rights reserved.
//

import UIKit

class ABWallpaperCategory: NSObject {
    
    var name: String?
    var coverURLString: String?
    var urlString: String?
    init(dict: Dictionary<String, String>) {
        self.name = dict["name"]
        self.coverURLString = dict["cover"]
        self.urlString = dict["url"]
    }
    
}
