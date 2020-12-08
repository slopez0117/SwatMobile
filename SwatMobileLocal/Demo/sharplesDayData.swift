//
//  sharplesDayData.swift
//  Demo
//
//  Created by Saul  Lopez-Valdez on 4/27/20.
//  Copyright © 2020 Saul  Lopez-Valdez. All rights reserved.
//

import Foundation

// structs to decode json sharples data

struct sharplesDayData: Codable {
    let calData: [String: dayMeals]?
}

