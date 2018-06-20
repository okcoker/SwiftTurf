//
//  ViewController.swift
//  SwiftTurf
//
//  Created by Adolfo Martinelli on 09/27/2016.
//  Copyright (c) 2016 Adolfo Martinelli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftTurf

class ViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		mapView.delegate = self
		mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 36.731441091028245, longitude: -118.29915093141854)
		mapView.region.span = MKCoordinateSpan(latitudeDelta: 13.5, longitudeDelta: 9.8)

		var coordinates = [
			CLLocationCoordinate2D(latitude: 33.43144133557529, longitude: -121.11328125000000),
			CLLocationCoordinate2D(latitude: 40.27952566881291, longitude: -117.90527343750001),
			CLLocationCoordinate2D(latitude: 33.94335994657882, longitude: -115.57617187499999),
			CLLocationCoordinate2D(latitude: 38.13455657705411, longitude: -122.29980468749999),
			CLLocationCoordinate2D(latitude: 38.41055825094609, longitude: -114.38964843750000),
			CLLocationCoordinate2D(latitude: 33.43144133557529, longitude: -121.11328124999999)
		]
		
		let lineString: LineString = LineString(geometry: coordinates)
		let bufferedLineString: Polygon? = SwiftTurf.buffer(lineString, distance: 50, units: .Kilometers)

		// The first polygon coordinates represent the outer polygon
		let outerPolygonCoordinates = bufferedLineString!.geometry[0]
		// The subsequent polygon coordinates represent the interior polygons that are to
		// be subtracted (cut out) from the outer polygon area.
		let interiorPolygonsCoordinates = bufferedLineString!.geometry[1..<bufferedLineString!.geometry.count]

		let interiorPolygons = interiorPolygonsCoordinates.map { coordinates -> MKPolygon in
			MKPolygon(coordinates: coordinates, count: coordinates.count)
		}

		let bufferedArea = MKPolygon(coordinates: outerPolygonCoordinates, count: outerPolygonCoordinates.count, interiorPolygons: interiorPolygons)
		mapView.add(bufferedArea)
		
		let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
		mapView.add(polyline)
    }

}

extension ViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		
		if let polyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(overlay: polyline)
			renderer.strokeColor = .blue
			renderer.lineWidth = 2.0
			return renderer
		}

		if let polygon = overlay as? MKPolygon {
			let renderer = MKPolygonRenderer(overlay: polygon)
			renderer.fillColor = UIColor.green.withAlphaComponent(0.25)
			return renderer
		}

		fatalError("unexpected overlay type")
	}
	
}

