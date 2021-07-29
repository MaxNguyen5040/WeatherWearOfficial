//
//  ForecastViewController.swift
//  WeatherWearOfficial
//
//  Created by Max Nguyen on 7/27/21.
//
import UIKit
import CoreLocation

class ForecastViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var whenAreYouGoingLabel: UILabel!
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label6: UILabel!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label7: UILabel!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var label8: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var displayLabel: UILabel!
    
    let manager = CLLocationManager()
    var now = 0.0
    var fourHours = 0.0
    var eightHours = 0.0
    var twelveHours = 0.0
    
    var nowPop = 0.0
    var fourHoursPop = 0.0
    var eightHoursPop = 0.0
    var twelveHoursPop = 0.0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        spinner.startAnimating()
        whenAreYouGoingLabel.isHidden = true
        segmentedControl.isHidden = true
        
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
    
    func convertToReadableTime(unix: Double) -> String{
        let date = NSDate(timeIntervalSince1970: unix)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let datetime = formatter.string(from: date as Date)
        return datetime.description
        
    }
    
    func updateDisplay(hourly: [Hourly]){
        DispatchQueue.main.async {
            self.spinner.hidesWhenStopped = true
            self.spinner.stopAnimating()
            self.segmentedControl.isHidden = false
            self.whenAreYouGoingLabel.isHidden = false
            
            self.label5.text = self.convertToReadableTime(unix: hourly[0].dt)
            self.label6.text = self.convertToReadableTime(unix: hourly[4].dt)
            self.label7.text = self.convertToReadableTime(unix: hourly[8].dt)
            self.label8.text = self.convertToReadableTime(unix: hourly[12].dt)
            
            self.now = hourly[0].temp
            self.fourHours = hourly[4].temp
            self.eightHours = hourly[8].temp
            self.twelveHours = hourly[12].temp
            
            self.nowPop = hourly[0].pop
            self.fourHoursPop = hourly[4].pop
            self.eightHoursPop = hourly[8].pop
            self.twelveHoursPop = hourly[12].pop

            var text1 = self.convertToReadableTime(unix: hourly[0].dt)
            text1 = self.formatTime(text: text1)
            self.segmentedControl.setTitle(text1, forSegmentAt: 0)
            
            var text2 = self.convertToReadableTime(unix: hourly[4].dt)
            text2 = self.formatTime(text: text2)
            self.segmentedControl.setTitle(text2, forSegmentAt: 1)
            
            var text3 = self.convertToReadableTime(unix: hourly[8].dt)
            text3 = self.formatTime(text: text3)
            self.segmentedControl.setTitle(text3, forSegmentAt: 2)
            
            var text4 = self.convertToReadableTime(unix: hourly[12].dt)
            text4 = self.formatTime(text: text4)
            self.segmentedControl.setTitle(text4, forSegmentAt: 3)
            
            self.imageView1.image = UIImage(named: hourly[0].weather[0].icon)
            self.imageView2.image = UIImage(named: hourly[4].weather[0].icon)
            self.imageView3.image = UIImage(named: hourly[8].weather[0].icon)
            self.imageView4.image = UIImage(named: hourly[12].weather[0].icon)
            
            let rain1: String = String(format: "%.2f", hourly[0].pop)
            let doubleRain1 = Double(rain1)! * 100
            
            let rain2: String = String(format: "%.2f", hourly[4].pop)
            let doubleRain2 = Double(rain2)! * 100

            let rain3: String = String(format: "%.2f", hourly[8].pop)
            let doubleRain3 = Double(rain3)! * 100

            let rain4: String = String(format: "%.2f", hourly[12].pop)
            let doubleRain4 = Double(rain4)! * 100
            
            self.label1.text = "Temperature: \(hourly[0].temp)°\nWeather conditions: \(hourly[0].weather[0].description.capitalized)\nChance of rain: \(doubleRain1.description)%"
            self.label2.text = "Temperature: \(hourly[4].temp)°\nWeather conditions: \(hourly[4].weather[0].description.capitalized)\nChance of rain: \(doubleRain2.description)%"
            self.label3.text = "Temperature: \(hourly[8].temp)°\nWeather conditions: \(hourly[8].weather[0].description.capitalized)\nChance of rain: \(doubleRain3.description)%"
            self.label4.text = "Temperature: \(hourly[12].temp)°\nWeather conditions: \(hourly[12].weather[0].description.capitalized)\nChance of rain: \(doubleRain4.description)%"
            
        }
        
    }
    
    func formatTime(text: String) -> String{
        var textEdit = text
        textEdit = textEdit.replacingOccurrences(of: "7/28/21, ", with: "", options: NSString.CompareOptions.literal, range: nil)
        textEdit = textEdit.replacingOccurrences(of: "7/29/21, ", with: "", options: NSString.CompareOptions.literal, range: nil)
        textEdit = textEdit.replacingOccurrences(of: "7/30/21, ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return textEdit
    }
    
    func randomSearch(searchValue: Int) -> String{
        var found = false
        var Items = [ClothingItem]()
        
        for item in ClothingRack.rack {
            if(item.warmness == searchValue){
                Items.append(item)
                found = true
            }
        }
        
        if found == false{
            return "Go buy some new clothes!"
        }
        else{
            let item = Items.randomElement()
            return "You should wear a \(item!.name) at this time."
        }
    }
    
    func whatToSearch(weather: Double) -> Int{
        if(weather >= 85){
            return 1
            }
        else if(weather >= 70 ){
            return 2
        }
        else if(weather >= 60 ){
            return 3
        }
        else if(weather >= 50 ){
            return 4
        }
        else if(weather >= 40 ){
            return 5
        }
        else if(weather >= 30 ){
            return 6
        }
        else if(weather >= 20 ){
            return 7
        }
        else if(weather >= 10 ){
            return 8
        }
        else if(weather >= 0 ){
            return 9
        }
        else{
            return 10
        }
    }
    
    @IBAction func onSegmentedControlPressed(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0{
            displayLabel.text = randomSearch(searchValue: whatToSearch(weather: now))
            if(nowPop > 0.4){
                displayLabel.text! += " Bring an umbrella!"
            }
        }
        else if index == 1{
            displayLabel.text = randomSearch(searchValue: whatToSearch(weather: fourHours))
            if(fourHoursPop > 0.4){
                displayLabel.text! += " Bring an umbrella!"
            }
        }
        else if index == 2{
            displayLabel.text = randomSearch(searchValue: whatToSearch(weather: eightHours))
            if(eightHoursPop > 0.4){
                displayLabel.text! += " Bring an umbrella!"
            }
        }
        else{ //3
            displayLabel.text = randomSearch(searchValue: whatToSearch(weather: twelveHours))
            if(twelveHoursPop > 0.4){
                displayLabel.text! += " Bring an umbrella!"
            }
        }
    }
    
    struct Response: Codable {
        let hourly: [Hourly]
    }
    
    struct Hourly: Codable {
        let dt: Double
        let temp: Double
        let weather: [Weather]
        let pop: Double


    }
    
    struct Weather: Codable{
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


