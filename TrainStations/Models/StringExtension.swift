//
//  DateExtension.swift
//  TrainStations
//
//  Created by casandra grullon on 7/23/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation
import Foundation

extension String {
    public func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        guard let date = dateFormatter.date(from: self) else { return "" }
        return dateFormatter.string(from: date)
    }
}
