//
//  scanImeiTest.swift
//  DCPTests
//
//  Created by ShamsUlHaq on 24/12/2019.
//  Copyright © 2019 ShamsUlHaq. All rights reserved.
//

import XCTest
@testable import DCP
import Hippolyte
import Material

class ScanImeiTest: XCTestCase {
var homeView: HomeViewController!
    override func setUp() {
        getHomeViewContoller()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    
    func getHomeViewContoller()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeView = vc
        let _ = homeView.view
        
    }
}
