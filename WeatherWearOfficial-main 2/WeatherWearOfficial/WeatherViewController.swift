//
//  WeatherViewController.swift
//  WeatherWearOfficial
//
//  Created by Max Nguyen on 7/26/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=41.799688&lon=-88.111088&exclude=minutely,hourly,alerts&units=imperial&appid=89652d405a68b80049a6f3fa42909a1a"
        getDataFromURL(from: url)
        
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
            self.updateDisplay(current: json.current, timezone: json.timezone, weather: json.current.weather, daily: json.daily)
        })
        
        task.resume()
        
    }
    
    func updateDisplay(current: Current, timezone: String, weather: [Weather], daily: [Daily]){
        DispatchQueue.main.async {
            let dailyArray = Array(daily)
            let tempArray = Array(arrayLiteral: daily[0])
            self.displayLabel.text = "\(tempArray.description)"
            
        }
    }
    
    
    struct Response: Codable {
        let timezone: String
        let current: Current
        let daily: [Daily]
//        let alerts: [Alert]
    }
    
    struct Current: Codable {
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let weather: [Weather]
        
    }
    
    struct Weather: Codable{
        let main: String
        let description: String

    }
    
//    struct Alert: Codable {
//        let event: String
//
//    }

    struct Daily: Codable {
        let temp: Temp
    }
    
    struct Temp: Codable {
        let day: Double
        let night: Double
        let eve: Double
        let morn: Double
        let min: Double
        let max: Double
    }
    
     

}
