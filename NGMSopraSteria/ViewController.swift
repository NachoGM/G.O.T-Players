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
    
    var nameArray = [String]()
    var imgURLArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        downloadJson()

        collectionView.dataSource = self
        collectionView.delegate = self
    }
   
    
    // MARK: API Call HTTPMethod using GET  
     
    func downloadJson() {
         
        var request = URLRequest(url: URL(string: "http://api.giphy.com/v1/gifs/search?q=game+of+thrones&api_key=9ad9e8e5ad244f87bb73407487ba1254&limit=20")!)
        
        // "http://api.giphy.com/v1/gifs/search?q=game+of+thrones&api_key=9ad9e8e5ad244f87bb73407487ba1254&limit=20"
        // "https://raw.githubusercontent.com/AXA-GROUP-SOLUTIONS/mobilefactory-test/master/data.json"
        
        request.httpMethod = "GET"
        
        SVProgressHUD.show(withStatus: "Loading data...")

        URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            
            if let dataObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                let dataArraySuper = dataObj?["data"]
                print("response = \(dataArraySuper!)")
                if let imagesObj = (dataArraySuper! as AnyObject).value(forKey: "images") as? NSArray {
                    
                    if let originalObj = (imagesObj as AnyObject).value(forKey: "original") as? NSArray {
                        
                        for images in originalObj {
                            if let originalDict = images as? NSDictionary {
                                
                                if let name = originalDict.value(forKey: "url") {
                                    self.imgURLArray.append(name as! String)

                                }
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
    
    
    //MARK: Customize color StatusBar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    //MARK: CollectionView Methods:
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imgURLArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        
        if imgURL != nil {
            
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.imgGIF.image = UIImage(data: data! as Data)
            
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

        let desCV = self.storyboard?.instantiateViewController(withIdentifier: "DetailedGIFVC") as! DetailedGIFVC

        desCV.imageString = imgURLArray[indexPath.row]
        
        self.navigationController?.pushViewController(desCV, animated: true)
        
    }
    
    
}



