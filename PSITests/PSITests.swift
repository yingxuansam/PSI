//
//  PSITests.swift
//  PSITests
//
//  Created by Ying Xuan Sam on 16/6/18.
//  Copyright © 2018 Sammie. All rights reserved.
//



import Quick
import Nimble
@testable import PSI

class PSITests: QuickSpec {
    
    override func spec() {
        
        describe("getting") {
            context("data from API") {
                it("should have data of five regions") {
                    
                    let PSI_URL = "https://api.data.gov.sg/v1/environment/psi"
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    formatter.timeZone = TimeZone(secondsFromGMT: 28800)
                    
                    let date = formatter.string(from: Date())
                    let params : [String : String] = ["date_time" : date]
                    
                    // Data should consists of 5 regions: North, South, East, West and Central; National is excluded
                    waitUntil(timeout: 5) { done in
                        NetworkHelper.sharedInstance.requestWithGETMethod(url: PSI_URL, parameters:params){
                            (response) in
                            expect(response.count) == 5
                            done()
                        }
                    }

                 }
            }
        }
    }
}
