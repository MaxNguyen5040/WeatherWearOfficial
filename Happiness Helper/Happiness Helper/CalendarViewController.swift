//
//  CalendarViewController.swift
//  Happiness Helper
//
//  Created by Max Nguyen on 8/2/21.
//

import UIKit
import EventKit
import EventKitUI

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EKEventViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addBreakButton: UIBarButtonItem!
    
    var eventList = [Event]()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCalendar()
        
    }
    
    func searchCalendar(){
        let calendars = eventStore.calendars(for: .event)
        eventList = []
        
        for calendar in calendars {
            if calendar.title == "Calendar" {

                let oneDayAgo = NSDate(timeIntervalSinceNow: -1*24*3600)
                let oneDayAfter = NSDate(timeIntervalSinceNow: +1*24*3600)

                let predicate = eventStore.predicateForEvents(withStart: oneDayAgo as Date, end: oneDayAfter as Date, calendars: [calendar])

                let events = eventStore.events(matching: predicate)

                for event in events {
                    let newEvent = Event(title: event.title, start: event.startDate! as NSDate, end: event.endDate! as NSDate)
                    eventList.append(newEvent)
                }
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = eventList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventID", for: indexPath)
        
        cell.textLabel!.font = UIFont(name: "Plain", size: 13)
        cell.detailTextLabel!.font = UIFont(name: "Plain", size: 13)

        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        let startDateString = formatter.string(from: event.start as Date)
        
        cell.textLabel!.text = event.title
        cell.detailTextLabel?.text = "\(startDateString)"
        
        return cell
    }


    @IBAction func onAddButtonPressed(_ sender: UIBarButtonItem) {
        self.searchCalendar()
        self.tableView.reloadData()
        
        eventStore.requestAccess(to: .event) { [weak self] success, error in
            if success, error == nil{
                DispatchQueue.main.async {
                    guard let store = self?.eventStore else{return}
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .short
                    
                    let breaks = self!.findBreakTimes()
                    
                    let newEvent = EKEvent(eventStore: self!.eventStore)
                    if(breaks.count != 0){
                        
                        newEvent.title = breaks.first?.title
                        newEvent.startDate = breaks.first!.start as Date
                        newEvent.endDate = breaks.first!.end as Date
                        
                        let fiveMinutesBefore = Date(timeIntervalSince1970: breaks.first!.start.timeIntervalSince1970 - 300)
                        newEvent.addAlarm(EKAlarm(absoluteDate: fiveMinutesBefore as Date))
                            
                        let eventcontroller = EKEventViewController()
                        eventcontroller.delegate = self
                        eventcontroller.event = newEvent

                        let navigationController = UINavigationController(rootViewController: eventcontroller)
                        self?.present(navigationController, animated: true, completion: nil)
                    }
                    else{
                        self?.addBreakButton.isEnabled = false
                    }
                    
                }

            }
        }
        self.tableView.reloadData()
        
    }
    
    func findBreakTimes() -> [Event]{
        var breakList = ["Journaling break","Walking break","Screen break","Get a snack"]
        var breakEvents = [Event]()
        var lastEvent = eventList.first
        var breakEventTitle = ""
        
        for event in eventList {
            
            if(event.start.timeIntervalSince1970 - lastEvent!.end.timeIntervalSince1970 >= 1800){ //30 minutes
                
                //If breaks were not previously scheduled
                if(breakEvents.count == 0){
                    let index = Int.random(in: 0..<breakList.count)
                    breakEventTitle = breakList[index]
                    breakList.remove(at: index)
                        
                    let endTime = lastEvent!.end.timeIntervalSince1970 + 900
                    let endTimeDate = NSDate(timeIntervalSince1970: TimeInterval(endTime))
                    let newEvent = Event(title: breakEventTitle, start: lastEvent!.end, end: endTimeDate)
                        
                    breakEvents.append(newEvent)
                    
                }
                
                else{
                    //if there was no break within the last 30 minutes
                    if(lastEvent!.end.timeIntervalSince1970 - breakEvents.last!.end.timeIntervalSince1970 >= 3600){
                        if(breakEvents.count == 0){
                            let index = Int.random(in: 0...breakList.count-1)
                            breakEventTitle = breakList[index]
                            breakList.remove(at: index)
                        }
                       
                        let endTime = lastEvent!.end.timeIntervalSince1970 + 900
                        let endTimeDate = NSDate(timeIntervalSince1970: TimeInterval(endTime))
                        let newEvent = Event(title: breakEventTitle, start: lastEvent!.end, end: endTimeDate)
                        
                        breakEvents.append(newEvent)
                    }
                    
                }
            }
            lastEvent = event
        }
        return breakEvents
    }
    
    
    
    func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
        controller.dismiss(animated: true, completion: nil)
        self.searchCalendar()
        self.tableView.reloadData()
    }

    
    
    

}
