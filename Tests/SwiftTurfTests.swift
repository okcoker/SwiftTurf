//
//  SwiftTurfTests.swift
//  SwiftTurfTests
//
//  Created by Sean Coker on 3/23/21.
//  Copyright © 2021 AirMap, Inc. All rights reserved.
//

import XCTest

class SwiftTurfTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPolygonId() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let id = "test"
        let ring = [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
        let poly = Polygon(id: id, geometry: [ring])

        XCTAssertEqual(poly.id, id)
    }

    func testPolygonMutableId() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let ring = [CLLocationCoordinate2D(latitude: 0, longitude: 0)]
        let poly = Polygon(id: "test", geometry: [ring])
        poly.id = "newtest"

        XCTAssertEqual(poly.id, "newtest")
    }

    func testPolygonGeoRepWithId() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let id = "test"
        let ring = [
            CLLocationCoordinate2D(latitude: 0, longitude: 10),
            CLLocationCoordinate2D(latitude: 10, longitude: 10),
            CLLocationCoordinate2D(latitude: 10, longitude: 20),
            CLLocationCoordinate2D(latitude: 10, longitude: 30),
            CLLocationCoordinate2D(latitude: 0, longitude: 10)
        ]
        let poly = Polygon(id: id, geometry: [ring])
        let expected: [[Double]] = [
            [10, 0],
            [10, 10],
            [20, 10],
            [30, 10],
            [10, 0]
        ]
        let geoRep: [AnyHashable: Any] = [
            "type": "Feature",
            "id": id,
            "geometry": [
                "type": "Polygon",
                "coordinates": expected,
                "properties": NSNull()
            ],
            "properties": NSNull()
        ]

        XCTAssertEqual(poly.geoJSONRepresentation()["id"] as! String, geoRep["id"] as! String)
        XCTAssertEqual(poly.coordinateRepresentation(), [expected])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
