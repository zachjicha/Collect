//
//  HomeScreenViewController.swift
//  Collect
//
//  Created by Brian Thyfault on 7/18/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit
import SwiftyGif

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var newReceiptView: UIView!
    @IBOutlet weak var savedReceiptsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newReceiptView.isUserInteractionEnabled = true
        savedReceiptsView.isUserInteractionEnabled = true
        
        let tapGestureForNew = UITapGestureRecognizer(target: self, action: #selector(self.tappedNewReceipt))
        let tapGestureForSaved = UITapGestureRecognizer(target: self, action: #selector(self.tappedSavedReceipts))
        
        newReceiptView.addGestureRecognizer(tapGestureForNew)
        savedReceiptsView.addGestureRecognizer(tapGestureForSaved)
        
        loadGif()
    }
    
    @objc func tappedNewReceipt() {
        performSegue(withIdentifier: "NewReceiptSegue", sender: self)
    }
    
    @objc func tappedSavedReceipts() {
        performSegue(withIdentifier: "SavedReceiptsSegue", sender: self)
    }
    
    
    //This is how to display the loading gif
    func loadGif() {
        do {
            let gif = try UIImage(gifName: "Loading-Final TM.gif")
            self.loadingImageView.setGifImage(gif)
        } catch {
            print(error)
        }
    }
    
}
