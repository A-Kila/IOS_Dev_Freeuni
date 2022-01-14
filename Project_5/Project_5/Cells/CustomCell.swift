//
//  CustomCell.swift
//  Project_5
//
//  Created by Andria Kilasonia on 13.01.22.
//

import UIKit

struct CustomCellModel {
    var name: String
    var phoneNumber: String
}

class CustomCell: UICollectionViewCell {
    
    @IBOutlet var initialsView: UIView!
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width / 10
        layer.borderWidth = 1
    }
    
    func configure(with model: CustomCellModel) {
        let nameArray = model.name.components(separatedBy: " ")
        let firstName = nameArray.first
        var initials = firstName!.first!.description.uppercased()
        
        if nameArray.count > 1 {
            let lastName = nameArray.last
            initials += lastName!.first!.description.uppercased()
        }
        
        initialsLabel.text = initials
        phoneLabel.text = model.phoneNumber
        nameLabel.text = firstName
    }
    
}


class RoundView: UIView {
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.width / 2
    }
    
}
