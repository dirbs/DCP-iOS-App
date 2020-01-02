/*
 * Copyright (c) 2018-2019 Qualcomm Technologies, Inc.
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:
 *  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *  Neither the name of Qualcomm Technologies, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 *  The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment is required by displaying the trademark/log as per the details provided here: [https://www.qualcomm.com/documents/dirbs-logo-and-brand-guidelines]
 *  Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
 *  This notice may not be removed or altered from any source distribution.
 * NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import XCTest
@testable import DCP
import Hippolyte

class DeviceInformationTest: XCTestCase {

    var homeView: HomeViewController!
     var deviceInformationView: DeviceInformationViewController!
    override func setUp() {
        getHomeViewContoller()
    }
    func getHomeViewContoller()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeView = vc
        let _ = homeView.view
        
    }
    func getDeviceInformationViewContoller()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DeviceInformationViewController") as! DeviceInformationViewController
        deviceInformationView = vc
        let _ = deviceInformationView.view
        
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testForTypeImeiValidImeiResponse()
    {
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/lookup/iOSApp/manual")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"error\": false,\r\n    \"success\": true,\r\n    \"data\": {\r\n        \"statusCode\": 200,\r\n        \"statusMessage\": \"GetHandsetDetails - Success\",\r\n        \"deviceId\": \"35258307\",\r\n        \"brandName\": \"LG\",\r\n        \"modelName\": \"LG-H815L\",\r\n        \"internalModelName\": \"LG LG-H815L\",\r\n        \"marketingName\": \"LG LG-H815L\",\r\n        \"equipmentType\": \"Smartphone\",\r\n        \"simSupport\": \"Not Known\",\r\n        \"nfcSupport\": \"Yes\",\r\n        \"wlanSupport\": \"Yes\",\r\n        \"blueToothSupport\": \"Yes\",\r\n        \"operatingSystem\": [\r\n            \"Android\"\r\n        ],\r\n        \"radioInterface\": [\r\n            \"NONE\"\r\n        ],\r\n        \"lpwan\": \"Not Known\",\r\n        \"deviceCertifybody\": [\r\n            \"Not Known\"\r\n        ],\r\n        \"manufacturer\": \"LG Electronics Inc.\",\r\n        \"tacApprovedDate\": \"2015-05-01\",\r\n        \"gsmaApprovedTac\": \"Yes\"\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.typeImeiViewController?.enterImeiTextField.text = "3525830795465488"
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
        let inputDialogBoxExpectationApi = self.expectation(description: "inputDialogBoxExpectationApi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            inputDialogBoxExpectationApi.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        let typeImeiResultViewControllerExpactions = self.expectation(description: "typeImeiResultViewControllerExpactions")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            typeImeiResultViewControllerExpactions.fulfill()
            
        })
        
        waitForExpectations(timeout: 6, handler: nil)
      //test for device id
        XCTAssertEqual("Device ID".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.deviceIdTV.text)
        
        XCTAssertEqual("3525830795465488", homeView.deviceInformationViewController?.getDeviceViewController?.deviceIdDetailTV.text)
        //test for manufactrurer
        XCTAssertEqual("Manufacturer".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.manufacturedTV.text)
        
        XCTAssertEqual("LG Electronics Inc.", homeView.deviceInformationViewController?.getDeviceViewController?.manufacturedDetailTV.text)
        //test for equipmentType
        XCTAssertEqual("Equipment Type".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.equipmentTypeTV.text)
        
        XCTAssertEqual("Smartphone", homeView.deviceInformationViewController?.getDeviceViewController?.equipmentDetailTV.text)
        
        //test for brand name
        XCTAssertEqual("Brand Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.brandNameTV.text)
        
        XCTAssertEqual("LG", homeView.deviceInformationViewController?.getDeviceViewController?.brandNameDetailTV.text)
        
        //test for MODEL Name
        XCTAssertEqual("Model Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.modelNameTV.text)
        
        XCTAssertEqual("LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.modelNameDetail.text)
        //test for MARKETING Name
        XCTAssertEqual("Marketing Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.marketingNameTV.text)
        
        XCTAssertEqual("LG LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.markeetingNameDetail.text)
        
        //test for internal model Name
        XCTAssertEqual("Internal Model Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.internalModelNameTV.text)
        
        XCTAssertEqual("LG LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.internalModelNameDetailTv.text)
        //test for tac approved date
        XCTAssertEqual("TAC Approved Date".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.tacApprovedDateTV.text)
        
        XCTAssertEqual("2015-05-01", homeView.deviceInformationViewController?.getDeviceViewController?.tacApprovedDateDetailTV.text)
        //test for device certify date
        XCTAssertEqual("Device Certify Body".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.deviceCertifyBodyTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.deviceCertifyDetailTV.text)
        //test for radio Interface
        XCTAssertEqual("Radio Interface".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.radioInterfaceTV.text)
        
        XCTAssertEqual("NONE", homeView.deviceInformationViewController?.getDeviceViewController?.radioInterfaceDetailTv.text)
        //test for operating system
        XCTAssertEqual("Operating System".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.OperatingSystemTV.text)
        
        XCTAssertEqual("Android", homeView.deviceInformationViewController?.getDeviceViewController?.opertaingSystemDetailTV.text)
        //test for sim Support
        XCTAssertEqual("SIM Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.simSupportTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.simSupportDetailTV.text)
        //test for nfc Support
        XCTAssertEqual("NFC Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.nfcSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.nfcSupportDetailTV.text)
        //test for bluetooth Support
        XCTAssertEqual("Bluetooth Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.blurtoothSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.bluetoothSupportDetailTV.text)
        //test for wlan Support
        XCTAssertEqual("WLAN Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.wlanSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.wlanSupportDetailTV.text)
        //test for lwan Support
        XCTAssertEqual("LPWAN".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.lpwanTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.lpwanDetailTV.text)
        
        homeView.deviceInformationViewController?.showHomeVC()
        homeView.deviceInformationViewController?.showNetworkDialogBox()
        
    }
    
    func testForScanImeiValidImeiResponse()
    {
        
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/lookup/iOSApp/scanner")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"error\": false,\r\n    \"success\": true,\r\n    \"data\": {\r\n        \"statusCode\": 200,\r\n        \"statusMessage\": \"GetHandsetDetails - Success\",\r\n        \"deviceId\": \"35258307\",\r\n        \"brandName\": \"LG\",\r\n        \"modelName\": \"LG-H815L\",\r\n        \"internalModelName\": \"LG LG-H815L\",\r\n        \"marketingName\": \"LG LG-H815L\",\r\n        \"equipmentType\": \"Smartphone\",\r\n        \"simSupport\": \"Not Known\",\r\n        \"nfcSupport\": \"Yes\",\r\n        \"wlanSupport\": \"Yes\",\r\n        \"blueToothSupport\": \"Yes\",\r\n        \"operatingSystem\": [\r\n            \"Android\"\r\n        ],\r\n        \"radioInterface\": [\r\n            \"NONE\"\r\n        ],\r\n        \"lpwan\": \"Not Known\",\r\n        \"deviceCertifybody\": [\r\n            \"Not Known\"\r\n        ],\r\n        \"manufacturer\": \"LG Electronics Inc.\",\r\n        \"tacApprovedDate\": \"2015-05-01\",\r\n        \"gsmaApprovedTac\": \"Yes\"\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.scanImeiBtn.sendActions(for: .touchUpInside)
        homeView.scanImeiViewController?.getImei = "3525830795465488"
        homeView.scanImeiViewController?.showScanImeiDialogBoxVC()
        let inputDialogBoxExpectationScanApi = self.expectation(description: "inputDialogBoxExpectationScanApi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            inputDialogBoxExpectationScanApi.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        homeView.language = "vi"
        homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        let scanImeiResultViewControllerExpactions = self.expectation(description: "scanImeiResultViewControllerExpactions")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            scanImeiResultViewControllerExpactions.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        //test for device id
        XCTAssertEqual("Device ID".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.deviceIdTV.text)
        
        XCTAssertEqual("3525830795465488", homeView.deviceInformationViewController?.getDeviceViewController?.deviceIdDetailTV.text)
        //test for manufactrurer
        XCTAssertEqual("Manufacturer".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.manufacturedTV.text)
        
        XCTAssertEqual("LG Electronics Inc.", homeView.deviceInformationViewController?.getDeviceViewController?.manufacturedDetailTV.text)
        //test for equipmentType
        XCTAssertEqual("Equipment Type".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.equipmentTypeTV.text)
        
        XCTAssertEqual("Smartphone", homeView.deviceInformationViewController?.getDeviceViewController?.equipmentDetailTV.text)
        
        //test for brand name
        XCTAssertEqual("Brand Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.brandNameTV.text)
        
        XCTAssertEqual("LG", homeView.deviceInformationViewController?.getDeviceViewController?.brandNameDetailTV.text)
        
        //test for MODEL Name
        XCTAssertEqual("Model Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.modelNameTV.text)
        
        XCTAssertEqual("LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.modelNameDetail.text)
        //test for MARKETING Name
        XCTAssertEqual("Marketing Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.marketingNameTV.text)
        
        XCTAssertEqual("LG LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.markeetingNameDetail.text)
        
        //test for internal model Name
        XCTAssertEqual("Internal Model Name".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.internalModelNameTV.text)
        
        XCTAssertEqual("LG LG-H815L", homeView.deviceInformationViewController?.getDeviceViewController?.internalModelNameDetailTv.text)
        //test for tac approved date
        XCTAssertEqual("TAC Approved Date".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.tacApprovedDateTV.text)
        
        XCTAssertEqual("2015-05-01", homeView.deviceInformationViewController?.getDeviceViewController?.tacApprovedDateDetailTV.text)
        //test for device certify date
        XCTAssertEqual("Device Certify Body".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.deviceCertifyBodyTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.deviceCertifyDetailTV.text)
        //test for radio Interface
        XCTAssertEqual("Radio Interface".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.radioInterfaceTV.text)
        
        XCTAssertEqual("NONE", homeView.deviceInformationViewController?.getDeviceViewController?.radioInterfaceDetailTv.text)
        //test for operating system
        XCTAssertEqual("Operating System".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.OperatingSystemTV.text)
        
        XCTAssertEqual("Android", homeView.deviceInformationViewController?.getDeviceViewController?.opertaingSystemDetailTV.text)
        //test for sim Support
        XCTAssertEqual("SIM Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.simSupportTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.simSupportDetailTV.text)
        //test for nfc Support
        XCTAssertEqual("NFC Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.nfcSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.nfcSupportDetailTV.text)
        //test for bluetooth Support
        XCTAssertEqual("Bluetooth Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.blurtoothSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.bluetoothSupportDetailTV.text)
        //test for wlan Support
        XCTAssertEqual("WLAN Support".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.wlanSupportTV.text)
        
        XCTAssertEqual("Yes", homeView.deviceInformationViewController?.getDeviceViewController?.wlanSupportDetailTV.text)
        //test for lwan Support
        XCTAssertEqual("LPWAN".localized(), homeView.deviceInformationViewController?.getDeviceViewController?.lpwanTV.text)
        
        XCTAssertEqual("Not Known", homeView.deviceInformationViewController?.getDeviceViewController?.lpwanDetailTV.text)
      
        
        
        //test for customDialogBoxView
        XCTAssertEqual("Does the record field match with the device?".localized(), homeView.deviceInformationViewController?.messageOutlet.text)
        //test for yas btn title
        XCTAssertEqual("YES".localized(), homeView.deviceInformationViewController?.yasBtn.currentTitle)
        //test for no report title
       XCTAssertEqual("NO,REPORT".localized(), homeView.deviceInformationViewController?.noBtn.currentTitle)
        
    }
    
    func testForYasBtnApiResponse()
    {
        getDeviceInformationViewContoller()
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/results-matched/35858307123132")!
        var stub = StubRequest(method: .PUT, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"success\": false,\r\n    \"status\": \"results_not_matched\",\r\n    \"message\": \"IMEI marked as not matched\"\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = deviceInformationView
        deviceInformationView.Imei = "35858307123132"
        deviceInformationView.yasBtn.sendActions(for: .touchUpInside)
        
        let yasBtnExpectation = self.expectation(description: " yasBtnExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
             yasBtnExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        
        let successViewController = deviceInformationView.presentedViewController as! SuccessDilogBoxViewController
        XCTAssertEqual("Device status updated successfully".localized(), successViewController.message)
        XCTAssertEqual("Succesful".localized(), successViewController.messagetitle)
        successViewController.okBtn.sendActions(for: .touchUpInside)
        
        
    }
    
    func testForReportDialogBox()
    {
        getDeviceInformationViewContoller()
          UIApplication.shared.keyWindow?.rootViewController = deviceInformationView
        deviceInformationView.backBtn.sendActions(for: .touchUpInside)
        
        let backBtnExpectation = self.expectation(description: "backBtnExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            backBtnExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
          let reportViewController = deviceInformationView.presentedViewController as! ReportDialogBoxViewController
        
        //test for customDialogBoxView
        XCTAssertEqual("Does the record field match with the device?".localized(), reportViewController.messageOutlet.text)
        //test for yas btn title
        XCTAssertEqual("YES".localized(), reportViewController.yasBtn.currentTitle)
        //test for no report title
        XCTAssertEqual("NO,REPORT".localized(), reportViewController.noReportBtn.currentTitle)
        reportViewController.yasBtn.sendActions(for: .touchUpInside)
         reportViewController.noReportBtn.sendActions(for: .touchUpInside)
        reportViewController.showNetworkDialogBox()
        
        
    }
    
    func testForNoReportBtnApiResponse()
    {
        
         getDeviceInformationViewContoller()
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/results-not-matched/35858307123132")!
        var stub = StubRequest(method: .PUT, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"success\": false,\r\n    \"status\": \"results_not_matched\",\r\n    \"message\": \"IMEI marked as not matched\"\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = deviceInformationView
        deviceInformationView.Imei = "35858307123132"
        deviceInformationView.noBtn.sendActions(for: .touchUpInside)
        
        let noReportExpectation = self.expectation(description: "noReportExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
           noReportExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        
        
    }
}
