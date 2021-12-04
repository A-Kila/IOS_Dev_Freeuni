//
//  DigitButton.swift
//  Project_3
//
//  Created by Andria Kilasonia on 04.12.21.
//

import UIKit

class DigitButton: BaseReusableView {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var alphabetLabel: UILabel!
    
    func viewDidAppear() {
        numberLabel.font = numberLabel.font.withSize(contentView.frame.height / 2)
        alphabetLabel.font = alphabetLabel.font.withSize(contentView.frame.height / 8)
        layer.cornerRadius = frame.height / 2
    }
    
}
