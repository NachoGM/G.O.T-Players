//
//  ViewController.swift
//  NGMSopraSteria
//
//  Created by Nacho MAC on 23/7/17.
//  Copyright © 2017 Nacho MAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var gotPlayer = [GOTPlayer]()
    
    // MARK: - Display LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadJson()
        initCollectionViewMethods()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    func initCollectionViewMethods() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func downloadJson() {
        let url = URL(string: "http://api.giphy.com/v1/gifs/search?q=game+of+thrones&api_key=9ad9e8e5ad244f87bb73407487ba1254&limit=20")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        SVProgressHUD.show(withStatus: "Loading data")

        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            if let dataObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                let dataArraySuper = dataObj?["data"]
                NSLog("response = \(dataArraySuper!)")
                
                if let imagesObj = (dataArraySuper! as AnyObject).value(forKey: "images") as? NSArray {
                    
                    if let originalObj = (imagesObj as AnyObject).value(forKey: "original") as? NSArray {
                        
                        for images in originalObj {
                            if let originalDict = images as? NSDictionary {
                                
                                let imageURL = originalDict.value(forKey: "url")
                                let gotPlayerObject = GOTPlayer(image: imageURL as! String)
                                self.gotPlayer.append(gotPlayerObject)
                            }
                        }
                    }
                }

                SVProgressHUD.dismiss()
                
                OperationQueue.main.addOperation({
                    self.collectionView.reloadData()
                })
            }
            
        }).resume()

    }

    //MARK: - CollectionView Methods:
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gotPlayer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageURL = gotPlayer[indexPath.row].image ?? ""
        return configGOTCell(indexPath: indexPath, imageURL: imageURL)
    }
    
    func configGOTCell(indexPath: IndexPath, imageURL: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let imgURL = NSURL(string: imageURL)
        
        if imgURL != nil {
            let gifURL : String = imageURL
            let imageURL = UIImage.gif(url: gifURL)
            let GIFView = UIImageView(image: imageURL)
            let width = collectionView.frame.width / 2 - 1

            GIFView.frame = CGRect(x: cell.gifView.frame.origin.x, y: cell.gifView.frame.origin.y, width: width, height: width)

            cell.gifView.addSubview(GIFView)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURL = gotPlayer[indexPath.row].image ?? ""
        let desCV = self.storyboard?.instantiateViewController(withIdentifier: "DetailedGIFVC") as! DetailedGIFVC
        desCV.imageString = imageURL
        self.navigationController?.pushViewController(desCV, animated: true)
    }
}
