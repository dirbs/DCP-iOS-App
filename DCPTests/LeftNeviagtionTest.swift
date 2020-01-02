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

class LeftNeviagtionTest: XCTestCase {
    var leftNeviagtionDrawer: NeviagtionDrawerVC!
    override func setUp() {
        getNeviagtionViewContoller()
    }
    func getNeviagtionViewContoller()
    {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        leftNeviagtionDrawer = vc
        let _ = leftNeviagtionDrawer.view
          UIApplication.shared.keyWindow?.rootViewController = leftNeviagtionDrawer
        
    }
    func testForLeftNeviagtionScreen()
    {
        
        if(leftNeviagtionDrawer.flag == true)
        {
        //test for title text
        XCTAssertEqual("Usama Muneer", leftNeviagtionDrawer.userName.text)
         //test for email
        XCTAssertEqual("usama@3gca.org", leftNeviagtionDrawer.emailOutlet.text)
            
         //test for home Image view
            var getHomeImage = UIImage(named: "ic_home")
            XCTAssertEqual(getHomeImage, leftNeviagtionDrawer.homeImageView.image)
            
           //test for history Image view
             var getHistoryImage = UIImage(named: "ic_history")
            XCTAssertEqual(getHistoryImage, leftNeviagtionDrawer.historyImageView.image)
            
            //test for feedback Image view
             var getFeedBackImage = UIImage(named: "ic_input")
            
            XCTAssertEqual(getFeedBackImage, leftNeviagtionDrawer.feedBackImageView.image)
            
            //test for logout Image view
             var getLogoutImage = UIImage(named: "ic_feedback")
            XCTAssertEqual(getLogoutImage, leftNeviagtionDrawer.logoutImageView.image)
            //test for feedback Btn
            XCTAssertEqual("Logout".localized(), leftNeviagtionDrawer.feedbackBtn.currentTitle)
            //test for logout Btn
            XCTAssertEqual("feedBack".localized(), leftNeviagtionDrawer.logoutBtn.currentTitle)
            
        }
        
        //test for Change Language Btn
        leftNeviagtionDrawer.language = "vi"
        leftNeviagtionDrawer.changeLanguageBtn.sendActions(for: .touchUpInside)
        leftNeviagtionDrawer.language = "en"
        leftNeviagtionDrawer.changeLanguageBtn.sendActions(for: .touchUpInside)
        var getImageVitnamese = UIImage(named: "ic_vietnamese")
        XCTAssertEqual(getImageVitnamese, leftNeviagtionDrawer.changeLanguageBtn.image(for: .normal))
         //test for home Btn
         XCTAssertEqual("Home".localized(), leftNeviagtionDrawer.homeBtn.currentTitle)
         //test for history Btn
        XCTAssertEqual("History".localized(), leftNeviagtionDrawer.historyBtn.currentTitle)
       
        leftNeviagtionDrawer.homeBtn.sendActions(for: .touchUpInside)
        leftNeviagtionDrawer.historyBtn.sendActions(for: .touchUpInside)
        leftNeviagtionDrawer.logoutBtn.sendActions(for: .touchUpInside)
       
        leftNeviagtionDrawer.homeBtn.sendActions(for: .touchDown)
        leftNeviagtionDrawer.historyBtn.sendActions(for: .touchDown)
        //leftNeviagtionDrawer.logoutBtn.sendActions(for: .touchDown)
        leftNeviagtionDrawer.feedbackBtn.sendActions(for: .touchDown)
       
    }
    
    func testForLogoutDialogBox()
    {
        
      
        leftNeviagtionDrawer.feedbackBtn.sendActions(for: .touchUpInside)
        
        let leftNeviagtionExpectation = self.expectation(description: "leftNeviagtionExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            leftNeviagtionExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        
        if(leftNeviagtionDrawer.flag == true)
        {
         let inputViewController = leftNeviagtionDrawer.presentedViewController as! LogOutDialogBoxViewController
        //test for title Image view
        var getTitleImage = UIImage(named: "ic_logout")
        XCTAssertEqual(getTitleImage, inputViewController.titleImageView.image)
        
        //test for titles text
        XCTAssertEqual("Logout".localized(), inputViewController.titleOutlet.text)
         //test for message text
         XCTAssertEqual("Are you sure you want to logout?".localized(), inputViewController.messageOutlet.text)
         //test for no btn text
         XCTAssertEqual("NO".localized(), inputViewController.noBtn.currentTitle)
         //test for yas btn text
         XCTAssertEqual("YES".localized(), inputViewController.yasBtn.currentTitle)
        inputViewController.yasBtn.sendActions(for: .touchUpInside)
        inputViewController.noBtn.sendActions(for: .touchUpInside)
        }
        
        
    }
    
}
