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
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var sharePopup: UIButton!
    @IBOutlet weak var polyPopup: UIButton!
    @IBOutlet weak var inButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var zoomLabel: UILabel!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    @IBOutlet weak var switchVal: UISwitch!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    var currentNum = 0
    let PolygonView = PolygonViewController()
    var polyState = false
    
    struct Marker {
        let num: String
        let lat: CLLocationDegrees
        let long: CLLocationDegrees
    }
    var markers = [
        Marker(num: "0", lat: 32.8801, long: -117.234)
    ]
    var polygonVerts = [
        Marker(num: "0", lat: 32.8801, long: -117.234)
    ]
    
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
    var polyCreate = false
    @IBAction func shareFile(_ sender: UIButton) {
        let share : KML = KML()
        var polygon_lat = [CLLocationDegrees]()
        var polygon_long = [CLLocationDegrees]()
        var point_lat = [CLLocationDegrees]()
        var point_long = [CLLocationDegrees]()
        for polygonVert in polygonVerts{
            let currentLat = polygonVert.lat
            let currentLong = polygonVert.long
            polygon_lat.append(currentLat)
            polygon_long.append(currentLong)
        }
        for marker in markers{
            let currentLat = marker.lat
            let currentLong = marker.long
            point_lat.append(currentLat)
            point_long.append(currentLong)
        }
        let text = share.createKML(pointlat: point_lat, pointlong: point_long, polylat: polygon_lat, polylong: polygon_long)
      
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    //Zoom Out
    @IBAction func outPress(_ sender: Any) {
        var outCurrentZoom = mapView.camera.zoom
        outCurrentZoom = outCurrentZoom - 1
        zoomLabel.text = String(outCurrentZoom)
        mapView.animate(toZoom: Float(outCurrentZoom))
    }
    //Convert points to polygon, create polygon, then
    
    @IBAction func convertToPolygon(_ sender: Any) {
      polygonConversion()
    }
    func polygonConversion(){
        let poly = GMSMutablePath()
        for marker in markers {
            let currentLat = marker.lat
            let currentLong = marker.long
            poly.add(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong))
        }
        let polygon = GMSPolygon(path: poly)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05)
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        markers.removeAll()
        currentNum = 0
        mapView.clear()
        polygon.map = mapView
        polyState = true
        
    }
    func functionName (notification: NSNotification) {
        polygonConversion()
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        if test {
            polygonConversion()
            print("is this working")
        }
        
    }
 */
    //Self explanatory
    @IBAction func clearMap(_ sender: Any) {
        mapView.clear()
        polygonVerts.removeAll()
        markers.removeAll()
        currentNum = 0
        polyState = false
    }
    //Add Point function, rename
    @IBAction func updateLocation(_ sender: Any) {
        let lat = mapView.camera.target.latitude
        let long = mapView.camera.target.longitude
        latLabel.text = lat.description
        longLabel.text = long.description
        markers.append(Marker(num: String(currentNum + 1), lat: CLLocationDegrees(Float(lat)), long: CLLocationDegrees(Float(long))))
        polygonVerts.append(Marker(num: String(currentNum + 1), lat: CLLocationDegrees(Float(lat)), long: CLLocationDegrees(Float(long))))
        currentNum = currentNum + 1
        showMarker(position: mapView.camera.target)
        
    }
    //Zoom In
    @IBAction func inPress(_ sender: Any) {
        var inCurrentZoom = mapView.camera.zoom
            inCurrentZoom = inCurrentZoom + 1
        zoomLabel.text = String(inCurrentZoom)
        mapView.animate(toZoom: Float(inCurrentZoom))
    }
    var markerDict: [String: GMSMarker] = [:]
    
    @IBAction func rpointnobound(_ sender: Any) {
        var currentLat : CLLocationDegrees
        var currentLong : CLLocationDegrees
        repeat{
            let points = getRandomPoints()
            currentLong = points.rand_long
            currentLat = points.rand_lat
        }
            while (polyTest(testlat: currentLat, testlong: currentLong) == false)
        markers.append(Marker(num: String(currentNum + 1), lat: CLLocationDegrees(Float(currentLat)), long: CLLocationDegrees(Float(currentLong))))
        currentNum = currentNum + 1
        showMarker(position: mapView.camera.target)
    }
    //when app opens
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
    var randomPoints = [CLLocationCoordinate2D]()
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

    func getRandomPoints() -> (rand_lat: Double, rand_long: Double){
        var polygon_lat = [CLLocationDegrees]()
        var polygon_long = [CLLocationDegrees]()
        for polygonVert in polygonVerts{
            let currentLat = polygonVert.lat
            let currentLong = polygonVert.long
            polygon_lat.append(currentLat)
            polygon_long.append(currentLong)
        }
        //set maximum values of polyon
        let max_lat = polygon_lat.max()!
        let max_long = polygon_long.max()!
        let min_lat = polygon_lat.min()!
        let min_long = polygon_long.min()!
        let rand_lat = (Double(arc4random()) / 0xFFFFFFFF) * (max_lat - min_lat) + min_lat
        let rand_long = (Double(arc4random()) / 0xFFFFFFFF) * (max_long - min_long) + min_long
        
        return(rand_lat, rand_long)
        }
    func polyTest(testlat: CLLocationDegrees, testlong: CLLocationDegrees) -> (Bool){
        let path = GMSMutablePath()
        for polygonVert in polygonVerts{
            path.add(CLLocationCoordinate2D(latitude: polygonVert.lat, longitude: polygonVert.long))
        }
        let isinpoly = GMSGeometryContainsLocation(CLLocationCoordinate2D(latitude: testlat, longitude: testlong), path, true)
        return isinpoly
    }
   
}

/*extension ViewController: GMSMapViewDelegate{
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

 */
