//
//  ViewController.swift
//  CollectApp
//
//  Created by Rizzian Tuazon on 7/2/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    // API Key: a31246109d0211e98bfadfb7eb1aa8b5
    struct Item : Codable
    {
        var totalAmount : Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        let img = UIImage(named: "rec.jpg")
        guard let img_data = img?.jpegData(compressionQuality: 1.0) else { return  }
        var savedData : Data
        
        // Use Alamofire to upload image
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(img_data, withName: "file", fileName: "rec.img", mimeType: "image/jpg")
        }, to: url, method: .post, headers: headers)
            .responseJSON { (response) in
                print(response)
                switch response.result
                {
                case .success(let data):
                    guard let json = data as? [String : AnyObject] else { return }
                    var amount = json["totalAmount"]?["data"] as! Double
                    print(amount)
                case .failure(let error):
                    print(error)
                }
                
        }
}

}

