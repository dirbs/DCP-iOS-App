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
class NetworkdialogBoxViewController: UIViewController {
    // outlet
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var noBtn: UIButton!
    @IBOutlet var enableItBtn: UIButton!
    @IBOutlet var messageOutlet: UILabel!
    @IBOutlet var titleOulet: UILabel!
    @IBOutlet var customViewOutlet: UIView!
    // calBack
    var scanresetCallBackNoBtn: (() -> Void)?
    var sharedFlag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        animateView()
        setUpProperties()
    }
    // MARK: Make setProperties Method
    func setUpProperties(){
        
        titleOulet.text = "No Internet!".localized()
        messageOutlet.text = "No Internet Connection! Plese enable wifi or mobile data and try again.".localized()
        noBtn.setTitle("NO".localized(), for: .normal)
        enableItBtn.setTitle("YES, ENABLE IT!".localized(), for: .normal)
        
    }
    // MARK: Make setUpView Method
    func setupView() {
        customViewOutlet.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: Make animatedView Method
    func animateView() {
        customViewOutlet.alpha = 0
        self.customViewOutlet.frame.origin.y = self.customViewOutlet.frame.origin.y + 80
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.customViewOutlet.alpha = 1.0
            self.customViewOutlet.frame.origin.y = self.customViewOutlet.frame.origin.y - 80
        })
    }
    // MARK: Make yasEnableItBtnClick Method
    @IBAction func yasEnableItBtnClick(_ sender: UIButton) {
        if let url = URL(string:"App-Prefs:root=WIFI") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        if(sharedFlag == true){
            self.dismiss(animated: true, completion: nil)
            self.scanresetCallBackNoBtn!()
            
        }
        else{
        }
        self.dismiss(animated: true, completion: nil)
        if let url = URL(string:"App-Prefs:root=WIFI") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    // MARK: Make noBtnClick Method
    @IBAction func noBtnClick(_ sender: UIButton) {
        if(sharedFlag == true){
            self.dismiss(animated: true, completion: nil)
            self.scanresetCallBackNoBtn!()
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
