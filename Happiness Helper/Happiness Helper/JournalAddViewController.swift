//
//  JournalAddViewController.swift
//  Happiness Helper
//
//  Created by Max Nguyen on 8/2/21.
//

import UIKit

class JournalAddViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var questionButton: UIButton!
    var text: String = ""
    var time: Date?
    var questions = ["How did you feel today?","What was something that went well?","What was the most notable part of your day?","Did you feel and express enough gratitude and appreciation for what you have today?","Who or what caused you to feel unhappy in any way today?","What are you looking forward to?","What did you want to do today that you weren’t able to do and why weren’t you able to do it?","What made you feel good today?","What made you feel thankful today?","What’s something that happened today that was different?","What is important to you right now?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    

    @IBAction func onQuestionButtonPressed(_ sender: UIButton) {
        let number = Int.random(in: 0..<questions.count)
        let question = questions[number]
        questions.remove(at: number)
        questionLabel.text = question
        if(questions.count == 0){
            questionButton.isEnabled = false
            questionButton.isHidden = true
        }
        
    }
    @IBAction func onSubmitButtonPressed(_ sender: UIButton) {
        text = textView.text!
        time = Date()
    }
    
}
