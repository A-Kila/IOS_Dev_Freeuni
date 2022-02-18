//
//  RefreshableViewController.swift
//  Final Project
//
//  Created by Andria Kilasonia on 16.02.22.
//

import UIKit
import CoreLocation

class RefreshableViewController: UIViewController, ErrorScreenViewDelegate {
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blur: UIVisualEffectView!
    @IBOutlet var errorScreenView: ErrorScreenView!
    
    var dataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorScreenView.delegate = self
        
        drawErrorScreen()
        refresh()
    }
    
    func drawErrorScreen() {
        loader.stopAnimating()
        blur.isHidden = true
        dataView.isHidden = true
        errorScreenView.isHidden = false
    }
    
    @IBAction func refresh() {
        preconditionFailure("This method needs to be overridden")
    }
    
    func refreshData<DataType>(
        dataGetter: @escaping (Double?, Double?, @escaping (DataType?) -> Void) -> Void
    ) {
        loader.startAnimating()
        blur.isHidden = false
        
        DispatchQueue.global().async {
            while (LocationManager.shared.status == .notDetermined) {}
            
            
            DispatchQueue.main.async {
                self.getWeatherInfo(dataGetter: dataGetter)
            }
        }
    }
    
    func getWeatherInfo<DataType>(dataGetter: (Double?, Double?, @escaping (DataType?) -> Void) -> Void) {
        let latitude = LocationManager.shared.latitude
        let longitude = LocationManager.shared.longitude
        
        dataGetter(latitude, longitude) { [weak self] result in
            DispatchQueue.main.async {
                if let result = result {
                    self?.didGetWeatherInfo(result: result)
                    return
                }
                self?.drawErrorScreen()
            }
        }
    }
    
    func didGetWeatherInfo<DataType>(result:  DataType) {
        dataView.isHidden = false
        errorScreenView.isHidden = true
        blur.isHidden = true
        loader.stopAnimating()
    }
    
}
