//
//  BasicHeader.swift
//  Project_4
//
//  Created by Andria Kilasonia on 30.12.21.
//

import UIKit

struct BasicHeaderModel {
    var title: String
}

class BasicHeader: UITableViewHeaderFooterView {
    
    @IBOutlet var label: UILabel!
    
    private var model: BasicHeaderModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: BasicHeaderModel) {
        label.text = model.title
    }

}
