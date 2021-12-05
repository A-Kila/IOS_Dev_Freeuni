//
//  DigitButton.swift
//  Project_3
//
//  Created by Andria Kilasonia on 04.12.21.
//

import UIKit

protocol DigitButtonDelegate: AnyObject {
    func DigitDidTapButton(_ sender: DigitButton)
}

class DigitButton: BaseReusableView {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var alphabetLabel: UILabel!
    
    weak var delegate: DigitButtonDelegate?
    
    override func setup() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = .white.withAlphaComponent(0)
    }
    
    func viewDidAppear() {
        numberLabel.font = numberLabel.font.withSize(contentView.frame.height / 2)
        alphabetLabel.font = alphabetLabel.font.withSize(contentView.frame.height / 8)
        layer.cornerRadius = frame.height / 2
    }
    
    func animate(animation animFunc: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .allowUserInteraction,
            animations: animFunc
        )
    }
    
    @IBAction func highlightButtonTouchDown() {
        animate {
            self.backgroundColor = .white.withAlphaComponent(0.65)
        }
    }
    
    @IBAction func highlightButtonTouchUpOutside() {
        animate {
            self.backgroundColor = .white.withAlphaComponent(0)
        }
    }
    
    @IBAction func highlightButtonTouchUpInside() {
        highlightButtonTouchUpOutside()
        delegate?.DigitDidTapButton(self)
    }
    
}
