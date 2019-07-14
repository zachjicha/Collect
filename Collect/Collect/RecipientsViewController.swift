//
//  ViewControllerB.swift
//  Collect
//
//  Created by Norris Chan on 7/13/19.
//  Copyright © 2019 The Collective. All rights reserved.
//

import UIKit

class RecipientsViewController: UIViewController {
    @IBOutlet weak var recipients: UITextField!
    var listNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func next(_ sender: Any) {
        self.listNum = recipients.text!
        performSegue(withIdentifier: "listNum", sender: self)
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    */
}
