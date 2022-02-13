//
//  ForecastViewController.swift
//  Final Project
//
//  Created by Andria Kilasonia on 13.02.22.
//

import UIKit

class ForecastViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCells()
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "MONDAY"
    }
    
    // Configure Cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        
        if let forecastCell = cell as? ForecastCell {
            forecastCell.configure(with: ForecastCellModel(
                time: "22:00",
                weather: "This Shit is Poppin'",
                temperature: 25
            ))
        }
        
        return cell
    }
    
}
