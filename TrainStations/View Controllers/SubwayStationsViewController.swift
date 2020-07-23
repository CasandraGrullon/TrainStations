//
//  ViewController.swift
//  TrainStations
//
//  Created by casandra grullon on 7/22/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit

class SubwayStationsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    private var stations = [SubwayStation]() {
        didSet {
            tableview.reloadData()
        }
    }
    private var searchQuery = String() {
        didSet {
            stations = stations.filter {$0.name.lowercased().contains(searchQuery.lowercased())}
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        searchBar.delegate = self
        fetchTrainStationsData()
        navigationItem.title = "MTA Subway Tracker"
    }
    private func fetchTrainStationsData() {
        APIClient.fetchTrainStations { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not retrieve data error: \(error)")
            case .success(let stations) :
                DispatchQueue.main.async {
                    self?.stations = stations.sorted(by: {$0.name < $1.name})
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let stationDetailVC = segue.destination as? StationDetailViewController, let indexPath = tableview.indexPathForSelectedRow else {
            fatalError("could not segue")
        }
        stationDetailVC.station = stations[indexPath.row]
    }
}
extension SubwayStationsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty ?? false) {
            fetchTrainStationsData()
        } else {
            searchQuery = searchBar.text ?? ""
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension SubwayStationsViewController: UITableViewDataSource {
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
