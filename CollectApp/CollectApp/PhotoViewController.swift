//
//  PhotoViewController.swift
//  CollectApp
//
//  Created by Zach Jicha on 7/6/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import Alamofire

class PhotoViewController: UIViewController {
    
    var takenPhoto:UIImage?

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = takenPhoto {
            imageView.image = availableImage
        }
    }
    
    @IBAction func parseReceipt(_ sender: Any) {
        
        // API Setup:
        let key = "a31246109d0211e98bfadfb7eb1aa8b5" // API-Key
        guard let url = URL(string: "https://api-au.taggun.io/api/receipt/v1/verbose/file") else {
            return
        } // URL for API
        
        // Headers for JSON request
        let headers: HTTPHeaders = [
            "apikey": key,
            "Content-type": "multipart/form-data",
            "Accept" : "application/json"]
        // Image loading (to-do: replace with controller)
        
        let img = takenPhoto
        guard let img_data = img?.jpegData(compressionQuality: 1.0) else { return  }
        
        // Use Alamofire to upload image
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(img_data, withName: "file", fileName: "rec.img", mimeType: "image/jpg")
        }, to: url, method: .post, headers: headers)
            .responseJSON { (data) in
                print(data)
        }
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
