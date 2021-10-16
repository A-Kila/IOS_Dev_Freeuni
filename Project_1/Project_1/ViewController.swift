//
//  ViewController.swift
//  Project_1
//
//  Created by Andria Kilasonia on 16.10.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var displays: [UIView]!
    
    let displayNumber = 420
    let onAlpha = 1.0
    let offAlpha = 0.2
    
    /*
     * this array stores 1 for the segment indexes that need to light up.
     * orderd from top-left (North first, bottom last)
     *
     * Bool array needed more writing, writing 1 and 0 is faster
     */
    let numberSegments: [[Int]] = [
        [1, 1, 1, 0, 1, 1, 1], // 0
        [0, 0, 1, 0, 0, 1, 0], // 1
        [1, 0, 1, 1, 1, 0, 1], // 2
        [1, 0, 1, 1, 0, 1, 1], // 3
        [0, 1, 1, 1, 0, 1, 0], // 4
        [1, 1, 0, 1, 0, 1, 1], // 5
        [1, 1, 0, 1, 1, 1, 1], // 6
        [1, 0, 1, 0, 0, 1, 0], // 7
        [1, 1, 1, 1, 1, 1, 1], // 8
        [1, 1, 1, 1, 0, 1, 1]  // 9
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let hundredsDigit = displayNumber / 100
        let tensDigit = displayNumber / 10 % 10
        let onesDigit = displayNumber % 10
        let displayNumberDigits = [hundredsDigit, tensDigit, onesDigit]
        
        var numDisplay = 0
        for display in displays {
            var i = 0
            for segment in display.subviews {
                let isOn = numberSegments[displayNumberDigits[numDisplay]][i] == 1
                segment.alpha = isOn ? onAlpha : offAlpha
                    
                i += 1
            }
            numDisplay += 1
        }
    }

}
