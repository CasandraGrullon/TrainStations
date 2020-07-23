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
    @IBOutlet weak var tableView: UITableView!
    
    public var station: SubwayStation?
    
    public var northRoute = [Schedule]()
    public var southRoute = [Schedule]()
    public var routes = [[Schedule]]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
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
    private func cellBackgroundColor(route: String, cell: UITableViewCell) {
        let blue = ["A", "C", "E"]
        let red = ["1", "2", "3"]
        let purple = ["7"]
        let orange = ["B", "D", "F", "M"]
        let yellow = ["N", "Q", "W", "R"]
        let darkGreen = ["4", "5", "6"]
        let lightGreen = ["G"]
        let grey = ["S"]
        let brown = ["J", "Z"]
        
        if blue.contains(route) {
            cell.backgroundColor = .blue
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
        } else if red.contains(route) {
            cell.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
        } else if purple.contains(route) {
            cell.backgroundColor = #colorLiteral(red: 0.7181599736, green: 0, blue: 1, alpha: 1)
        } else if orange.contains(route) {
            cell.backgroundColor = .orange
        } else if yellow.contains(route) {
            cell.backgroundColor = .yellow
        } else if darkGreen.contains(route) {
            cell.backgroundColor = .green
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
        } else if lightGreen.contains(route) {
            cell.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        } else if grey.contains(route) {
            cell.backgroundColor = .lightGray
        } else if brown.contains(route) {
            cell.backgroundColor = .brown
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
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
            cellBackgroundColor(route: route.route, cell: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "southCell", for: indexPath)
            let route = routes[indexPath.section][indexPath.row]
            cell.textLabel?.text = "\(route.route) train"
            cell.detailTextLabel?.text = route.time
            cellBackgroundColor(route: route.route, cell: cell)
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "North Bound Schedule"
        } else {
            return "South Bound Schedule"
        }
    }
}
