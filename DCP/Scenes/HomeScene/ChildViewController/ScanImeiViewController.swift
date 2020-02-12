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
import UIKit
import MTBBarcodeScanner
struct Platform {
    static let isSimulator: Bool = {
        #if arch(i386) || arch(x86_64)
        return true
        #endif
        return false
    }()
}
class ScanImeiViewController: UIViewController {
    // Outlet
    @IBOutlet var flashLightBtn: UIButton!
    @IBOutlet var buttomView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var rightView: UIView!
    @IBOutlet var leftView: UIView!
    @IBOutlet var scanView: UIView!
    var scanner: MTBBarcodeScanner?
    //Variables
    var modelType = ""
    var readString =  ""
    var getImei = ""
    var typeImei = ""
    var checkBtnFlag = false
    var   scanImei = ""
    var inputDialogBox: inputDialogBoxViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()  // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.scanner?.stopScanning()
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Platform.isSimulator {
            
        } else {
            
            creatCameraView()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    // MARK: Make setUpView Method
    func  setUpView(){
        //set background color transpernet
        view.frame = CGRect(x: 0, y: 0, width: 70, height: 80)
        leftView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        topView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        buttomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        rightView .backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: Make flashLightBtnClick Method
    @IBAction func flashLightBtnClick(_ sender: UIButton) {
        if let ButtonImage = flashLightBtn.image(for: .normal),
            let Image = UIImage(named: "ic_flash_off"),
            ButtonImage.pngData() == Image.pngData(){
            flashLightBtn.setImage(UIImage(named: "ic_flash_on"), for: .normal)
            self.scanner?.torchMode = MTBTorchMode.on
        } else {
            flashLightBtn.setImage(UIImage(named: "ic_flash_off"), for: .normal)
            self.scanner?.torchMode = MTBTorchMode.off
        }
    }
    // MARK: Make creatCameraView Method
    func creatCameraView() {
        scanner = MTBBarcodeScanner(previewView: self.view
        )
        self.scanner?.didStartScanningBlock = {
            self.scanner?.scanRect = CGRect(center: (self.view.bounds.center), size: CGSize(width: self.scanView.frame.size.width, height: 145))
            MyVariables.scannerVisible = true
        }
        self.scanner?.allowTapToFocus = false
        do {
            try self.scanner?.startScanning(resultBlock: { codes in
                if let codes = codes {
                    for code in codes {
                        let stringValue = code.stringValue!
                        print("Found code: \(stringValue)")
                        self.readString = stringValue
                        if(self.readString.count >= 14) {                                let index = self.readString.index(stringValue.startIndex, offsetBy: 15)
                            let mySubstring = self.readString.prefix(upTo: index)
                            self.getImei = String(mySubstring)
                        } else {
                            self.getImei = self.readString
                        }
                        self.scanner?.stopScanning()
                        self.showScanImeiDialogBoxVC()
                        
                    }
                }
            })
        } catch {
            NSLog("Unable to start scanning")
        }
    }
    // MARK: Make showScanImeiDialogBoxVC Method
    func showScanImeiDialogBoxVC() {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "inputDialogBoxViewController") as!  inputDialogBoxViewController
        userVC.titleText = "Verify Scan".localized()
        userVC.messageTitle = "Please verify IMEI number from scan and  press OK to continue".localized()
        userVC.enterImeiTextFieldPlaceholder = "Scan Result".localized()
        userVC.sharedFlag = true
        userVC.getImei = getImei
        inputDialogBox = userVC
        userVC.scanImeicallBack = { (id) -> Void in
            (self.parent as?  HomeViewController)?.requsetForImei(Imei: id , sharedFlag: true)
        }
        userVC.scanImeiresetCallBackCancelBtn = {
            self.creatCameraView()
        }
        userVC.scanImeishowNetworkDialogBox = {
            (self.parent as?  HomeViewController)?.showNetworkDialogBox(flag: true)
        }
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
}
