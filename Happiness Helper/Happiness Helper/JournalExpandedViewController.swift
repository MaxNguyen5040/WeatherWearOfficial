//
//  JournalExpandedViewController.swift
//  Happiness Helper
//
//  Created by Max Nguyen on 8/2/21.
//

import UIKit

class JournalExpandedViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var timeLabel: UILabel!
    
    var text = ""
    var time = Date()
    var index = 0
    var entry = Entry(text: "", time: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long

        let dateString = formatter.string(from: entry.time)
        
        textView.text = entry.text
        timeLabel.text = dateString
        
    }
    
    
    @IBAction func onSubmitButtonPressed(_ sender: UIButton) {
        text = textView.text        
    }
    


}
