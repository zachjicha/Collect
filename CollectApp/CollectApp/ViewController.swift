//
//  ViewController.swift
//  CollectApp
//
//  Created by Rizzian Tuazon on 7/2/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Item : Codable
{
    let itemName : String?
    let totalAmount: Double?
}
class ViewController: UIViewController {
    // API Key: a31246109d0211e98bfadfb7eb1aa8b5
    var Items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Image loading (to-do: replace with controller)
        
        let img = UIImage(named: "rec.jpg")!
        
        apiCall(img: img)
    }
        
    func apiCall(img : UIImage)
    {
        print("IN API CALL")
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
    
    guard let img_data = img.jpegData(compressionQuality: 1.0) else { return  }
    // Use Alamofire to upload image
    AF.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(img_data, withName: "file", fileName: "rec.img", mimeType: "image/jpg")
    }, to: url, method: .post, headers: headers)
        .responseJSON { (response) in
            switch response.result
            {
            case .success(let value):
                let json = JSON(value)
                // print(json["amounts"])
                if let amounts = json["amounts"].array
                {
                    for JSONItem in amounts
                    {
                        let item = Item(itemName: JSONItem["text"].string, totalAmount: JSONItem["data"].double)
                        // print(item.itemName!, item.totalAmount!)
                        self.Items.append(item)
                    }
                    self.printItems()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    
}

    func printItems()
    {
        print("in pItems")
        print(self.Items.count)
        for item in self.Items
        {
            print(item.itemName!, item.totalAmount!)

        }
    }


}
