//
//  AddNameController.swift
//  Collect
//
//  Created by Norris Chan on 7/14/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

protocol AddName{
    func addName(name: String)
}

class AddNameController: UIViewController {

    
    @IBAction func addAction(_ sender: Any) {
        if nameOutlet.text != "" {
            delegate?.addName(name: nameOutlet.text!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBOutlet weak var nameOutlet: UITextField!
    
    var delegate: AddName?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
