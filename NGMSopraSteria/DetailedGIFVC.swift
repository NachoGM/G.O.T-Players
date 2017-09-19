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

        // Do any additional setup after loading the view.

        updateUI()
        
        let gifURL : String = imageString
        
        let imageURL = UIImage.gif(url: gifURL)
        
        let GIFView = UIImageView(image: imageURL)
        GIFView.frame = CGRect(x: 20.0, y: 150, width: self.view.frame.size.width - 40, height: 150.0)
        view.addSubview(GIFView)
    }

    
    func updateUI() {

        let imgURL = URL(string:imageString)
        _ = NSData(contentsOf: (imgURL)!)

    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        _ = navigationController?.popViewController(animated: true)

    }

}
