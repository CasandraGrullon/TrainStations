//
//  StationDetailViewController.swift
//  TrainStations
//
//  Created by casandra grullon on 7/23/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import UIKit
import MapKit

class StationDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var northTableView: UITableView!
    
    @IBOutlet weak var southTableView: UITableView!
    public var station: SubwayStation?
    
    public var northRoute = [Schedule]() {
        didSet {
            northTableView.reloadData()
        }
    }
    public var southRoute = [Schedule]() {
        didSet {
            southTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        northTableView.dataSource = self
        fetchStationDetails(id: station?.id ?? "")
    }
    
    private func fetchStationDetails(id: String) {
        APIClient.fetchStationDetails(id: id) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("could not retrieve station details error: \(error.localizedDescription)")
            case .success(let stationDetails):
                DispatchQueue.main.async {
                    guard let north = stationDetails.first?.north, let south = stationDetails.first?.south else {
                        return
                    }
                    self?.northRoute = north
                    self?.southRoute = south
                    self?.navigationItem.title = stationDetails.first?.name
                }
            }
        }
    }
}
extension StationDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == northTableView {
            return northRoute.count
        } else if tableView == southTableView {
            return southRoute.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == northTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "northCell", for: indexPath)
            let route = northRoute[indexPath.row]
            cell.textLabel?.text = "\(route.route) Train"
            cell.detailTextLabel?.text = route.time
            return cell
        } else if tableView == southTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "southCell", for: indexPath)
            let route = southRoute[indexPath.row]
            cell.textLabel?.text = "\(route.route) Train"
            cell.detailTextLabel?.text = route.time
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "southCell", for: indexPath)
            let route = southRoute[indexPath.row]
            cell.textLabel?.text = "\(route.route) Train"
            cell.detailTextLabel?.text = route.time
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == northTableView {
            return "North Bound Schedule"
        } else if tableView == southTableView {
            return "South Bound Schedule"
        } else {
            return ""
        }
    }
}
