//
//  ForecastCell.swift
//  Final Project
//
//  Created by Andria Kilasonia on 13.02.22.
//

import UIKit

struct ForecastCellModel {
    var imagePath: String? = nil
    var time: String
    var weather: String
    var temperature: Int
}

class ForecastCell: UITableViewCell {
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var time: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model: ForecastCellModel) {
        if model.imagePath != nil {
            weatherImage.image = UIImage.init(named: model.imagePath!)
        }
        time.text = model.time
        weather.text = model.weather
        temperature.text = "\(model.temperature)°C"
    }
    
}
