//
//  AddClothingItemViewController.swift
//  WeatherWearOfficial
//
//  Created by Jane Bazzell on 7/27/21.
//

import UIKit

class AddClothingItemViewController: UIViewController {
    
    @IBOutlet var clothingItemTextField: UITextField!
    @IBOutlet var warmnessSlider: UISlider!
    @IBOutlet var warmnessLabel: UILabel!
    var clothingItemText = ""
    var warmness: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSubmitButtonPressed(_ sender: Any) {
        clothingItemText = clothingItemTextField.text!
        warmness = warmnessSlider.value
        let item = ClothingItem(name: clothingItemText, warmness: Int(warmness))
        ClothingRack.rack.append(item)
        performSegue(withIdentifier: "unwindID", sender: self)
    }
    
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        warmnessLabel.text = "Warmness: \(currentValue)"
    }
}
