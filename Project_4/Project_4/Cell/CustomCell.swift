//
//  CustomCell.swift
//  Project_4
//
//  Created by Andria Kilasonia on 29.12.21.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func toggleFavorite(_ firstName: String, _ lastName: String?)
}

struct CustomCellModel {
    var firstName: String
    var lastName: String?
    var phoneNumber: String
    var isFavorite = false
    weak var delegate: CustomCellDelegate!
}

class CustomCell: UITableViewCell {
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    @IBOutlet var starButton: UIButton!
    
    private var model: CustomCellModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func toggleFavorite() {
        model.isFavorite.toggle()
        model.delegate.toggleFavorite(model.firstName, model.lastName)
        setStarButtonImage()
    }
    
    func configure(with model: CustomCellModel) {
        self.model = model
        firstNameLabel.text = model.firstName
        lastNameLabel.text = model.lastName
        setStarButtonImage()
    }
    
    private func setStarButtonImage() {
        let imageString = "star\(model.isFavorite ? ".fill" : "")"
        starButton.setImage(UIImage(systemName: imageString), for: .normal)
    }
    
}
