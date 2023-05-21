//
//  HelpViewController.swift
//  Pikey Coffee Shop
//
//  Created by ghostech on 21/05/2023.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }

}
