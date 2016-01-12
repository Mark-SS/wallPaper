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
import SKPhotoBrowser

private let reuseIdentifier = "logoCell"

class ABCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate {
    
    var requestURLString: String!
    private var browser: SKPhotoBrowser?
    var images: [SKPhoto]?
    var currentSelectIndex = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var nextRequestURLString: String?
    
    private var datas:NSArray = [AnyObject]()
    
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
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.datas.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ABCollectionViewCell
        
        let dict = datas[indexPath.row]
        let url = NSURL(string: (dict["small"] as? String)!)
        cell.largeImageView.kf_setImageWithURL(url!)
        
        return cell
    }
    
    // MARK: UICollectionDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ABCollectionViewCell
        let originImage = cell.largeImageView.image! // some image for baseImage
        
        images = self.getImages()
        
        browser = SKPhotoBrowser(originImage: originImage, photos: images!, animatedFromView: cell)
        browser!.delegate = self
        browser!.initializePageIndex(indexPath.row)
        presentViewController(browser!, animated: true, completion: {
            let lpgr = UILongPressGestureRecognizer(target: self, action: "longAction:")
            //            lpgr.minimumPressDuration = 0.5
            self.browser?.view.addGestureRecognizer(lpgr)
        })
    }
    
    
    func longAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            print("currentSelectIndex = \(currentSelectIndex)")
            let photo = images![currentSelectIndex]
            let image = photo.underlyingImage
            if image == nil {
                return
            }
            let actions = UIAlertController(title: "选择", message: nil, preferredStyle: .ActionSheet)
            let lockAction = UIAlertAction(title: "设定锁定屏幕", style: .Default, handler: {(alert: UIAlertAction!) in
                image.gll_saveLockScreen()
            })
            let homeAction = UIAlertAction(title: "设定主屏幕", style: .Default, handler: {(alert: UIAlertAction!) in
                image.gll_saveHomeScreen()
            })
            let bothAction = UIAlertAction(title: "同时设定", style: .Default, handler: {(alert: UIAlertAction!) in
                image.gll_saveHomeScreenAndLockScreen()
            })
            let photoAction = UIAlertAction(title: "保存到相册", style: .Default, handler: {(alert: UIAlertAction!) in
                image.gll_saveToPhotos()
            })
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: {(alert: UIAlertAction!) in
                actions .dismissViewControllerAnimated(true, completion: nil)
            })
            
            actions.addAction(lockAction)
            actions.addAction(homeAction)
            actions.addAction(bothAction)
            actions.addAction(photoAction)
            actions.addAction(cancelAction)
            
            browser?.presentViewController(actions, animated: true, completion: nil)
        }
    }
    
    func getImages() -> [SKPhoto] {
        var images = [SKPhoto]()
        for item in self.datas {
            let dict = item as! NSDictionary
            let photo = SKPhoto.photoWithImageURL(dict["big"] as! String)
            images.append(photo)
        }
        return images
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
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
    
    func didShowPhotoAtIndex(index:Int) {
        currentSelectIndex = index
    }
    
    func didDismissAtPageIndex(index:Int) {
        browser = nil
    }
    
}
