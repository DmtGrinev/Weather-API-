//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry Grinev on 16.11.2020.
//

import UIKit

@IBDesignable class ViewController: UIViewController {
    
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var feelingTemperature: UILabel!
    @IBOutlet var seachButton: UIButton!
    
    
    var netWorkManager = NetWorkManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatureLabel.text = "ºC"
        feelingTemperature.text = "Feels like  ºC"
        
        netWorkManager.fetchCurrentWeather(forCity: "London")
    }
    
    
    
    
    @IBAction func seachActionButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { city in
            self.netWorkManager.fetchCurrentWeather(forCity: city)
        }
    }
    
    
        func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: style)
            alertVC.addTextField { tf in
                let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
                tf.placeholder = cities.randomElement()
            }
            let search = UIAlertAction(title: "Search", style: .default) { action in
                let textField = alertVC.textFields?.first
                guard let cityName = textField?.text else { return }
                if cityName != "" {
                    let city = cityName.split(separator: " ").joined(separator: "%20")
                    completionHandler(city)
                }
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertVC.addAction(search)
            alertVC.addAction(cancel)
            present(alertVC, animated: true, completion: nil)
        }
    }
    



