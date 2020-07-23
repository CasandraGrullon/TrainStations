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
    
    public var northRoute = [Schedule]()
    public var southRoute = [Schedule]()
    public var routes = [[Schedule]]() {
        didSet {
            northTableView.reloadData()
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
                    self?.routes.append(north)
                    self?.routes.append(south)
                    self?.navigationItem.title = stationDetails.first?.name
                }
            }
        }
    }
}
extension StationDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "northCell", for: indexPath)
            let route = routes[indexPath.section][indexPath.row]
            cell.textLabel?.text = "\(route.route) train"
            cell.detailTextLabel?.text = route.time
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "southCell", for: indexPath)
            let route = routes[indexPath.section][indexPath.row]
            cell.textLabel?.text = "\(route.route) train"
            cell.detailTextLabel?.text = route.time
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "North"
        } else {
            return "South"
        }
    }
}
