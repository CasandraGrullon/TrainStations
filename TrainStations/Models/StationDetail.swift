//
//  ArrivalTimes.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

struct StationDetailData: Decodable {
 let data: [StationDetail]
}
struct StationDetail: Decodable {
 let north: [Schedule]
 let south: [Schedule]
 let id: String
 let lastUpdate: String
 let location: [Double]
 let name: String
 let routes: [String]
 let stops: [String: [Double]]
 private enum CodingKeys: String, CodingKey {
  case north = "N"
  case south = "S"
  case id
  case lastUpdate = "last_update"
  case location
  case name
  case routes
  case stops
 }
}
struct Schedule: Decodable {
 let route: String
 let time: String
}

