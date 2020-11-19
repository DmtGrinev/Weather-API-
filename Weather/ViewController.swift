//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry Grinev on 16.11.2020.
//

import UIKit
import CoreLocation

@IBDesignable class ViewController: UIViewController {
    
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var feelingTemperature: UILabel!
    @IBOutlet var seachButton: UIButton!
    @IBOutlet var cityLabel: UILabel!
    
    
    var netWorkManager = NetWorkManager()
    lazy var locationManager: CLLocationManager = {
        let locManager = CLLocationManager ()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locManager.requestWhenInUseAuthorization()
        return locManager
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        netWorkManager.onComplition = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterfaceWith(weather: currentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    
    
    
    @IBAction func seachActionButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) {
            [unowned self] city in
            self.netWorkManager.fetchCurrentWeather(forRequestType: .cityName(city: city))
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


// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude  = location.coordinate.longitude
        
        netWorkManager.fetchCurrentWeather(forRequestType:
                                            .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

