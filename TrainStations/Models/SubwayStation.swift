//
//  Stattions.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct SubwayStation: Decodable {
    let id: String
    let name: String
    let location: [Double]
    let stops: [String: [Double]]
}
