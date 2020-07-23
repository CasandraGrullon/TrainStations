//
//  ViewController.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    private var stations = [Station]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        fetchTrainStationsData()
    }
    
    private func fetchTrainStationsData() {
        APIClient.fetchTrainStations { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not retrieve data error: \(error)")
            case .success(let stations) :
                DispatchQueue.main.async {
                    self?.stations = stations
                }
            }
        }
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.name
        return cell
    }
}
