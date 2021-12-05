//
//  ViewController.swift
//  Project_3
//
//  Created by Andria Kilasonia on 04.12.21.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet var dots: [UIView]!
    @IBOutlet var buttons: [DigitButton]!
    
    let password = "1111"
    var inputedPass = ""
    
    let letterLabels = [
        "",
        "", "A B C", "D E F",
        "G H I", "J K L", "M N O",
        "P Q R S", "T U V", "W X Y Z"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for dot in dots {
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.white.cgColor
            dot.backgroundColor = .white.withAlphaComponent(0)
        }
        
        var index = 0
        for button in buttons {
            button.delegate = self
            button.numberLabel.text = "\(index)"
            
            switch index {
            case 0:
                button.alphabetLabel.removeFromSuperview()
            case 1:
                button.alphabetLabel.layer.opacity = 0
            default:
                button.alphabetLabel.text = letterLabels[index]
            }
            
            index += 1
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for dot in dots {
            dot.layer.cornerRadius = dot.frame.height / 2
        }
        
        for button in buttons { button.viewDidAppear() }
    }
    
    // animate
    func redrawDots() {
        var inputSize = inputedPass.count
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                for dot in self.dots {
                    dot.backgroundColor = inputSize > 0 ?
                        .white.withAlphaComponent(1) :
                        .white.withAlphaComponent(0)
                    
                    inputSize -= 1
                }
            }
        )
    }
    
    @IBAction func deletePressed() {
        guard inputedPass.count > 0 else { return }
        
        let endIndex = inputedPass.index(inputedPass.endIndex, offsetBy: -1)
        inputedPass = String(inputedPass[..<endIndex])
        
        redrawDots()
    }
    
    func presentEmptyVC() {
        let mainStorybaord = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStorybaord.instantiateViewController(withIdentifier: "EmptyVC")
        
        if let emptyVC = vc as? EmptyVC {
            emptyVC.modalPresentationStyle = .overFullScreen
            present(emptyVC, animated: true)
        }
    }

}

extension MainVC: DigitButtonDelegate {
    
    func DigitDidTapButton(_ sender: DigitButton) {
        guard let senderText = sender.numberLabel.text else { return }
        
        inputedPass += senderText
        redrawDots()
        
        guard inputedPass.count == 4 else { return }
        
        if inputedPass == password {
            presentEmptyVC()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            self.inputedPass = ""
            self.redrawDots()
        }
    }

}
