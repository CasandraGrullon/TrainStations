//
//  TrainStationsTests.swift
//  TrainStationsTests
//
//  Created by casandra grullon on 7/23/20.
//  Copyright © 2020 casandra grullon. All rights reserved.
//

import XCTest
@testable import TrainStations

class TrainStationsTests: XCTestCase {
    
    func testFetchTrainStations() {
        let expCount = 3
        let exp = XCTestExpectation(description: "results found" )
        
        APIClient.fetchTrainStations { (result) in
            switch result{
            case .failure(let error):
                XCTFail("Did not get back data error: \(error.localizedDescription)")
            case .success(let stations):
                XCTAssertGreaterThan(stations.count, expCount)
                exp.fulfill()
            }
        }
        wait(for:[exp], timeout: 5.0)

    }
    
    
}
