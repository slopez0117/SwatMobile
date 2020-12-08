//
//  SecondViewController.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 3/31/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    //initializing an array of events
    
    //this ib outlet allows for us to programmatically access and modify our tableView object containes
    //in our story board
    @IBOutlet weak var dayEvents: UITableView!
    
    //text field object for letting the user choose the date
    @IBOutlet weak var dateTxt: UITextField!
    
    //buttons to naviate through monthly event data
    @IBOutlet weak var nextBttn: UIButton!
    @IBOutlet weak var prevBttn: UIButton!
    @IBOutlet weak var eventActivitySpinner: UIActivityIndicatorView!
    
    //creating a date slide down menu object
    let datePicker = UIDatePicker()
    
    //array containing all of the events for the current month. Populated by json parser in ViewController.swift
    var eventsArray =  [Event]()
    
    //subset array of eventsArray containing all of the events for the selected day. Will be populated at runtime in this view controller
    var dayEventsArray = [Event]()
    
    //boolean flag to indicate when json parser is finished
    var doneParsing:Bool = false
    
    //default date that is displayed when the view is initially displayed
    var defaultDate:Date = Date()
    
    //function that parses a GET http json request and loads the parsed data into struct Event objects
    func parseEventJSON(){
        let init_url = createURLmonth()
        print("URL containing event data en JSON format: \(init_url)")
        
        guard let url = URL(string: init_url) else { return }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with:url){ (data, response, error) in
            //check for errors
            if error == nil && data != nil{
        
                //parse JSON data
                let decoder = JSONDecoder()
        
                do {
                    let dataArr = try decoder.decode([Event].self, from: data!)
                    self.eventsArray = dataArr
                    print("In JSON Parser for calendar event data: \(dataArr)")
                    self.doneParsing = true
                }
                catch{
                    print(error)
                }
        
            }
        }
        dataTask.resume()
    }
    
    //this function is setting the singleEvent variable in the third view controller as the current selected Event object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ThirdViewController {
            destination.singleEvent = dayEventsArray[(dayEvents.indexPathForSelectedRow?.row)!]
            dayEvents.deselectRow(at: dayEvents.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self is the SecondViewController, and it is being designated as the delegate of the UITableView object. This means that it will handle the tasks of the UITableView object. More details on the methods that come with being the UITableView delegate can be found in Apple's developer documentation.
        dayEvents.delegate = self
        
        //self is the SecondViewController, and it is being desingated as the source for the data that will populate the cells of our tableViewObject as well as managing that data and mutating it when necessary. More details on the methods that come with being the UITableView dataSource can be found in Apple's developer documentation.
        dayEvents.dataSource = self
        
        
        //customizing the buttons programatically to have round corners
        nextBttn.layer.cornerRadius = 15
        nextBttn.layer.masksToBounds = true
        prevBttn.layer.cornerRadius = 15
        prevBttn.layer.masksToBounds = true
        
        //setting up swarthmore logo to be displayed in navigation bar
        let swarthmoreLogo = UIImage(named: "swarthmore_logo")
        navigationItem.titleView = UIImageView(image: swarthmoreLogo)
//        navigationItem.titleView?.layer.cornerRadius = 15
//        navigationItem.titleView?.layer.masksToBounds = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        eventActivitySpinner.startAnimating()
        //loading the json data into the array containing the event objects
        parseEventJSON()
        while !doneParsing{
            //do not leave this block untill the json parsing is finished and the bool flag is flipped
        }
        //creating the date picker
        createDatePicker()
        //setting the current day events as the default displayed events
        //setting the defaultDate variable as the currently selected date
        defaultDate = datePicker.date
        initEventDisplay(date:defaultDate)
        //reloading tableview data once parsing is done
        dayEvents.reloadData()
        eventActivitySpinner.stopAnimating()
        
    }
    
    //button that goes to the next day when pressed
    @IBAction func nextButton(_ sender: Any) {
        
        //retrieving currently selected date information
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let currentDate = formatter.date(from: dateTxt.text!)
        
        //adding one day to currentDate
        let daysToAdd = 1
        var dateComponents = DateComponents()
        dateComponents.day = daysToAdd
        let futureDate = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
        
        //if the currently selected date is not the designated maximum Date, then proceed
        if currentDate != datePicker.maximumDate{
            
            //reloading display data accordingly to represent the next selected date
            datePicker.date = futureDate!
            dateTxt.text = formatter.string(from: futureDate!)
            dayEventsArray = getDayEvents(date: futureDate!, allEvents: eventsArray)
            dayEvents.reloadData()
        }
       }
    
    //button that goes to the previous day when pressed
    @IBAction func prevButton(_ sender: Any) {
        
        //retrieving currently selected date information
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let currentDate = formatter.date(from: dateTxt.text!)
       
        //subtracting one day to currentDate
        let daysToAdd = -1
        var dateComponents = DateComponents()
        dateComponents.day = daysToAdd
        let prevDate = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
       
        //if the currently selected date is not the designated maximum Date, then proceed
        if currentDate != datePicker.minimumDate{
            //reloading display data accordingly to represent the next selected date
            datePicker.date = prevDate!
            dateTxt.text = formatter.string(from: prevDate!)
            dayEventsArray = getDayEvents(date: prevDate!, allEvents: eventsArray)
            dayEvents.reloadData()
        }
       }
    
    
    //function to customize UIDatePicker object
    func createDatePicker() {
        
        //aligning the text in the text field
        dateTxt.textAlignment = .center
        dateTxt.font = UIFont(name: "System", size: 25)
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        //adding done button to toolbar
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        dateTxt.inputAccessoryView = toolbar
        
        //assign datePicker to the text field
        dateTxt.inputView = datePicker
        
        //date picker mode set to only show month, day, and year
        datePicker.datePickerMode = .date
        
        
        // want fixed month and year (mm/dd/yyxfyy)
        let getMonthYr = eventsArray[0].startDateTime
        print("eventsArray[0] : "+String(getMonthYr!))
        
        //month starts at index 5 and continues 2 digits
        let month = getMonthYr?.findingMonth(i: 5)
        
        //year starts at index 0 and continues 4 digits
        let year = getMonthYr?.findingYr(i: 0)
        
        //day starts at index 8 and continues 2 digits
        let day = getMonthYr?.findingDay(i: 8)
        
        //calculating nextMonth based on value of month
        var nextMonthInt: Int
        if Int(month!)! < 12{
            nextMonthInt = Int(month!)! + 1
        }
        else{
            nextMonthInt = 1
        }
        
        let nextMonthStr: String
        if nextMonthInt < 10{
            nextMonthStr = "0\(nextMonthInt)"
        }
        else{
            nextMonthStr = "\(nextMonthInt)"
        }
        
        print("month is : "+String(month!))
        print("year is : "+String(year!))
        
        //creating max and min dates for the date picker **for now, the min and max have been hardcoded
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let startDate = formatter.date(from: "\(year!)/\(month!)/\(day!)")
        let endDate = formatter.date(from: "\(year!)/\(nextMonthStr)/28")
        
        datePicker.maximumDate = endDate
        datePicker.minimumDate = startDate
        
    }
    
    //function that performs an action (in this case collapsing the date picker and returning the date) once doneBtn is pressed
    //function needs to have @objc keyword to convert the func into an objective c type object for the selector to work
    @objc func donePressed(){
        //formatting time
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        print("Date from datePicker: \(datePicker.date)")
        dateTxt.text = formatter.string(from: datePicker.date)
//        self.title = ""
        //closing off the text field for editing, hecne collapsing the date picker
        self.view.endEditing(true)
        
        //call function here that updates the contents of eventsArray to represent the events of the indicated date by the user.
        dayEventsArray = getDayEvents(date: datePicker.date, allEvents: eventsArray)
        //this tableView method reloads the data in the TableView
        
        dayEvents.reloadData()
    }
    
    //function that sets up the inital event display to show the current day events as default
    func initEventDisplay(date:Date){
        
        //formatting time
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateTxt.text = formatter.string(from: date)
        
        dayEventsArray = getDayEvents(date: date, allEvents: eventsArray)
        
    }
    

}

