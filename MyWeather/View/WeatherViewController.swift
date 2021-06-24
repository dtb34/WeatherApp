//
//  ViewController.swift
//  MyWeather
//
//  Created by Darrell Bowdon on 6/9/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var tempImage: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    var dailyModels = [WeatherViewModel]()
    var hourlyModels = [WeatherViewModel]()
    let locationManager = CLLocationManager()
    
    var currentWeather: Current?
    
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)

        table.dataSource = self
        table.delegate = self
        
        print("hi")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    // Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("in setup")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("in locationmanager")
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=618a80517bdb80bddfb0b24cc2d82a62&units=imperial&lat=\(lat)&lon=\(long)"
        let weatherDaysURL = "https://api.openweathermap.org/data/2.5/onecall?appid=618a80517bdb80bddfb0b24cc2d82a62&units=imperial&lat=\(lat)&lon=\(long)"
        let locationName = "http://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(long)&limit=1&appid=618a80517bdb80bddfb0b24cc2d82a62"
        
        
        URLSession.shared.dataTask(with: URL(string: weatherDaysURL)!, completionHandler: { data, response, error in
            // Validation
            guard let data = data, error == nil else {
                print("something went wrong")
                print("data is \(data)")
                return
            }
            
            // Convert data to models/some object
            var json: DailyWeather?
            
            do {
                json = try JSONDecoder().decode(DailyWeather.self, from: data)
            }
            catch {
                print("error: \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            let daily = result.daily
            self.currentWeather = result.current
            
            let hourly = result.hourly
            
            for day in daily {
                self.dailyModels.append(WeatherViewModel(temp_min: day.temp.min, temp_max: day.temp.max, dt: day.dt, temp: day.temp.day, conditionId: day.weather.first?.id ?? -1))
            }
            
            for hour in hourly {
                self.hourlyModels.append(WeatherViewModel(temp_min: 0.0, temp_max: 0.0, dt: hour.dt, temp: hour.temp, conditionId: hour.weather.first?.id ?? -1))
            }
            
            guard let currentWeather = self.currentWeather else {
                return
            }
            
            var conditionName: String {
                switch currentWeather.weather.first?.id ?? -1 {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
            }
            
            // Update user interface
            DispatchQueue.main.async {
                self.table.reloadData()
                self.locationLabel.text = "Current Location"
                self.tempLabel.text = "\(Int(currentWeather.temp))°"
                self.tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
                self.summaryLabel.text = currentWeather.weather.first?.description.capitalized
                self.tempImage.image = UIImage(systemName: conditionName)
            }
            
        }).resume()
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourlyModels)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: dailyModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

//        URLSession.shared.dataTask(with: URL(string: locationName)!, completionHandler: { data, response, error in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            var locationJson: [LocationDataX?]
//
//            do {
//                locationJson = try JSONDecoder().decode([LocationDataX].self, from: data)
//            }
//            catch {
//                print(error)
//            }
//
//            print(locationJson)
//            DispatchQueue.main.async {
//                self.locationLabel.text = locationJson.first.
//            }
//
//        }).resume()
