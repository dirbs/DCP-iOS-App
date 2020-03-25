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
class ResultTest: XCTestCase {
    var homeView: HomeViewController!
    override func setUp() {
        getHomeViewController()
    }
    // MARK: Make  testForTypeImei Method
    func getHomeViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeView = vc
        let _ = homeView.view
    }
    // MARK: Make  testForTypeImeiIValidResponse Method
    func testForTypeImeiInvalidImeiResponse(){
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/lookup/iOSApp/manual")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"error\": false,\r\n    \"success\": true,\r\n    \"data\": {\r\n        \"statusCode\": 200,\r\n        \"statusMessage\": \"GetHandsetDetails - Success\",\r\n        \"deviceId\": \"55555555\",\r\n        \"brandName\": \"NA\",\r\n        \"modelName\": \"NA\",\r\n        \"internalModelName\": \"NA\",\r\n        \"marketingName\": \"NA\",\r\n        \"equipmentType\": \"NA\",\r\n        \"simSupport\": \"NA\",\r\n        \"nfcSupport\": \"NA\",\r\n        \"wlanSupport\": \"NA\",\r\n        \"blueToothSupport\": \"NA\",\r\n        \"operatingSystem\": [],\r\n        \"radioInterface\": [],\r\n        \"lpwan\": \"NA\",\r\n        \"deviceCertifybody\": [],\r\n        \"manufacturer\": \"NA\",\r\n        \"tacApprovedDate\": \"NA\",\r\n        \"gsmaApprovedTac\": \"No\"\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.typeImeiViewController?.enterImeiTextField.text = "555555555555555"
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
        let inputViewController = homeView.presentedViewController as! ResultViewController
        if(inputViewController.language == "en"){
            var messages = "555555555555555" + " " + "not found in database. This device may be" + "\n" + "counterfeit or illegal. Please report this device through DCP!" + "\n\n" + "To fill the form press Report Mobile " + "\n" + "Phone"
            XCTAssertEqual("IMEI not found!".localized(), inputViewController.titleOutlet.text!)
            XCTAssertEqual(messages, inputViewController.responseMessageOutlet.text!)
        }
        else{
            var messages = "555555555555555" + " " + "không tìm thấy trong cơ sở dữ liệu. Thiết bị này có thể là hàng giả hoặc bất hợp pháp. Vui lòng báo cáo thiết bị này qua DCP!" + "\n\n" + "Để điền vào biểu mẫu nhấn Báo cáo" + "\n" + "Điện thoại di động."
            XCTAssertEqual("IMEI not found!".localized(), inputViewController.titleOutlet.text!)
            XCTAssertEqual(messages, inputViewController.responseMessageOutlet.text!)
        }
        XCTAssertEqual("REPORT MOBILE PHONE".localized(), inputViewController.reportMobilePhoneBtn.currentTitle)
    }
    // MARK: Make  testForScanImeiIValidResponse Method
    func testForScanImeiInvalidImeiResponse(){
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/lookup/iOSApp/scanner")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"error\": false,\r\n    \"success\": true,\r\n    \"data\": {\r\n        \"statusCode\": 200,\r\n        \"statusMessage\": \"GetHandsetDetails - Success\",\r\n        \"deviceId\": \"55555555\",\r\n        \"brandName\": \"NA\",\r\n        \"modelName\": \"NA\",\r\n        \"internalModelName\": \"NA\",\r\n        \"marketingName\": \"NA\",\r\n        \"equipmentType\": \"NA\",\r\n        \"simSupport\": \"NA\",\r\n        \"nfcSupport\": \"NA\",\r\n        \"wlanSupport\": \"NA\",\r\n        \"blueToothSupport\": \"NA\",\r\n        \"operatingSystem\": [],\r\n        \"radioInterface\": [],\r\n        \"lpwan\": \"NA\",\r\n        \"deviceCertifybody\": [],\r\n        \"manufacturer\": \"NA\",\r\n        \"tacApprovedDate\": \"NA\",\r\n        \"gsmaApprovedTac\": \"No\"\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.scanImeiBtn.sendActions(for: .touchUpInside)
        homeView.scanImeiViewController?.getImei = "555555555555555"
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
        let inputViewController = homeView.presentedViewController as! ResultViewController
        if(inputViewController.language == "en"){
            var messages = "555555555555555" + " " + "not found in database. This device may be" + "\n" + "counterfeit or illegal. Please report this device through DCP!" + "\n\n" + "To fill the form press Report Mobile " + "\n" + "Phone"
            XCTAssertEqual("IMEI not found!".localized(), inputViewController.titleOutlet.text!)
            XCTAssertEqual(messages, inputViewController.responseMessageOutlet.text!)
        }
        else{
            var messages = "555555555555555" + " " + "không tìm thấy trong cơ sở dữ liệu. Thiết bị này có thể là hàng giả hoặc bất hợp pháp. Vui lòng báo cáo thiết bị này qua DCP!" + "\n\n" + "Để điền vào biểu mẫu nhấn Báo cáo" + "\n" + "Điện thoại di động."
            XCTAssertEqual("IMEI not found!".localized(), inputViewController.titleOutlet.text!)
            XCTAssertEqual(messages, inputViewController.responseMessageOutlet.text!)
        }
        XCTAssertEqual("REPORT MOBILE PHONE".localized(), inputViewController.reportMobilePhoneBtn.currentTitle)
        inputViewController.reportMobilePhoneBtn.sendActions(for: .touchUpInside)
    }
}
