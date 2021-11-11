//
//  ViewController.swift
//  Project_2
//
//  Created by Andria Kilasonia on 11.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var backgroundCirle: UIView!
    @IBOutlet var profilePic: UIView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var appIcons: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        backgroundCirle.layer.cornerRadius = backgroundCirle.frame.height / 2
        profilePic.layer.cornerRadius = profilePic.frame.height / 2
        infoView.layer.cornerRadius = 16
        
        for icon in appIcons {
            icon.layer.cornerRadius = 24
        }
    }

}