// finding month as string in createDatePicker
extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func findingMonth(i: Int) -> String {
        return self[i ..< i + 2]
    }
    
    func findingYr(i: Int) -> String {
        return self[i ..< i + 4]
    }
    
    func findingDay(i: Int) -> String {
        return self[i ..< i + 2]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


//--UITableViewDelegate Methods
extension SecondViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDescription", sender: self)
    }
    
}

//--UITableViewDataSource Methods
extension SecondViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dayEventsArray.count)
        return self.dayEventsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //tableViewCell is no longer a default prototype, but is of the class we created -> eventTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! eventTableViewCell
        
        //populating cell data
        cell.roundImage() //making cell image edges round
        let title: String = dayEventsArray[indexPath.row].title!.htmlStripped.htmlStripped2()

        cell.cellTextLabel.text = title
       
        
        let time: String = formatTime(startDateTime: dayEventsArray[indexPath.row].startDateTime!)
        cell.cellTimeLabel.text = time
        
        return cell
    }
}

//--MARK Helper Functions here!--

func formatTime(startDateTime: String)->String{
    
    //function that formats the time stamp for the event in a user friendly fashion
    
    let start = startDateTime.startIndex
//    "2019-10-01T08:00:00"
    let eleven = startDateTime.index(start, offsetBy: 11)
    let time: String = String(startDateTime[eleven...])
    
    let second = time.index(start, offsetBy: 1)
    let fourth = time.index(start, offsetBy: 3)
    let fifth = time.index(start, offsetBy: 4)
    var hour = String(time[...second])
    let minutes = String(time[fourth...fifth])
    
    var intHour = Int(hour)
    
    if intHour! > 12{
        intHour = intHour! - 12
        hour = String(intHour!) + ":" + minutes + "pm"
    }
    else if intHour! == 0{
        intHour = 12
        hour = String(intHour!) + ":" + minutes + "am"
    }
    else{
        hour = String(intHour!) + ":" + minutes + "am"
    }
    
    return hour
}


