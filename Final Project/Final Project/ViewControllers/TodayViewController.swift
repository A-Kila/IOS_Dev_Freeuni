//
//  TodayViewController.swift
//  Final Project
//
//  Created by Andria Kilasonia on 13.02.22.
//

import UIKit
import SDWebImage

struct TodayData {
    let imagePath: String
    let region: String
    let temperature: Int
    let weather: String
    let cloudPercentage: Int
    let humidityPercentage: Int
    let pressure: Double
    let windSpeed: Double
    let windDirection: String
}

class TodayViewController: RefreshableViewController {
    
    @IBOutlet var todayView: UIStackView!
    
    // Upper/Left half
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    
    // Down/Right half
    @IBOutlet var cloudLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    override func viewDidLoad() {
        dataView = todayView
        
        super.viewDidLoad()
    }
    
    override func refresh() {
        refreshData(dataGetter: WeatherAPI.getToday)
    }
    
    override func didGetWeatherInfo<DataType>(result: DataType) {
        super.didGetWeatherInfo(result: result)
        let todayData = result as! TodayData
        
        weatherIcon.sd_setImage(with: URL(string: todayData.imagePath))
        locationLabel.text = todayData.region
        temperatureLabel.text = "\(todayData.temperature)°C | \(todayData.weather)"
        
        cloudLabel.text = "\(todayData.cloudPercentage) %"
        humidityLabel.text = "\(todayData.humidityPercentage) mm"
        pressureLabel.text = "\(todayData.pressure) hPa"
        windLabel.text = "\(todayData.windSpeed) km/h"
        directionLabel.text = todayData.windDirection
    }

}
