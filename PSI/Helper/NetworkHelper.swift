//
//  NetworkHelper.swift
//  PSI
//
//  Created by Ying Xuan Sam on 11/6/18.
//  Copyright © 2018 Sammie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class NetworkHelper {
    
    static let sharedInstance = NetworkHelper()
    let data = IndexDataModel()
    
    func requestWithGETMethod(url: String, parameters: [String: String], completionHandler:@escaping (Array<IndexDataModel>) -> ()) {
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            SVProgressHUD.dismiss()
            if response.result.isSuccess {
                
                print("Success! Got the PSI")
                let result : JSON = JSON(response.result.value!)
                completionHandler(self.process(data: result))
            }
            else {
                
                print("Error \(String(describing: response.result.error))")
                let alert = UIAlertController(title: "Network Error", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                alert.show()
            }
        }
    }
    
    func process(data: JSON) -> Array<IndexDataModel> {
        var indexList = [IndexDataModel]()
        
        let regionMetadata = data["region_metadata"]
        for (_, location) in regionMetadata {
            let unitData = IndexDataModel()
            if let title = location["name"].string {
                unitData.region = title
                if title == "national" {
                    continue
                }
            }
            else {
                continue
            }
            
            let longitude = location["label_location"]["longitude"].doubleValue
            let latitude = location["label_location"]["latitude"].doubleValue
            unitData.longitude = longitude
            unitData.latitude = latitude
            
            for (_, readings) in data["items"] {
                for (key, reading) in readings["readings"] {
                    unitData.readings = unitData.readings + key + ": "
                    
                    for (area, value) in reading {
                        if unitData.region == area {
                            unitData.readings = unitData.readings + value.stringValue + "\n"
                        }
                    }
                }
            }
            
            indexList.append(unitData)
            
        }
        return indexList
    }
}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindowLevelAlert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}
