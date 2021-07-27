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
    


    

/*
     
"daily":[{
    "temp":{"day":81.18,"min":69.67,"max":84.83,"night":72.82,"eve":82.44,"morn":73.38},
    "feels_like":{"day":83.3,"night":74.03,"eve":86.56,"morn":73.76},
    "weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}]
    },
     
    {"temp":{"day":84.85,"min":69.19,"max":86.77,"night":71.01,"eve":85.21,"morn":69.19},
    "feels_like":{"day":92.35,"night":72.37,"eve":94.8,"morn":70.36},
    "weather":[{"id":502,"main":"Rain","description":"heavy intensity rain","icon":"10d"}]
    },
     
    {"temp":{"day":83.77,"min":67.24,"max":86.54,"night":69.62,"eve":80.78,"morn":70.84},
    "feels_like":{"day":90.61,"night":70.47,"eve":86.49,"morn":72.28},
    "weather":[{"id":502,"main":"Rain","description":"heavy intensity rain","icon":"10d"}]
    },
     
     
    {"temp":{"day":78.96,"min":66.18,"max":80.37,"night":68,"eve":74.66,"morn":66.96},
    "feels_like":{"day":78.96,"night":67.55,"eve":74.88,"morn":67.59},
    "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],
    },
     
    {"temp":{"day":79.97,"min":63.5,"max":80.96,"night":68.7,"eve":75.42,"morn":65.16},
    "feels_like":{"day":79.97,"night":69.75,"eve":76.6,"morn":65.52},
    "weather":[{"id":501,"main":"Rain","description":"moderate rain","icon":"10d"}],
    },
     
    {"temp":{"day":72.61,"min":60.87,"max":72.81,"night":60.87,"eve":67.12,"morn":62.67},
    "feels_like":{"day":71.69,"night":59.86,"eve":66.49,"morn":62.31},
    "weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],
    },
     
    {"temp":{"day":66.34,"min":57.74,"max":66.97,"night":58.62,"eve":64.9,"morn":59.47},
    "feels_like":{"day":65.79,"night":57.24,"eve":64.15,"morn":58.73},
    "weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],
    },
     
    {"temp":{"day":74.37,"min":54.63,"max":74.37,"night":60.96,"eve":67.73,"morn":55.92},
    "feels_like":{"day":73.53,"night":60.75,"eve":67.41,"morn":54.7},
    "weather":[{"id":500,"main":"Rain","description":"light rain","icon":"10d"}],
    }]
     
}
     */

    

}
