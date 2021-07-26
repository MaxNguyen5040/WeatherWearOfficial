//
//  ViewController.swift
//  WeatherWearOfficial
//
//  Created by Max Nguyen on 7/22/21.
//  41.799688 -88.111088

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=41.799688&lon=-88.111088&exclude=minutely,hourly,daily,alerts&units=imperial&appid=89652d405a68b80049a6f3fa42909a1a"
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
                print("failed to convert: \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            print("Lat: \(json.lat)")
            print("Lon: \(json.lon)")
            print("Timezone: \(json.timezone)")
            print("Temp: \(json.current.temp.description)")
            print("Feels like: \(json.current.feels_like.description)")

        })
        
        task.resume()
        
    }
    
    struct Response: Codable {
        let lat: Double
        let lon: Double
        let timezone: String
        let current: MyResult
    }
    
    struct MyResult: Codable {
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        
    }
    

    /*
    {
     "lat":41.7997,
     "lon":-88.1111,
     "timezone":"America/Chicago",
     "timezone_offset":-18000,
     "current": {
        "dt":1627266816,
        "sunrise":1627209584,
        "sunset":1627262274,
        "temp":75.72,
        "feels_like":76.14,
        "pressure":1014,
        "humidity":67,
        "dew_point":63.99,
        "uvi":0,
        "clouds":1,
        "visibility":10000,
        "wind_speed":1.01,
        "wind_deg":0,
        "wind_gust":1.99,
        "weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}]
     }
    }
     */
 
}

