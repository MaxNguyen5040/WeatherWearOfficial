//
//  JournalViewController.swift
//  Happiness Helper
//
//  Created by Max Nguyen on 8/2/21.
//

import UIKit

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var entries = [Entry]()
    var editEntry = ""
    var editTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let entry1 = Entry(text: "I went to the park today.\n I saw a dog running around, and the owner chasing it.\n The Trees were really green, and the sun was shining!", time: Date(timeIntervalSince1970: 1627684368))
        let entry2 = Entry(text: "Just got back from my walk. Going to make dinner now! I have my ingredients prepared.", time: Date(timeIntervalSince1970: 1627686030))
        let entry3 = Entry(text: "Just woke up! I have a ton of energy.\n I wonder what I'll have to work on today.\n Fluffy is a little bit agressive today.", time: Date(timeIntervalSince1970: 1627732832))
        let entry4 = Entry(text: "Lunch break! I have a sandwhich and chips. I just had a big presentation, but I thought it went pretty well.", time: Date(timeIntervalSince1970: 1627708270))
        let entry6 = Entry(text: "My Birthday! Bob came over and made me breakfast. ", time: Date(timeIntervalSince1970: 1627821910))
        let entry7 = Entry(text: "My family is here! We just played a game of blackjack, and are currently waiting around for the food to arrive.", time: Date(timeIntervalSince1970: 1627828391))
        let entry5 = Entry(text: "Went for a run today and felt great.\nMy mile time was 8:30.\n I’m hoping I can continue to do this in my spare time. \nI also saw a really cute squirrel running alongside me for a bit which was cool.", time: Date(timeIntervalSince1970: 1627910590))
        let entry8 = Entry(text: "The most notable part of my day was riding the subway oddly enough. \nThe buzzing sound is relaxing for me and I love to see the variety of people there and the different stages of life everyone is at. \nSome are poor, some are rich, some are young, some are old.\n It’s a really nice place to slow down and think.\n", time: Date(timeIntervalSince1970: 1627684391))

        entries = [entry1,entry2,entry3,entry4,entry5,entry6,entry7,entry8]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryID", for: indexPath)
        
        cell.textLabel!.font = UIFont(name: "Plain", size: 15)
        cell.detailTextLabel!.font = UIFont(name: "Plain", size: 15)

        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let dateString = formatter.string(from: entry.time)
        
        cell.textLabel!.text = entry.text
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    @IBAction func unwindToJournal(_ unwindSegue: UIStoryboardSegue) { //adding
        let sourceViewController = unwindSegue.source as! JournalAddViewController
        let newEntry = Entry(text: sourceViewController.text, time: sourceViewController.time!)
        entries.append(newEntry)
        tableView.reloadData()
        
    }
    
    @IBAction func unwindToEditJournal(_ unwindSegue: UIStoryboardSegue) { //editing
        let sourceViewController = unwindSegue.source as! JournalExpandedViewController
        // Use data from the view controller which initiated the unwind segue
        let path = sourceViewController.index
        let newEntry = Entry(text: sourceViewController.text, time: sourceViewController.time)
        entries[path] = newEntry
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "expandID"){
            let jevc = segue.destination as! JournalExpandedViewController
            let indexPath = tableView.indexPathForSelectedRow
            jevc.entry = entries[indexPath!.row]
            jevc.index = indexPath!.row
        }
        
    
}
}

