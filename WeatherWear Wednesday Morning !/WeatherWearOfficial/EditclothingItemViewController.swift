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
    var clothingItemText = ""
    var warmness: Float = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onSubmitButtonPressed(_ sender: UIButton) {
        clothingItemText = clothingItemTextField.text!
        warmness = warmnessSlider.value
        performSegue(withIdentifier: "editUnwindID", sender: self)
    }
    
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        warmnessLabel.text = "Warmness: \(currentValue)"
    }
    
}
