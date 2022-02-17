//
//  ErrorScreenView.swift
//  Final Project
//
//  Created by Andria Kilasonia on 16.02.22.
//

import UIKit

protocol ErrorScreenViewDelegate {
    func refresh()
}

class ErrorScreenView: BaseReusableView {
    
    var delegate: ErrorScreenViewDelegate?
    
    @IBAction func refresh() {
        delegate?.refresh()
    }
    
}