//--function in charge of returning the subset of events that occur during the date that the user selected

func getDayEvents(date: Date, allEvents: [Event])->[Event]{
    
    //converting Date object into a string that is comparable with the Event object field -> startDateTime
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let selectedDate = formatter.string(from: date)
    print("Selected Date: \(selectedDate)")
    
    var dayEventsArr: [Event] = []
    
    for event in allEvents{
        
        //when the event object date field matches the selected date by the user, append this event object to the subset of events that will be returned
        if dayExtractor(startDateTime: event.startDateTime!) == selectedDate{
            dayEventsArr.append(event)
        }
    }
    return dayEventsArr
}

//--helped function for func dayEvents that returns the day data embedded in the date information  contained within Event field -> startDateTime

func dayExtractor(startDateTime: String)->String{
    
    let first = startDateTime.startIndex
    let tenth = startDateTime.index(first,offsetBy: 9)
    
    return String(startDateTime[first...tenth])
}

//--helper functions to create url http request based on the current dates
func createURLmonth()->String{
    //this function constructs a URL string for requesting a json file from Swat API containing the events for a given month
    var url: String = "https://25livepub.collegenet.com/calendars/swarthmore-college-events.json?startdate="
       
    let singleDigitDates: [String] = ["0","1","2","3","4","5","6","7","8","9"]
       
    let date = Date()
    let calendar = Calendar.current
    
    let year = String(calendar.component(.year, from: date))
    var month = String(calendar.component(.month, from: date))
    var nextmonth: String
    var day = String(calendar.component(.day, from: date))
    let day2 = "28"
    
    if month != "12"{
        nextmonth = String(calendar.component(.month, from: date)+1)
    }
    else{
        nextmonth = "01"
    }
    
    //-- padding single digit months with 0's
    if singleDigitDates.contains(month){
        month = "0\(month)"
    }
    if singleDigitDates.contains(nextmonth){
        nextmonth = "0\(nextmonth)"
    }
    if singleDigitDates.contains(day){
           day = "0\(day)"
       }
    
    //constructing the URL that will be sent a request
    url += year+month+day+"&enddate="+year+nextmonth+day2
    print(url)
    
    return url
    
}
func createURLday()->String{
    
   //this function constructs a URL string for requesting a json file from Swat API containing the events for a given day
    
    var url: String = "https://25livepub.collegenet.com/calendars/swarthmore-college-events.json?startdate="
    
    let singleDigitDates: [String] = ["0","1","2","3","4","5","6","7","8","9"]
    
    let date = Date()
    
    let calendar = Calendar.current
    
    let year = String(calendar.component(.year, from: date))
    var month = String(calendar.component(.month, from: date))
    var day = String(calendar.component(.day, from: date))
    var tmm = String(calendar.component(.day, from: date)+1)
    
//    print("Day:\(day) Month:\(month) Year:\(year)")
    
    //-- The following statements revise the date information accordingly
    if singleDigitDates.contains(month){
        month = "0\(month)"
    }
    if singleDigitDates.contains(day){
        day = "0\(day)"
    }
    
    if singleDigitDates.contains(tmm){
        tmm = "0\(tmm)"
    }
    // -- end of date revision
    
    // create variable for the next month
    var nextmonth = Int(month)!
    var nextyear = Int(year)!
    nextmonth = nextmonth + 1
    
    if nextmonth>12{
        nextmonth = 1
        nextyear = nextyear + 1
    }
    var strnmonth = String(nextmonth)
    
    if singleDigitDates.contains(strnmonth){
        strnmonth = "0\(strnmonth)"
    }
    //constructing the URL that will be sent a request
    url += year+month+day+"&enddate="+String(nextyear)+strnmonth+tmm
    
    return url
}
