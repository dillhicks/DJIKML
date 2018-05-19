//
//  ViewController.swift
//  Drone Map
//
//  Created by Dillon Hicks on 5/1/18.
//  Copyright © 2018 E4E. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController  {
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var zoomLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var switchVal: UISwitch!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    var currentNum = 0
    
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch mapTypeControl.selectedSegmentIndex
        {
        case 0:
            mapView.mapType = .normal
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    @IBAction func outPress(_ sender: Any) {
        var outCurrentZoom = mapView.camera.zoom
        outCurrentZoom = outCurrentZoom - 1
        zoomLabel.text = String(outCurrentZoom)
        mapView.animate(toZoom: Float(outCurrentZoom))
    }
    @IBAction func convertPolygon(_ sender: Any) {
        let poly = GMSMutablePath()
        for marker in markers {
            let currentLat = marker.lat
            let currentLong = marker.long
            poly.add(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong) )
        let polygon = GMSPolygon(path: poly)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05)
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        markers.removeAll()
        currentNum = 0
        mapView.clear()
        polygon.map = mapView
        }
    }
    @IBAction func clearMap(_ sender: Any) {
        mapView.clear()
        markers.removeAll()
        currentNum = 0
    }
    @IBAction func updateLocation(_ sender: Any) {
        let lat = mapView.camera.target.latitude
        let long = mapView.camera.target.longitude
        latLabel.text = lat.description
        longLabel.text = long.description
        markers.append(Marker(num: String(currentNum + 1), lat: CLLocationDegrees(Float(lat)), long: CLLocationDegrees(Float(long))))
        currentNum = currentNum + 1
        showMarker(position: mapView.camera.target)
        
    }
    @IBAction func inPress(_ sender: Any) {
        var inCurrentZoom = mapView.camera.zoom
            inCurrentZoom = inCurrentZoom + 1
        zoomLabel.text = String(inCurrentZoom)
        mapView.animate(toZoom: Float(inCurrentZoom))
    }
    var markerDict: [String: GMSMarker] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 32.8801, longitude: -117.234, zoom: 10)
        mapView.camera = camera
        mapView.mapType = .hybrid
        mapView.setMinZoom(1, maxZoom: 30)
        let startZoom = mapView.camera.zoom
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
       
        showMarker(position: camera.target)
        zoomLabel.text = String(startZoom)
        
        let circleView = UIView()
        circleView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        view.addSubview(circleView)
        view.bringSubview(toFront: circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        let widthConstraint = NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        let centerXConstraint = NSLayoutConstraint(item: circleView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint, centerXConstraint, centerYConstraint])
        
        view.updateConstraints()
        UIView.animate(withDuration: 1.0, animations: {
            self.view.layoutIfNeeded()
            circleView.layer.cornerRadius = (circleView.frame.width)/2
            circleView.clipsToBounds = true
        })
        
    }
    //markers for polygon and point generation
    struct Marker {
        let num: String
        let lat: CLLocationDegrees
        let long: CLLocationDegrees
    }
    var markers = [
        Marker(num: "0", lat: 32.8801, long: -117.234)
    ]
    func showMarker(position: CLLocationCoordinate2D){
        for marker in markers {
            let currentMarker = GMSMarker()
            currentMarker.position = CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long)
            currentMarker.title = marker.num
            currentMarker.snippet = "\(marker.num)"
            currentMarker.map = mapView
            currentMarker.isDraggable = true
        }
    }
}
extension ViewController: GMSMapViewDelegate{
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
}

