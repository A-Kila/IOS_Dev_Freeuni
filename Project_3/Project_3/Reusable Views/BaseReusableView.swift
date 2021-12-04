//
//  BaseReusableView.swift
//  Project_3
//
//  Created by Andria Kilasonia on 04.12.21.
//

import UIKit

class BaseReusableView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    var nibName: String {
        return String(describing: Self.self)
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setup()
    }
    
    func commonInit() {
        let bundle = Bundle(for: BaseReusableView.self)
        bundle.loadNibNamed(nibName, owner: self, options: nil)
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
    }
    
    func setup() {}
    
}
