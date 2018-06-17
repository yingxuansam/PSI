//
//  ViewController.swift
//  PSI
//
//  Created by Ying Xuan Sam on 11/6/18.
//  Copyright © 2018 Sammie. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class HomeMapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapVw: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 28800) // SG Timezone

        let date = formatter.string(from: Date())
        let params : [String : String] = ["date_time" : date]
        NetworkHelper.sharedInstance.requestWithGETMethod(url: Constants.PSI_URL, parameters:params){
            (response) in
            self.displayPSI(result: response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPSI(result: Array<IndexDataModel>) {
        
        
        for item in result {
            
            let latitude = item.latitude
            let longitude = item.longitude
            
            let pinPoint = CLLocationCoordinate2DMake(latitude, longitude)
            let annotation = MKPointAnnotation()
            
            if (item.region == "central") {
                setMapDefaultRegion(latitude: item.latitude, longitude: item.longitude)
            }
            
            annotation.coordinate = pinPoint
            annotation.title = item.region.uppercased()
            annotation.subtitle = item.readings
            self.mapVw.addAnnotation(annotation)
        }
    }
    
    func setMapDefaultRegion (latitude : Double, longitude : Double){
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        
        self.mapVw.setRegion(region, animated: true)

    }
}

