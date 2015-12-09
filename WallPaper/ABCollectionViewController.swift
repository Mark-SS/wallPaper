//
//  ABCollectionViewController.swift
//  WallPaper
//
//  Created by gongliang on 15/12/8.
//  Copyright © 2015年 AB. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

private let reuseIdentifier = "logoCell"

class ABCollectionViewController: UICollectionViewController {
    
    var requestURLString: String!
    
    private var nextRequestURLString: String?
    
    private var datas = [AnyObject]()
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDatas()
    }
    
    // MARK: Custom
    func getDatas() {
        var currentRequestURL = String()
        if let tempString = nextRequestURLString {
            currentRequestURL = tempString
        } else {
            currentRequestURL = requestURLString
        }

        Alamofire.request(.GET, currentRequestURL).responseJSON { response in
            switch response.result {
            case .Success(let data):
                //print("data = \(data)")
                if let dict = data as? NSDictionary {
                    let dict2 = dict["link"] as? NSDictionary
                    self.nextRequestURLString = dict2!["next"] as? String
                    if let tempDatas = dict["data"] as? Array<AnyObject> {
                        if self.nextRequestURLString != nil {
                            self.datas = self.datas + tempDatas
                        } else {
                            self.datas = tempDatas
                        }
                        self.collectionView?.reloadData()
                    }
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    // MARK: UICollectionViewLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width/3, UIScreen.mainScreen().bounds.width/3/640*1136)
    }
    

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.datas.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ABCollectionViewCell
        
        let dict = datas[indexPath.row]
        let url = NSURL(string: (dict["small"] as? String)!)
        cell.largeImageView.kf_setImageWithURL(url!)
        
        return cell
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let currentOffset = offset.y + bounds.height - inset.bottom
        
        let maximumOffset = size.height
        
        if currentOffset == maximumOffset {
            print("加载更多")
            self.getDatas()
        }
    }
}
