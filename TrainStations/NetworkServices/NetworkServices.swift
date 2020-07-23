//
//  NetworkServices.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

class APIClient {
    static func fetchTrainStations(completion: @escaping(Result<[SubwayStation], Error>) -> ()) {
        let endpointURL = "https://raw.githubusercontent.com/jonthornton/MTAPI/master/data/stations.json"
        
        guard let url = URL(string: endpointURL) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let resultsDict = try JSONDecoder().decode([String: SubwayStation].self, from: data)
                    var stations = [SubwayStation]()
                    for (_, value) in resultsDict {
                        let station = SubwayStation(id: value.id, name: value.name, location: value.location, stops: value.stops)
                        stations.append(station)
                    }
                    completion(.success(stations))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
    static func fetchStationDetails(id: String, completion: @escaping (Result<[StationDetail], Error>) -> ()) {
        let endpointURL = "https://api.wheresthefuckingtrain.com/by-id/\(id)"
        
        guard let url = URL(string: endpointURL) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let resultsData = try JSONDecoder().decode(StationDetailData.self, from: data)
                    completion(.success(resultsData.data))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        dataTask.resume()
    }
}
