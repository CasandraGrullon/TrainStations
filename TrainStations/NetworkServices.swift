//
//  NetworkServices.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import Foundation

class APIClient {
    static func fetchTrainStations(completion: @escaping(Result<[Station], Error>) -> ()) {
        let endpointURL = "https://raw.githubusercontent.com/jonthornton/MTAPI/master/data/stations.json"
        
        guard let url = URL(string: endpointURL) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let resultsDict = try JSONDecoder().decode([String: Station].self, from: data)
                    var stations = [Station]()
                    for (_, value) in resultsDict {
                        let station = Station(id: value.id, name: value.name, location: value.location, stops: value.stops)
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
}
