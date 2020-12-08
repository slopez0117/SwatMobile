//
//  Event.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 4/8/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import Foundation

//This is the definition of an Event object

struct Event: Codable{
    
    var title: String?
    var dateTimeFormatted: String?
    var description: String?
    var startDateTime: String?
    var endDateTime: String?
    
    //This is a comment
}
