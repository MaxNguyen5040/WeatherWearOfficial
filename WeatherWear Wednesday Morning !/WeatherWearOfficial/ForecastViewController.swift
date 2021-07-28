//
//  ForecastViewController.swift
//  WeatherWearOfficial
//
//  Created by Max Nguyen on 7/27/21.
//
import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    @IBOutlet var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
        
        let lat = manager.location!.coordinate.latitude
        let lon = manager.location!.coordinate.longitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,daily,current,alerts&units=imperial&appid=89652d405a68b80049a6f3fa42909a1a"
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
            self.updateDisplay(hourly: json.hourly)
        })
        
        task.resume()
        
    }
    
    func updateDisplay(hourly: [Hourly]){
        DispatchQueue.main.async {
            self.displayLabel.text = "POP: \(hourly[0].pop)"
            
        }
        
    }
    
    
    struct Response: Codable {
        let lon: Double
        let lat: Double
        let hourly: [Hourly]
    }
    
    struct Hourly: Codable {
        let temp: Double
        let feels_like: Double
        let weather: [Weather]
        let pop: Double


    }
    
    struct Weather: Codable{
        let main: String
        let description: String
        let icon: String
    }
    
    

/*
     
""hourly":[{
     "temp":82.27,
     "feels_like":84.63,
     "weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],
     "pop":0},
     */
    

}
