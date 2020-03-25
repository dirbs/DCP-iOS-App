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
class FeedBackTest: XCTestCase {
    var feedbackView: FeedBackViewController!
    override func setUp() {
        getHomeViewController()
    }
    // MARK: Make  getHomeViewController Method
    func getHomeViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackViewController") as! FeedBackViewController
        feedbackView = vc
        let _ = feedbackView.view
        
    }
    // MARK: Make  testForFeedBackScreen Method
    func testForFeedBackScreen(){
        //test for title label
        XCTAssertEqual("feedBack".localized(), feedbackView.dcpFeedBackTitleOutlet.text)
        //test for title label
        XCTAssertEqual( "Send Feedback".localized(), feedbackView.feedbackTitle.text)
        //test for submit feedback Btn
        XCTAssertEqual("SUBMIT FEEDBACK".localized(), feedbackView.submitFeedBackBtn.currentTitle)
        //test for Feedback textfield invalid input
        feedbackView.feedBackTextView.text = ""
        feedbackView.submitFeedBackBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), feedbackView.errorMessage.text)
        XCTAssertFalse((feedbackView.errorMessage.isHidden))
        XCTAssertEqual("0 / 255", feedbackView.countOutlet.text)
        //test for Feedback textfield Valid input
        feedbackView.feedBackTextView.text = "First App"
        feedbackView.submitFeedBackBtn.sendActions(for: .touchUpInside)
        //feedbackView.feedBackTextView.adjustedContentInsetDidChange()
        XCTAssertEqual("can't be empty!".localized(), feedbackView.errorMessage.text)
        //XCTAssertTrue((feedbackView.errorMessage.isHidden))
        XCTAssertEqual("0 / 255", feedbackView.countOutlet.text)
        //test for others
        feedbackView.showNetworkDialogBox()
        feedbackView.doneBtnPressed()
    }
    // MARK: Make  testForFeedBackApiResponse Method
    func testForFeedbackApiResponse(){
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/feedback")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n  \"message\" : \"Feedback submitted successfully.\",\r\n  \"success\" : true\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = feedbackView
        feedbackView.feedBackTextView.text = "First App"
        feedbackView.submitFeedBackBtn.sendActions(for: .touchUpInside)
        let feedBackExpectation = self.expectation(description: "feedBackExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            feedBackExpectation.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        let inputViewController = feedbackView.presentedViewController as! SuccessDilogBoxViewController
        XCTAssertEqual("Feedback sent.".localized(), inputViewController.titleOutlet.text)
        XCTAssertEqual("Feedback submitted successfully.", inputViewController.messageOutlet.text)
        inputViewController.okBtn.sendActions(for: .touchUpInside)
        feedbackView.backBtn.sendActions(for: .touchUpInside)
    }
}
