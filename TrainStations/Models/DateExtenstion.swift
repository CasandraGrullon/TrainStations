//
//  DateExtenstion.swift
//  TrainStations
//
//  Created by casandra grullon on 7/23/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}

extension Date {

    func toString(withFormat format: String = "h:mm a") -> String {

        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "fa-IR")
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        //dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
