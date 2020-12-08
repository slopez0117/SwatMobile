//
//  ThirdViewController.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 4/7/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit
import EventKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var descTableView: UITableView!
    
    var singleEvent = Event()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descTableView.delegate = self
        descTableView.dataSource = self
        
        print("In third view")
        
        //setting up swarthmore logo to be displayed in navigation bar
        let swarthmoreLogo = UIImage(named: "swarthmore_logo")
        navigationItem.titleView = UIImageView(image: swarthmoreLogo)
        navigationItem.titleView?.layer.cornerRadius = 15
        navigationItem.titleView?.layer.masksToBounds = true

        
    }
    //function called when alert is to be displayed to the user
    func createAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            //the following code: if the yes action is tapped, we will add the given event to the built-in ios calendar.
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
                
                if (granted) && (error == nil){
                    print("Granted: \(granted)")
                    print("error: \(String(describing: error))")
                    
                    let event = EKEvent(eventStore: eventStore)
                    event.title = self.singleEvent.title!.htmlStripped.htmlStripped2()
                    event.timeZone = TimeZone(abbreviation: "EST")
                    print("Event timeZone: \(String(describing: event.timeZone))")
                    event.startDate = convertToDate(dateTime: self.singleEvent.startDateTime!)
                    event.endDate = convertToDate(dateTime: self.singleEvent.endDateTime!)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    do{
                        try eventStore.save(event, span: .thisEvent)
                    }catch let error as NSError{
                        print("error: \(error)")
                    }
                    print("Save event")
                    
                    
                }else{
                    print("error: \(String(describing: error))")
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            //if no is tapped, we just simply dismiss the alert
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension String{
    var htmlStripped : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    func htmlStripped2()-> String{
        var newStr: String = self
        var remove: Bool = false //flag to indicate wether to remove chars or not
        let start = newStr.startIndex
        var offSet = 0
        
        for char in newStr{
            
//            print("Char: \(char) at offset: \(offSet)")
            if char == "&"{
                remove = true
            }
            else if char == ";"{
//                let index = newStr.index(start, offsetBy: offSet)
//                newStr.remove(at: index)
//                offSet-=1
                remove = false
            }
            if remove == true{
                let index = newStr.index(start, offsetBy: offSet)
                newStr.remove(at: index)
                offSet -= 1
            }
            offSet+=1
        }
        newStr = newStr.replacingOccurrences(of: ";", with: " ")
        newStr = newStr.replacingOccurrences(of: "/blockquote", with: "")
        newStr = newStr.replacingOccurrences(of: "blockquote", with: "")
        return newStr
    }
}

extension ThirdViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Tapped Description")
        createAlert(title: "Adding Event", message: "Are you sure you want to add this event to your calendar?")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ThirdViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //return 1 since there will only be one row opulated by the event description
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Description", for: indexPath) as! eventTableViewCell
        
        let desc: String = singleEvent.description!.htmlStripped.htmlStripped2()
        
        cell.roundImage()
        cell.cellTextLabel.text = desc
        cell.cellTimeLabel.text = "Tap to add event to your calendar"
        
        return cell
        
    }
}

//function that converts Event object member vars 'startDatetime' and 'endDateTime' into Date objects

func convertToDate(dateTime: String)->Date{
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "EST")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    return formatter.date(from: dateTime)!
}
