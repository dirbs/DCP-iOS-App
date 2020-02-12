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
class HomeTest: XCTestCase {
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
    // MARK: Make  testForHomeScreen Method
   func testForHomeScreen(){
        //test for title text
        XCTAssertEqual("Home".localized(), homeView.dcpToolBar.title)
         //test for menueBtn
         var getIconBtn = IconButton(image: Icon.cm.menu, tintColor: .white)
        XCTAssertEqual(getIconBtn.image, homeView.menuButton.image)
        homeView.menuButton.sendActions(for: .touchUpInside)
     //test for InfoImage view
        var getInfoImage = UIImage(named: "ic_info")
        XCTAssertEqual(getInfoImage, homeView.infoImageView.image)
        //test for Instruction title
        XCTAssertEqual("Instructions".localized(), homeView.instructionOutlet.text)
        //test for scan Imei Btn title
        XCTAssertEqual("SCAN IMEI".localized(), homeView.scanImeiBtn.currentTitle)
        //test for typeIme Btn title
        XCTAssertEqual("TYPE IMEI".localized(), homeView.typeImeiBtn.currentTitle)
        //test for description Message
        XCTAssertEqual("The IMEI (International Mobile Equipment Identity) is a globally unique number to identify any SIM based mobile device. You can view the mobile phone's IMEI by pressing *#06# on dialpad of the device. If the device has two simcards, you will see two 14-16 digit codes. Enter the 14-16 digit IMEI number in the box and click on the check  box to view its detail.".localized(), homeView.paragraphOutlet.text)
        homeView.showNetworkDialogBox(flag: false)
    }

}
