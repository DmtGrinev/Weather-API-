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
    @IBOutlet var cityLabel: UILabel!
    
    
    var netWorkManager = NetWorkManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        temperatureLabel.text = "ºC"
        //        feelingTemperature.text = "Feels like  ºC"
        
        netWorkManager.onComplition = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        netWorkManager.fetchCurrentWeather(forCity: "Tyumen")
    }
    
    
    
    
    @IBAction func seachActionButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) {
            [unowned self] city in
            self.netWorkManager.fetchCurrentWeather(forCity: city)
        }
        
    }
    
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: style)
        alertVC.addTextField { textField in
            let cities = ["San Francisco", "Moscow", "New York", "Stambul", "Viena"]
            textField.placeholder = cities.randomElement()
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
    
    func updateInterfaceWith (weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = "\(weather.temperatureString) Cº"
            self.feelingTemperature.text = "Feels like \(weather.feelsLikeTemperatureString) Cº"
            self.weatherImage.image = UIImage(systemName: weather.systemIconNameString)
        }
        
    }
}




