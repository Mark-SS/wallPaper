//
//  ABHomeViewController.swift
//  WallPaper
//
//  Created by gongliang on 15/12/4.
//  Copyright © 2015年 AB. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

private let kWallpaper_list_categroy = "http://open.lovebizhi.com/baidu_rom.php?width=640&height=1136"

class ABHomeViewController: UITableViewController {
    
    var datas = [ABWallpaperCategory]()
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func refresh() {
        if datas.count == 0 {
            self.refreshControl?.beginRefreshing()

            Alamofire.request(.GET, kWallpaper_list_categroy).responseJSON { response in
                self.refreshControl?.endRefreshing()
                switch response.result {
                case .Success(let data):
                    if let dict1 = data as? Dictionary<String, AnyObject> {
                        if let categorys = dict1["category"] as? Array<AnyObject> {
                            for obj in categorys {
                                let wallpaperCategory:ABWallpaperCategory = ABWallpaperCategory(dict: obj as! Dictionary<String, String>)
                                self.datas.append(wallpaperCategory)
                            }
                            self.tableView.reloadData()
                        }
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeListCell", forIndexPath: indexPath) as! ABCategoryCell
        let wallpaperCategory:ABWallpaperCategory = datas[indexPath.row]
        let url = NSURL(string: wallpaperCategory.coverURLString!)
        cell.logoImageView.kf_setImageWithURL(url!)
        cell.nameLabel.text = wallpaperCategory.name
        // Configure the cell...
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dict = datas[indexPath.row]
        self.performSegueWithIdentifier("gotoCollectionView", sender: dict)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let collectionVC = segue.destinationViewController as! ABCollectionViewController
        let dict = sender as! ABWallpaperCategory
        collectionVC.requestURLString = dict.urlString
        collectionVC.title = dict.name
    }
    
    
}
