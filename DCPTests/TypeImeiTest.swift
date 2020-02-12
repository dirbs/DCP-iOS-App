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
class TypeImeiTest: XCTestCase {
    var homeView: HomeViewController!
    override func setUp() {
        getHomeViewContoller()
    }
    // MARK: Make  getHomeViewController Method
    func getHomeViewContoller(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeView = vc
        let _ = homeView.view
        
    }
    // MARK: Make  testForTypeImei Method
    func testForTypeImei(){
        homeView.typeImeiBtn.sendActions(for: .touchUpInside)
        //test for enterImei placeholder
        XCTAssertEqual("Enter IMEI e.g. 123456789012345".localized(), homeView.typeImeiViewController?.enterImeiTextField!.attributedPlaceholder?.string)
        //test for Imei text field check Btn
        XCTAssertEqual("CHECK".localized(), homeView.typeImeiViewController?.checkBtn.currentTitle)
        //test for Imei text field with integar input
        homeView.typeImeiViewController?.enterImeiTextField.text = "12345"
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
        homeView.typeImeiViewController?.stateSaveValidation()
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.typeImeiViewController?.errorMessage.text)
        XCTAssertFalse((homeView.typeImeiViewController?.errorMessage.isHidden)!)
        //test for Imei text field with empty input
        homeView.typeImeiViewController?.enterImeiTextField.text = ""
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
          homeView.typeImeiViewController?.stateSaveValidation()
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.typeImeiViewController?.errorMessage.text)
        XCTAssertFalse((homeView.typeImeiViewController?.errorMessage.isHidden)!)
        //test for Imei text field with alphanumeric input
        homeView.typeImeiViewController?.enterImeiTextField.text = "rtyryy"
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
          homeView.typeImeiViewController?.stateSaveValidation()
        XCTAssertEqual("IMEI must only contain numbers".localized(), homeView.typeImeiViewController?.errorMessage.text)
        XCTAssertFalse((homeView.typeImeiViewController?.errorMessage.isHidden)!)
        //test for Imei text field with valid input
        homeView.typeImeiViewController?.enterImeiTextField.text = "123456789123456"
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
          homeView.typeImeiViewController?.stateSaveValidation()
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.typeImeiViewController?.errorMessage.text)
        XCTAssertTrue((homeView.typeImeiViewController?.errorMessage.isHidden)!)
        homeView.typeImeiViewController?.textFieldDidBeginEditing((homeView.typeImeiViewController?.enterImeiTextField)!)
        homeView.typeImeiViewController?.doneBtnPressed()
    }
     // MARK: Make  testForTypeImei Method
    func testForInputDialogBox(){
        UIApplication.shared.keyWindow?.rootViewController = homeView
        homeView.typeImeiViewController?.enterImeiTextField.text = "12345678978787"
        homeView.typeImeiViewController?.checkBtn.sendActions(for: .touchUpInside)
        let inputDialogBoxExpectation = self.expectation(description: "inputDialogBoxExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            
            inputDialogBoxExpectation.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        //test for enterImei placeholder
        XCTAssertEqual("IMEI".localized(), homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField!.attributedPlaceholder?.string)
        //test for enterImeiTextField
        XCTAssertEqual("12345678978787", homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField.text)
        //test for Imei text field with integar input
        homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField.text = "12345"
    homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
    XCTAssertFalse((homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        
        //test for Imei text field with empty input
        homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField.text = ""
    homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(), homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
    XCTAssertFalse((homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        //test for Imei text field with alphanumeric input
        homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField.text = "rtyryy"
   homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
       XCTAssertEqual("IMEI must only contain numbers".localized(), homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.text)
    XCTAssertFalse((homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        
        //test for Imei text field with valid input
        homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField.text = "123456789123456"
    homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("Please enter 14-16 digit IMEI".localized(),homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.text!)
    XCTAssertTrue((homeView.typeImeiViewController?.inputDialogBox?.errorMessageOutlet.isHidden)!)
        //test for title text
        XCTAssertEqual( "Verify Input".localized(), homeView.typeImeiViewController?.inputDialogBox?.titleOutlet.text!)
        //test for message text
        XCTAssertEqual("Please verify IMEI number you entered.Press OK to continue or CANCAL to re-enter".localized(), homeView.typeImeiViewController?.inputDialogBox?.messageOutlet.text)
        //test for ok btn title
        XCTAssertEqual("OK".localized(), homeView.typeImeiViewController?.inputDialogBox?.okBtnOutlet.currentTitle)
        //test for ok cancelBtn title
        XCTAssertEqual("CANCEL".localized(), homeView.typeImeiViewController?.inputDialogBox?.cancelBtnOutlet.currentTitle)
        //test for others
         homeView.typeImeiViewController?.inputDialogBox?.animateViewMoving(up: true, moveValue: 20)
    homeView.typeImeiViewController?.inputDialogBox?.textFieldDidEndEditing((homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField)!)
        homeView.typeImeiViewController?.inputDialogBox?.doneBtnPressed()
    homeView.typeImeiViewController?.inputDialogBox?.textFieldDidBeginEditing((homeView.typeImeiViewController?.inputDialogBox?.enterImeiTextField)!)
        homeView.typeImeiViewController?.inputDialogBox?.cancelBtnOutlet.sendActions(for: .touchUpInside)
        
    }    
}
