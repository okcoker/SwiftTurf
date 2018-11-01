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

		let star = [
			CLLocationCoordinate2D(latitude: 33.43144133557529, longitude: -121.11328125000000),
			CLLocationCoordinate2D(latitude: 40.27952566881291, longitude: -117.90527343750001),
			CLLocationCoordinate2D(latitude: 33.94335994657882, longitude: -115.57617187499999),
			CLLocationCoordinate2D(latitude: 38.13455657705411, longitude: -122.29980468749999),
			CLLocationCoordinate2D(latitude: 38.41055825094609, longitude: -114.38964843750000),
			CLLocationCoordinate2D(latitude: 33.43144133557529, longitude: -121.11328124999999)
		]
		
		let lineString: LineString = LineString(geometry: star)
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

		let polyline = MKPolyline(coordinates: star, count: star.count)
		mapView.add(polyline)
		
		let lineString1 = LineString(geometry: [CLLocationCoordinate2D(latitude: 20, longitude: 20), CLLocationCoordinate2D(latitude: 40, longitude: 40)])
		let lineString2 = LineString(geometry: [CLLocationCoordinate2D(latitude: 20, longitude: 40), CLLocationCoordinate2D(latitude: 40, longitude: 20)])
        let intersect = SwiftTurf.lineIntersect(lineString1, lineString2)
		let intersectResultPoint = Point(dictionary: intersect!.features.first!.geoJSONRepresentation())
		// Prints true if the intersecting coordinate is correct
		let intersectResult = intersectResultPoint?.geometry.latitude == 30.0 && intersectResultPoint?.geometry.latitude == 30.0
		print("lineIntersect test result (should be true): \(intersectResult)")
		
		let origin = Point(geometry: CLLocationCoordinate2D(latitude: 36.731441091028245, longitude: -118.29915093141854))
		let distance: Double = 200
		let bearing: Double = 90
        let destination = SwiftTurf.destination(point: origin, distance: distance, bearing: bearing)

		let orginLocation = CLLocation(latitude: origin.geometry.latitude, longitude: origin.geometry.longitude)
		let destinationLocation = CLLocation(latitude: destination?.geometry.latitude ?? 0, longitude: destination?.geometry.longitude ?? 0)
		print("destination test result: \(orginLocation.distance(from: destinationLocation)) ~= \(distance)")
		
		let polygonCoordinates = [
			CLLocationCoordinate2D(latitude: 34.05152161016494, longitude: -118.46583366394043),
			CLLocationCoordinate2D(latitude: 34.035590649919314, longitude: -118.47956657409668),
			CLLocationCoordinate2D(latitude: 34.02705497597962, longitude: -118.46240043640137),
			CLLocationCoordinate2D(latitude: 34.042062963450476, longitude: -118.44849586486818),
			CLLocationCoordinate2D(latitude: 34.05152161016494, longitude: -118.46583366394043)
		]
		
		let polygon = Polygon(geometry: [polygonCoordinates])
		let pointInsidePolygon = Point(geometry: CLLocationCoordinate2D(latitude: 34.03815118464513, longitude: -118.46488952636717))
		
		let containsResult = SwiftTurf.contains(polygon: polygon, point: pointInsidePolygon)
		print("contains test result (should be true): \(containsResult)")
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

