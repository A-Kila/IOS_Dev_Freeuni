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
    
    // Middle line
    @IBOutlet var horizontalLine: UIView!
    @IBOutlet var verticalLine: UIView!
    
    // Down/Right half
    @IBOutlet var cloudLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    override func viewDidLoad() {
        dataView = todayView
        horizontalLine.isHidden = UIDevice.current.orientation.isLandscape
        verticalLine.isHidden = UIDevice.current.orientation.isPortrait
        
        super.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        horizontalLine.isHidden = UIDevice.current.orientation.isLandscape
        verticalLine.isHidden = UIDevice.current.orientation.isPortrait
        
        super.viewWillTransition(to: size, with: coordinator)
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
    
    @IBAction func share() {
        if errorScreenView.isHidden,
            let location = locationLabel.text,
            let temperature = temperatureLabel.text
        {
            let shareString = "\(location) - \(temperature)"
            
            let activityControllerView = UIActivityViewController(
                activityItems: [shareString],
                applicationActivities: nil
            )
            
            present(activityControllerView, animated: true)
        }
    }

}
