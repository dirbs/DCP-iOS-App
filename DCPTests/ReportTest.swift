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
class ReportTest: XCTestCase {
    var reportView: ReportViewController!
    override func setUp() {
        getReportViewController()
    }
    // MARK: Make  getHomeViewController Method
    func getReportViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        reportView = vc
        let _ = reportView.view
    }
    // MARK: Make  testForReportScreen Method
    func testForReportScreen(){
        //test for title text
        XCTAssertEqual("Report Mobile Phone".localized(), reportView.reportMobilePhoneOutlet.text)
        //test for Title of device image
        XCTAssertEqual("Device Image".localized(), reportView.deviceImageOutlet.text)
        //test for mobile Phone Brand textField
        XCTAssertEqual("Mobile Phone Brand".localized(), reportView.mobilePhoneBrandTf!.attributedPlaceholder?.string)
        //test for model Name textField
        XCTAssertEqual("Model Name".localized(), reportView.modelNameTf!.attributedPlaceholder?.string)
        //test for store Name textField
        XCTAssertEqual("Store Name".localized(), reportView.storeNameTf!.attributedPlaceholder?.string)
        //test for store Name textField
        XCTAssertEqual("Address".localized(), reportView.addressTf!.attributedPlaceholder?.string)
        //test for store Name textField
        XCTAssertEqual("Description".localized(), reportView.descriptionTf!.attributedPlaceholder?.string)
        //test for submitBtn
        XCTAssertEqual("SUBMIT".localized(), reportView.submitBtnOutlet.currentTitle)
        //test for select image btn
        XCTAssertEqual("SELECT IMAGES".localized(), reportView.selectImageBtn.currentTitle)
        //test for toot tips btn btn
        var getImageTooTipButtons = UIImage(named: "ic_info1")
        XCTAssertEqual(getImageTooTipButtons, reportView.mobilePhoneBrandBtn.image(for: .normal))
        XCTAssertEqual(getImageTooTipButtons, reportView.storeNameBtn.image(for: .normal))
        XCTAssertEqual(getImageTooTipButtons, reportView.modelNameBtn.image(for: .normal))
        XCTAssertEqual(getImageTooTipButtons, reportView.addressBtn.image(for: .normal))
        XCTAssertEqual(getImageTooTipButtons, reportView.descriptionBtn.image(for: .normal))
        XCTAssertEqual(getImageTooTipButtons, reportView.selectImageDescriptionBtn.image(for: .normal))
    }
    // MARK: Make  testForsubmitBtnWithValidInput Method
    func testForSubmitBtnWithValidInput(){
        //test for mobile Phone brand textfield valid input
        reportView.mobilePhoneBrandTf.text = "samsung"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.mobilePhoneBrandErrorMessage.text)
        XCTAssertTrue((reportView.mobilePhoneBrandErrorMessage.isHidden))
        //test for model name textfield valid input
        reportView.modelNameTf.text = "grand prime"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.modelNameErrorMessage.text)
        XCTAssertTrue((reportView.modelNameErrorMessage.isHidden))
        //test for store name textfield invalid input
        reportView.storeNameTf.text = "f 7/2"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.storeNameErrorMessage.text)
        XCTAssertTrue((reportView.storeNameErrorMessage.isHidden))
        //test for address textfield valid input
        reportView.addressTf.text = "Block 5c flat 4 pims colony"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.addressErrorMessage.text)
        XCTAssertTrue((reportView.addressErrorMessage.isHidden))
        //test for description textfield valid input
        reportView.descriptionTf.text = "it is a software house"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.descriptionErrorMessage.text)
        XCTAssertTrue((reportView.descriptionErrorMessage.isHidden))
    }
    // MARK: Make  testForsubmitBtnWithInValidInput Method
    func testForSubmitBtnWithInValidInput(){
        //test for mobile Phone brand textfield invalid input
        reportView.mobilePhoneBrandTf.text = ""
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.mobilePhoneBrandErrorMessage.text)
        XCTAssertFalse((reportView.mobilePhoneBrandErrorMessage.isHidden))
        //test for model name textfield invalid input
        reportView.modelNameTf.text = ""
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.modelNameErrorMessage.text)
        XCTAssertFalse((reportView.modelNameErrorMessage.isHidden))
        //test for store name textfield invalid input
        reportView.storeNameTf.text = ""
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.storeNameErrorMessage.text)
        XCTAssertFalse((reportView.storeNameErrorMessage.isHidden))
        //test for address textfield invalid input
        reportView.addressTf.text = ""
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.addressErrorMessage.text)
        XCTAssertFalse((reportView.addressErrorMessage.isHidden))
        //test for description textfield invalid input
        reportView.descriptionTf.text = ""
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        XCTAssertEqual("can't be empty!".localized(), reportView.descriptionErrorMessage.text)
        XCTAssertFalse((reportView.descriptionErrorMessage.isHidden))
        //test for others
        reportView.saveReportDate()
        reportView.getSaveData()
        reportView.showNetworkDialogBox()
        reportView.showPermissionDialogBox()
        reportView.showCamerPermissionDialogBox()
    }
    // MARK: Make  testForToolTips Method
    func testForToolTips(){
        reportView.mobilePhoneBrandBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Enter the valid brand name of the device".localized(), reportView.popTip.text)
        reportView.modelNameBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Enter the valid model name of the device".localized(), reportView.popTip.text)
        reportView.storeNameBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Enter the valid store name of the device".localized(), reportView.popTip.text)
        reportView.addressBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Enter the valid address where the device is located.".localized(), reportView.popTip.text)
        reportView.descriptionBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Add description for your device".localized(), reportView.popTip.text)
        reportView.selectImageDescriptionBtn.sendActions(for: .touchUpInside)
        XCTAssertEqual("Upload valid images of the device".localized(), reportView.popTip.text)
    }
    // MARK: Make  testForSelectImageBtn Method
    func testForSelectImageBtn(){
        UIApplication.shared.keyWindow!.rootViewController = reportView
        let Image1 = UIImage(named: "ic_home")
        let Image2 = UIImage(named: "ic_history")
        let Image3 = UIImage(named: "ic_history")
        reportView.arrayOfImage.append(Image1!)
        reportView.arrayOfImage.append(Image2!)
        reportView.arrayOfImage.append(Image3!)
        reportView.collectionView.reloadData()
        let leftNeviagtionExpectation = self.expectation(description: "leftNeviagtionExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            leftNeviagtionExpectation.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        let indexPath1 = IndexPath(item: 0, section: 0)
        let cell1 = reportView.collectionView.cellForItem(at: indexPath1) as! CollectionViewCell
        XCTAssertEqual(reportView.arrayOfImage[0], cell1.imageView.image)
        let indexPath2 = IndexPath(item: 1, section: 0)
        let cell2 = reportView.collectionView.cellForItem(at: indexPath2) as! CollectionViewCell
        XCTAssertEqual(reportView.arrayOfImage[1], cell2.imageView.image)
        let indexPath3 = IndexPath(item: 2, section: 0)
        let cell3 = reportView.collectionView.cellForItem(at: indexPath3) as! CollectionViewCell
        XCTAssertEqual(reportView.arrayOfImage[2], cell3.imageView.image)
        cell3.backBtn.sendActions(for: .touchUpInside)
    }
    // MARK: Make  testForReportApiResponse Method
    func testForReportApiResponse(){
        let url = URL(string: "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/api/counterfiet")!
        var stub = StubRequest(method: .POST, url: url)
        var response = StubResponse()
        let body = "{\r\n  \"success\" : true,\r\n  \"message\" : \"The device has been reported as counterfeit.\"\r\n}"
        response.body = body.data(using: .utf8)!
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        Constants.Base_Url = "http://ec2-34-220-143-232.us-west-2.compute.amazonaws.com:81/"
        UIApplication.shared.keyWindow?.rootViewController = reportView
        reportView.mobilePhoneBrandTf.text = "First App"
        reportView.modelNameTf.text = "First App"
        reportView.storeNameTf.text = "First App"
        reportView.addressTf.text = "First App"
        reportView.descriptionTf.text = "First App"
        reportView.submitBtnOutlet.sendActions(for: .touchUpInside)
        let reportExpectation = self.expectation(description: "reportExpectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            reportExpectation.fulfill()
        })
        waitForExpectations(timeout: 6, handler: nil)
        let inputViewController = reportView.presentedViewController as! SuccessDilogBoxViewController
        XCTAssertEqual("Reported".localized(), inputViewController.titleOutlet.text)
        XCTAssertEqual("The device has been reported as counterfeit.", inputViewController.messageOutlet.text)
        inputViewController.okBtn.sendActions(for: .touchUpInside)
    }
}
