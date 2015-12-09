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
    
    var datas = [AnyObject]()
    
    /**
     http://api.lovebizhi.com/iphone_v3.php?a=category&tid=2&device=&uuid=993DF988E9C743F790707CA22AA40189&mode=0&retina=0&client_id=1002&device_id=59864457&model_id=100&size_id=0&channel_id=19953&screen_width=750&screen_height=1334&bizhi_width=1080&bizhi_height=1920&version_code=54&language=zh-Hans-CN&jailbreak=0&mac=7AB9D86B-E75C-4A29-B496-7AD01408D919&order=newest&color_id=3
     
     */
    
    override func viewWillAppear(animated: Bool) {
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func refresh() {
        if datas.count == 0 {
            self.refreshControl?.beginRefreshing()
//            let scale = UIScreen.mainScreen().scale
//            let widthScale = Int(UIScreen.mainScreen().bounds.width * scale)
//            let heightScale = Int(UIScreen.mainScreen().bounds.height * scale)
//            let wallPaperUrl = String(format: kWallpaper_list_categroy, widthScale, heightScale)
            Alamofire.request(.GET, kWallpaper_list_categroy).responseJSON { response in
                self.refreshControl?.endRefreshing()
                switch response.result {
                case .Success(let data):
                    if let dict1 = data as? Dictionary<String, AnyObject> {
                        if let dict2 = dict1["category"] as? Array<AnyObject> {
                            self.datas = dict2
                            self.tableView.reloadData()
                        }
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.datas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeListCell", forIndexPath: indexPath) as! ABCategoryCell
        let dict = datas[indexPath.row]
        let url = NSURL(string: (dict["cover"] as? String)!)
        cell.logoImageView.kf_setImageWithURL(url!)
        cell.nameLabel.text = dict["name"] as? String
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - IBOutlets
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }

    
}
