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
class HistoryTest: XCTestCase {
    var historyView: HistoryViewController!
    override func setUp() {
        getHistoryViewController()
    }
    // MARK: Make  get history view controller Method
    func getHistoryViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        historyView = vc
        let _ = historyView.view
        UIApplication.shared.keyWindow?.rootViewController = historyView
    }
    
    // MARK: Make override testForHistoryScreen Method
    func testForHistoryScreen(){
        //test for title text
         XCTAssertEqual("History".localized(), historyView.historyTitle.text)
        XCTAssertEqual("History".localized(), historyView.titleOutlet.text)
        //test for search Image view
        var getsearchImage = UIImage(named: "ic_action_search")
        XCTAssertEqual(getsearchImage, historyView.searchBtn.image(for: .normal))
        historyView.searchBtn.sendActions(for: .touchUpInside)
    }
    // MARK: Make override testForApiResponse Method
    func testForApiResponse(){
       
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/datatable/my-activity?page=59")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"activity\": {\r\n        \"current_page\": 59,\r\n        \"data\": [\r\n            {\r\n                \"id\": 2,\r\n                \"user_device\": \"IosApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"358834060077252                                                                                                                                                                                                                                                \",\r\n                \"result\": \"Valid\",\r\n                \"results_matched\": \"No\",\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-02 11:57:39\",\r\n                \"updated_at\": \"2019-12-19 09:46:49\",\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            }\r\n        ],\r\n        \"first_page_url\": \"\",\r\n        \"from\": 871,\r\n        \"last_page\": 59,\r\n        \"last_page_url\": \"\",\r\n        \"next_page_url\": null,\r\n        \"path\": \"\",\r\n        \"per_page\": 15,\r\n        \"prev_page_url\": \"\",\r\n        \"to\": 871,\r\n        \"total\": 871,\r\n        \"searchTerm\": \"\"\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
       
        let historyExpectationApi = self.expectation(description: "historyExpectationApi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            historyExpectationApi.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        
        
        
    }
    // MARK: Make  testForSearchApiResponse Method
    func testForSearchApiResponse(){
        
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/search_users_activity?page=1")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n    \"activity\": {\r\n        \"current_page\": 1,\r\n        \"data\": [\r\n            {\r\n                \"id\": 913,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"39.40.104.49\",\r\n                \"created_at\": \"2019-12-26 11:40:04\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"24.900500\",\r\n                \"longitude\": \"67.168200\",\r\n                \"city\": \"Karachi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"SD\",\r\n                \"state_name\": \"Sindh\"\r\n            },\r\n            {\r\n                \"id\": 912,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"39.40.104.49\",\r\n                \"created_at\": \"2019-12-26 07:34:33\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"24.900500\",\r\n                \"longitude\": \"67.168200\",\r\n                \"city\": \"Karachi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"SD\",\r\n                \"state_name\": \"Sindh\"\r\n            },\r\n            {\r\n                \"id\": 908,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"555555555555555                                                                                                                                                                                                                                                \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-24 09:07:35\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            },\r\n            {\r\n                \"id\": 907,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"555555555555555                                                                                                                                                                                                                                                \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-24 06:35:23\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            },\r\n            {\r\n                \"id\": 905,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"39.40.104.49\",\r\n                \"created_at\": \"2019-12-23 06:52:31\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"24.900500\",\r\n                \"longitude\": \"67.168200\",\r\n                \"city\": \"Karachi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"SD\",\r\n                \"state_name\": \"Sindh\"\r\n            },\r\n            {\r\n                \"id\": 904,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"39.40.104.49\",\r\n                \"created_at\": \"2019-12-23 06:52:10\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"24.900500\",\r\n                \"longitude\": \"67.168200\",\r\n                \"city\": \"Karachi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"SD\",\r\n                \"state_name\": \"Sindh\"\r\n            },\r\n            {\r\n                \"id\": 903,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-20 10:36:46\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            },\r\n            {\r\n                \"id\": 899,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"555555555555555                                                                                                                                                                                                                                                \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-20 10:06:32\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            },\r\n            {\r\n                \"id\": 897,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-20 09:59:50\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            },\r\n            {\r\n                \"id\": 895,\r\n                \"user_device\": \"iOSApp\",\r\n                \"checking_method\": \"manual\",\r\n                \"imei_number\": \"5555555555555555                                                                                                                                                                                                                                               \",\r\n                \"result\": \"Invalid\",\r\n                \"results_matched\": null,\r\n                \"user_id\": 3,\r\n                \"user_name\": \"Usama\",\r\n                \"visitor_ip\": \"203.99.181.111\",\r\n                \"created_at\": \"2019-12-20 09:59:20\",\r\n                \"updated_at\": null,\r\n                \"latitude\": \"33.607900\",\r\n                \"longitude\": \"73.100400\",\r\n                \"city\": \"Rawalpindi\",\r\n                \"country\": \"Pakistan\",\r\n                \"state\": \"PB\",\r\n                \"state_name\": \"Punjab\"\r\n            }\r\n        ],\r\n        \"first_page_url\": \"\",\r\n        \"from\": 1,\r\n        \"last_page\": 28,\r\n        \"last_page_url\": \"\",\r\n        \"next_page_url\": \"\",\r\n        \"path\": \"\",\r\n        \"per_page\": 10,\r\n        \"prev_page_url\": null,\r\n        \"to\": 10,\r\n        \"total\": 277\r\n    }\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        historyView.searchTF.text = "5555555"
        historyView.search()
        let historyExpectationApi = self.expectation(description: "historyExpectationApi")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            historyExpectationApi.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        let indexPath1 = IndexPath(item: 0, section: 0)
        let cell1 = historyView.historyTableView.cellForRow(at: indexPath1) as! HistoryTableViewCell
        XCTAssertEqual(historyView.user_id[0], cell1.idOutlet.text)
        XCTAssertEqual(historyView.user_name[0], cell1.userNameOutlet.text)
        XCTAssertEqual(historyView.user_device[0], cell1.user_device_Outlet.text)
        XCTAssertEqual(historyView.date[0], cell1.dateOutlet.text)
        XCTAssertEqual(historyView.visitor_ip[0], cell1.visitor_ip_outlet.text)
        historyView.searchTF.text = "5555555"
        historyView.search()
        // UIApplication.shared.keyWindow?.rootViewController = historyView
        let historyExpectationApi1 = self.expectation(description: "historyExpectationApi1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            historyExpectationApi1.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
    }
}
