//
//  ForecastViewController.swift
//  Final Project
//
//  Created by Andria Kilasonia on 13.02.22.
//

import UIKit

// Dictionary sorts strings, list doesn't
struct ForecastSection {
    let weekday: String
    var forecastCells: [ForecastCellModel]
}

class ForecastViewController: RefreshableViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var forecastData: [ForecastSection] = []

    override func viewDidLoad() {
        dataView = tableView
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCells()
    }
    
    override func refresh() {
        refreshData(dataGetter: WeatherAPI.getForecast)
    }
    
    override func didGetWeatherInfo<DataType>(result: DataType) {
        super.didGetWeatherInfo(result: result)
        
        forecastData = result as! [ForecastSection]
        tableView.reloadData()
    }
    
    private func registerCells() {
        tableView.register(
            UINib(nibName: "ForecastCell", bundle: nil),
            forCellReuseIdentifier: "ForecastCell"
        )
    }
    
}


extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Configure Sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecastData[section].weekday
    }
    
    // Configure Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData[section].forecastCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        let model = forecastData[indexPath.section].forecastCells[indexPath.row]
        
        if let forecastCell = cell as? ForecastCell {
            forecastCell.configure(with: model)
        }
        
        return cell
    }
    
}
