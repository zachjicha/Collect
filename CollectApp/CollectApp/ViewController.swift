//
//  ViewController.swift
//  CollectApp
//
//  Created by Rizzian Tuazon on 7/2/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import Alamofire
//Import for camera usage
//import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedPhoto:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Display an action menu to select from camera or camera roll
    @IBAction func chooseImage(_ sender: Any) {
        
        //Image picker controller picks an image from either the
        //camera or camera roll based on user selection
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Action sheet to pick photo source
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        //Add source slections to action sheet
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            //Check if camera is available before accessing it
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { (action: UIAlertAction) in
            
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        } ))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Present the action sheet
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Get the image from the picker controller and set it to the selected photo
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedPhoto = image
        
        //Parse the receipt
        self.parseReceipt()
        
        //Dismiss the picker controller
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Parse the receipt using Harsh's code
    func parseReceipt() {
        print("Sending")
        
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
        
        let img = selectedPhoto
        guard let img_data = img?.jpegData(compressionQuality: 1.0) else { return  }
        
        // Use Alamofire to upload image
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(img_data, withName: "file", fileName: "rec.img", mimeType: "image/jpg")
        }, to: url, method: .post, headers: headers)
            .responseJSON { (data) in
                print(data)
        }
    }
    
}
