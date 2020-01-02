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
   
    func testForScanInputDialogBox()
    {
        
        
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.scanImeiBtn.sendActions(for: .touchUpInside)
        homeView.scanImeiViewController?.getImei = "123456789234567"
        homeView.scanImeiViewController?.showScanImeiDialogBoxVC()
        let scanInputDialogBoxExpectation = self.expectation(description: "scanInputDialogBoxExpectation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            scanInputDialogBoxExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 6, handler: nil)
        XCTAssertEqual("Scan Result".localized(), homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField!.attributedPlaceholder?.string)
        
        //test for enterImeiTextField
        XCTAssertEqual("123456789234567", homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField.text)
        
        
        //test for Imei text field with integar input
        homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField.text = "12345"
        homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
        XCTAssertFalse((homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        
        //test for Imei text field with empty input
        homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField.text = ""
        homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
        XCTAssertFalse((homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        
        //test for Imei text field with alphanumeric input
        homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField.text = "rtyryy"
        homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("IMEI must only contain numbers".localized(), homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
        XCTAssertFalse((homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        
        //test for Imei text field with valid input
        homeView.scanImeiViewController?.inputDialogBox?.enterImeiTextField.text = "123456789123456"
        homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.text!)
        XCTAssertTrue((homeView.scanImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        //test for title text
        XCTAssertEqual(  "Verify Scan".localized(), homeView.scanImeiViewController?.inputDialogBox?.titleOutlet.text!)
        //test for message text
        XCTAssertEqual( "Please verify IMEI number from scan and  press OK to continue".localized(), homeView.scanImeiViewController?.inputDialogBox?.messageOutlet.text)
        //test for ok btn title
        XCTAssertEqual("OK".localized(), homeView.scanImeiViewController?.inputDialogBox?.okBtnOutlet.currentTitle)
        //test for ok cancelBtn title
        XCTAssertEqual("CANCEL".localized(), homeView.scanImeiViewController?.inputDialogBox?.cancelBtnOutlet.currentTitle)
        //test for flash Button
        homeView.scanImeiViewController?.flashLightBtn.sendActions(for: .touchUpInside)
        homeView.scanImeiViewController?.flashLightBtn.sendActions(for: .touchUpInside)
    }
     
}
