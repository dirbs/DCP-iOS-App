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
class SuccessDilogBoxViewController: UIViewController {
    // outlet
    @IBOutlet var customViewOulet: UIView!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var messageOutlet: UILabel!
    // calBack
    var resetCallBackOkBtn: (() -> Void)?
    var deviceInfoResetCallBackOkBtn: (() -> Void)?
    var feedbackResetCallBackOkBtn: (() -> Void)?
    var reportbackResetCallBackOkBtn: (() -> Void)?
    // variables
    var okBtnFlag = ""
    var deviceInfo = false
    var message: String? = ""
    var messagetitle: String? = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        animateView()
        setProperties()
    }
    // MARK: Make  okBtnClick Method
    @IBAction func okBtnClick(_ sender: UIButton) {
        if(okBtnFlag == "FeeddbackScreen")
        {
        self.dismiss(animated: true, completion: nil)
        }
        if(okBtnFlag == "DeviceInfo")
        {
            if deviceInfo == false
            {
           resetCallBackOkBtn!()
            self.dismiss(animated: true, completion: nil)
            }
            
            if deviceInfo == true
            {
                deviceInfoResetCallBackOkBtn!()
                self.dismiss(animated: true, completion: nil)
            }
        }
         if(okBtnFlag == "Report")
         {
            reportbackResetCallBackOkBtn!()
            self.dismiss(animated: true, completion: nil)
        }
    }
    // MARK: Make  setProperties Method
    func setProperties(){
        titleOutlet.text =  messagetitle
        messageOutlet.text = message
        okBtn.setTitle("Ok".localized(), for: .normal)
    }
    // MARK: Make  setUpView Method
    func setUpView() {
        customViewOulet.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: animatedView Method
    func animateView() {
        customViewOulet.alpha = 0
        self.customViewOulet.frame.origin.y = self.customViewOulet.frame.origin.y + 80
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.customViewOulet.alpha = 1.0
            self.customViewOulet.frame.origin.y = self.customViewOulet.frame.origin.y - 80
        })
    }
}
