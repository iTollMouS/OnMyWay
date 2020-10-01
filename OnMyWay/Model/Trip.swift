//
//  Traveler.swift
//  OnMyWay
//
//  Created by Tariq Almazyad on 10/1/20.
//

import Foundation
import Firebase

struct Trip {
    
    let userID: String
    let tripID: String
    var tripDate: Date!
    let tripTime: String
    let fromCity: String
    let destinationCity: String
    let basePrice: String
    let packageType: String
    let timestamp: Timestamp
    
    init(userID: String, dictionary: [String: Any]) {
        self.userID = userID
        self.tripID = dictionary["tripID"] as? String ?? ""
        self.tripTime = dictionary["tripTime"] as? String ?? ""
        self.fromCity = dictionary["fromCity"] as? String ?? ""
        self.destinationCity = dictionary["destinationCity"] as? String ?? ""
        self.basePrice = dictionary["basePrice"] as? String ?? ""
        self.packageType = dictionary["packageType"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        if let tripDate = dictionary["tripDate"] as? Double {
            self.tripDate = Date(timeIntervalSince1970: tripDate)
        }
    }
    
}
