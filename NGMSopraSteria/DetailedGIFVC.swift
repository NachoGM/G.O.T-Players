//
//  DetailedGIFVC.swift
//  NGMSopraSteria
//
//  Created by Nacho MAC on 23/7/17.
//  Copyright © 2017 Nacho MAC. All rights reserved.
// 

import UIKit
 
class DetailedGIFVC: UIViewController {

    var imageString:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        configGIF()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configGIF() {
        let gifURL : String = imageString
        
        let imageURL = UIImage.gif(url: gifURL)
        
        let GIFView = UIImageView(image: imageURL)
        GIFView.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 69, width: self.view.frame.size.width, height:self.view.frame.size.width - 150.0)
        view.addSubview(GIFView)
    }
    
    func updateUI() {
        let imgURL = URL(string:imageString)
        _ = NSData(contentsOf: (imgURL)!)
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)
    }

}
