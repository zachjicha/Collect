//
//  ItemAmountViewController.swift
//  Collect
//
//  Created by Johnny Palacios on 7/17/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class ItemAmountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var itemField: UITextField!
    
    @IBOutlet weak var amountField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
        configureTapGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ItemAmountViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func handleTap() {
        view.endEditing(true)
        
    }
    
    private func configureTextFields() {
        itemField.delegate = self
        amountField.delegate = self
    }
    
    
    
    @IBAction func enterTapped(_ sender: Any){
          view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountField.resignFirstResponder()
    }
}
