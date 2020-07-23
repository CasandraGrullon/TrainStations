# Train Stations App

Users can search for a subway station by name and see the train schedules for that station

<img src="Media/trainStationsApp.gif" alt="gif" width="300" height="600"/>

## Code Snippet
## Parsing through JSON data with unique dictionary names
### 1. Fetching all MTA subway stations data from API: https://raw.githubusercontent.com/jonthornton/MTAPI/master/data/stations.json
```swift
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
    ```
