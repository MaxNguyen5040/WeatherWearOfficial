//
//  EditclothingItemViewController.swift
//  WeatherWearOfficial
//
//  Created by Jane Bazzell on 7/28/21.
//

import UIKit

class EditclothingItemViewController: UIViewController {

    @IBOutlet var clothingItemTextField: UITextField!
    @IBOutlet var warmnessSlider: UISlider!
    @IBOutlet var warmnessLabel: UILabel!
    
    var index = 0
    
    var clothingItemText = ""
    var warmness: Float = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        clothingItemTextField.text = clothingItemText
    }
    

    @IBAction func onSubmitButtonPressed(_ sender: UIButton) {
        clothingItemText = clothingItemTextField.text!
        warmness = warmnessSlider.value
        
        let item = ClothingItem(name: clothingItemText, warmness: Int(warmness))
        ClothingRack.rack.insert(item, at: index)
        
        performSegue(withIdentifier: "editUnwindID", sender: self)
        
    }
    
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        warmnessLabel.text = "Warmness: \(currentValue)"
    }
    
}
