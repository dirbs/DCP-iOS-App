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
 */import UIKit
class ReportDialogBoxViewController: UIViewController {
    //Outlet
    @IBOutlet var messageOutlet: UILabel!
    @IBOutlet var yasBtn: UIButton!
    @IBOutlet var noReportBtn: UIButton!
    @IBOutlet var customViewOutlet: UIView!
    //callBack
    var typeImeicallBack: ((_ id: String) -> Void)?
    var reportResetCallBackCancelBtn: (() -> Void)?
    var ReportResetCallBackDoneBtn: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpProperties()
        animateView()
    }
    // MARK: Make  setUpProperties Method
    func setUpProperties(){
        // set the text of message label
        messageOutlet.text =  "Does the record field match with the device?".localized()
        // set the title of yas btn
        yasBtn.setTitle("YES".localized(), for: .normal)
        // set the title of no report btn
        noReportBtn.setTitle("NO,REPORT".localized(), for: .normal)
        noReportBtn.layer.cornerRadius = 5
        // set the gradient color yas btn
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = yasBtn.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4
        yasBtn.layer.cornerRadius = 5
        yasBtn.layer.addSublayer(gradientLayer)
        // set the noreport btn color yas btn
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer1.frame.size = noReportBtn.frame.size
        let startColor1 = UIColor(red:0.90, green:0.45, blue:0.45, alpha:1.0)
        let endColor1 = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0)
        gradientLayer1.colors =
            [startColor1.cgColor, endColor1.cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer1.cornerRadius = 4
        noReportBtn.layer.cornerRadius = 5
        noReportBtn.layer.addSublayer(gradientLayer1)
    }
    // MARK: Make  yasBtnClick Method
    @IBAction func YasBtnClick(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            ReportResetCallBackDoneBtn!()
            self.dismiss(animated: true, completion: nil)
        }
        else{
            showNetworkDialogBox()
        }
    }
    
    // MARK: Make  showNetworkDialogBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    // MARK: Make  noReportClick Method
    @IBAction func noReportClick(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            reportResetCallBackCancelBtn!()
            self.dismiss(animated: true, completion: nil)
        }
        else{
            showNetworkDialogBox()
        }
    }
    // MARK: setup Method
    func setUpView() {
        customViewOutlet.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: animatedView Method
    func animateView() {
        customViewOutlet.alpha = 0
        self.customViewOutlet.frame.origin.y = self.customViewOutlet.frame.origin.y + 80
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.customViewOutlet.alpha = 1.0
            self.customViewOutlet.frame.origin.y = self.customViewOutlet.frame.origin.y - 80
        })
    }
}
