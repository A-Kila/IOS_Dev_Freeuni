//
//  ViewController.swift
//  Project_3
//
//  Created by Andria Kilasonia on 04.12.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var buttons: [DigitButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for button in buttons { button.viewDidAppear() }
    }

}
