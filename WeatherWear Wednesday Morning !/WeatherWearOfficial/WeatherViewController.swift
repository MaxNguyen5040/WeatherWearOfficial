//
//  WeatherViewController.swift
//  WeatherWearOfficial
//
//  Created by Max Nguyen on 7/26/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var recommendationLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var cloudPercentLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var uviLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            //Do any additional setup after loading the view.
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.delegate = self
            manager.startUpdatingLocation()
            
           let lat = manager.location!.coordinate.latitude
            let lon = manager.location!.coordinate.longitude

            let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,daily,alerts,hourly&units=imperial&appid=89652d405a68b80049a6f3fa42909a1a"
            getDataFromURL(from: url)
            
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first{
                manager.stopUpdatingLocation()
                }
        }
        
        private func getDataFromURL(from url:String){
            let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
                guard let data = data, error == nil else{ //make sure we have data and there are no errors
                    print("something went wrong")
                    return
                }
                
                //have data
                var result: Response?
                do{
                    result = try JSONDecoder().decode(Response.self, from: data) //getting api call
                }
                catch{
                    print("ERROR: \(String(describing: error))")
                }
                
                guard let json = result else {
                    return
                }
                
                //json stuff here
                self.updateDisplay(current: json.current, timezone: json.timezone, weather: json.current.weather)
            })
            
            task.resume()
            
        }
        
        func updateDisplay(current: Current, timezone: String, weather: [Weather]){
            DispatchQueue.main.async {
                self.temperatureLabel.text = "Current: \(current.temp.description)°"
                self.displayLabel.text = "Timezone: \(timezone.description)"
                self.feelsLikeLabel.text = "Feels like: \(current.feels_like)°"
                self.imageView.image = UIImage(named: weather[0].icon)
                self.descriptionLabel.text = weather[0].description.capitalized
                self.mainLabel.text = weather[0].main
                self.windSpeedLabel.text = "Wind speed: \(current.wind_speed.description) miles per hour"
                self.cloudPercentLabel.text = "Percent of cloudy sky: \(current.clouds.description)%"
                self.uviLabel.text = "Uvi index: \(current.uvi.description)"
                self.humidityLabel.text = "Humidity: \(current.humidity.description)%"
                
                
                
            }
        }
        
        
        struct Response: Codable {
            let timezone: String
            let current: Current
        }
        
        struct Current: Codable {
            let temp: Double
            let feels_like: Double
            let humidity: Int
            let uvi: Double
            let wind_speed: Double
            let clouds: Int
            let weather: [Weather]
            
        }
        
        struct Weather: Codable{
            let main: String
            let description: String
            let icon: String

        }
        


        

    /*
         
         {
            "timezone":"America/Chicago",
            "current":{
                "temp":81.57,
                "feels_like":84.16,
                "humidity":62,
                "uvi":6.87,
                "clouds":27,
                "wind_speed":1.99,
                "weather":[{
                    "main":"Clouds",
                    "description":"scattered clouds",
                    "icon":"03d"}]
         
                }
         }
         */

    }
