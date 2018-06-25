//
//  KMLGen.swift
//  Drone Map
//
//  Created by eric on 6/10/18.
//  Copyright © 2018 E4E. All rights reserved.
//

import Foundation
import UIKit

class KML: NSObject{
    //total header
    let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://www.opengis.net/kml/2.2\">\n"
    let foot = "</kml>"
    var string = ""
    //header of polygon
    let polyhead = """
    \t<Placemark>
    \t\t<Polygon>
    \t\t\t<extrude>1</extrude>
    \t\t\t<altitudeMode>relativeToGround</altitudeMode>
    \t\t\t<outerBoundaryIs>
    \t\t\t\t<LinearRing>
    \t\t\t\t\t<coordinates>\n
    """
    //footer of polygon
    let polyfoot = """
    \t\t\t\t\t</coordinates>
    \t\t\t\t</LinearRing>
    \t\t\t</outerBoundaryIs>
    \t\t</Polygon>
    \t</Placemark>\n
    """
    var pointstring = ""
    var polystring = ""
    
    func createKML(pointlat : [Double], pointlong: [Double], polylat : [Double], polylong : [Double]) -> String{
        if(polylat.isEmpty == false) && (polylong.isEmpty == false) {
            let len = polylat.count
            for i in 0..<(len+1){
                let currentlong = polylong[i]
                let currentlat = polylat[i]
                polystring.append("\(currentlong),\(currentlat),0\n")
                
            }
        }
        if (pointlat.isEmpty == false) && (pointlat.isEmpty == false) {
            let len = pointlat.count
            for i in 0..<(len+1){
                let currentlat = pointlat[i]
                let currentlong = pointlong[i]
                pointstring.append(
                    """
                    \t<Placemark>
                    \t\t<Point>
                    \t\t\t<coordinates>
                    \t\t\t\t\(currentlong),\(currentlat),0
                    \t\t\t</coordinates>
                    \t\t</Point>
                    \t</Placemark>\n
                    """
                )
            }
        }
        let string = header + polyhead + polystring + polyfoot + pointstring + foot
        return string
    }
}
