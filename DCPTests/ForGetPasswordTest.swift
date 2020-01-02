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
class ForGetPasswordTest: XCTestCase {
    var loginView : LoginViewController!
    var forgotPasswordView : ForgotPasswordViewController!
    override func setUp() {
        getLoginViwcontroller()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

  
    func getLoginViwcontroller()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginView = vc
        let _ = loginView.view
    }
    
    func testForForgotPasswordBtn()
    {
        
        UIApplication.shared.keyWindow?.rootViewController = loginView
        loginView.forgotPasswordBtn.sendActions(for: .touchUpInside)
        let forgotpasswordExpectation = self.expectation(description: "forgotpasswordExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            forgotpasswordExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        
        //test for title and message outlet
        XCTAssertEqual("Reset Password".localized(), loginView.forgotPasswordViewController?.titleOutlet.text!)
        XCTAssertEqual("Please enter your email address to reset your Password".localized(), loginView.forgotPasswordViewController?.messageOutlet.text!)
        
        //test for ok and cancel Btn
        XCTAssertEqual("OK".localized(), loginView.forgotPasswordViewController?.okBtn.currentTitle)
        XCTAssertEqual("CANCEL".localized(), loginView.forgotPasswordViewController?.cancelBtn.currentTitle)
        
        //test For empty Strings
        loginView.forgotPasswordViewController?.okBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Can't be empty!".localized(),loginView.forgotPasswordViewController?.emailErrorMessage.text!)
        //test For invalid email Strings
        loginView.forgotPasswordViewController?.emailTF.text = "shamas@3gca.0rg"
        loginView.forgotPasswordViewController?.okBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Invalid email!".localized(),loginView.forgotPasswordViewController?.emailErrorMessage.text!)
        //test For valid email Strings
        loginView.forgotPasswordViewController?.emailTF.text = "shamas@3gca.org"
        loginView.forgotPasswordViewController?.okBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Invalid email!".localized(),loginView.forgotPasswordViewController?.emailErrorMessage.text!)
        XCTAssert((loginView.forgotPasswordViewController?.emailErrorMessage.isHidden)!)
        loginView.forgotPasswordViewController?.showNetworkDialogBox()
        loginView.forgotPasswordViewController?.textFieldDidBeginEditing((loginView.forgotPasswordViewController?.emailTF)!)
        loginView.forgotPasswordViewController?.textFieldDidEndEditing((loginView.forgotPasswordViewController?.emailTF)!)
            loginView.forgotPasswordViewController?.cancelBtn.sendActions(for: .touchUpInside)
        loginView.forgotPasswordViewController?.doneBtnPressed()
    }
    func testForForgotPasswordApiResponse()
{
    let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/recover")!
    var stub = StubRequest(method: .POST, url: url)
    var response = StubResponse()
    let body = " \"error\": true,\r\n    \"message\": \"You do not have enough permissions for this request, please contact system administrator for more details\""
    response.body = body.data(using: .utf8)!
    stub.response = response
    Hippolyte.shared.add(stubbedRequest: stub)
    Hippolyte.shared.start()
    Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
    
    UIApplication.shared.keyWindow?.rootViewController = loginView
    loginView.forgotPasswordBtn.sendActions(for: .touchUpInside)
    let forgotpasswordExpectation = self.expectation(description: "forgotpasswordExpectation")
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
        
        forgotpasswordExpectation.fulfill()
    })
    
    waitForExpectations(timeout: 6, handler: nil)
    
    loginView.forgotPasswordViewController?.emailTF.text = "shamas@3gca.org"
    loginView.forgotPasswordViewController?.okBtn.sendActions(for: .touchUpInside)
   
    let successDialogBox = self.expectation(description: "successDialogBox")

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {

        successDialogBox.fulfill()
    })

    waitForExpectations(timeout: 2, handler: nil)
    let inputViewController = loginView.presentedViewController as! SuccessDilogBoxViewController
    XCTAssertEqual( "Succesful".localized(), inputViewController.titleOutlet.text)
    XCTAssertEqual("A reset email has been sent! Please check your email".localized(), inputViewController.messageOutlet.text)
    // XCTAssertEqual("Feedback sent.".localized(), inputViewController.titleOutlet.text)
    inputViewController.okBtn.sendActions(for: .touchUpInside)
    }
    
}
