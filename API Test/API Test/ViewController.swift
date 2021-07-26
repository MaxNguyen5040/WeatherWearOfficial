//
//  ViewController.swift
//  API Test
//
//  Created by Jane Bazzell on 7/25/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = "api.openweathermap.org/data/2.5/weather?q=Chicago&appid=63e987a6280c742d8d68f214771ffaba"
        getData(from: url)
    }
    
    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            guard let json = result else {
                return
            }
            
            print(json.status)
            print(json.results)
            print(json.results.temp)
            print(json.results.feels_like)
        })
        task.resume()

    }
}


struct Response: Codable {
    let results: MyResult
    let status: String
}

struct MyResult: Codable {
    let temp: Int
    let feels_like: Int
    
}
