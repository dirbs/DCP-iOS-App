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
import Material
class ResultViewController: UIViewController {
   // Outlet
    @IBOutlet var MainView: UIView!
    @IBOutlet var reportMobilePhoneBtn: UIButton!
    @IBOutlet var responseMessageOutlet: UILabel!
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var titleImageOutlet: UIImageView!
     var imei = ""
    var language = "en"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProperties()
        setupView()
        animateView()
    }
     // MARK: Make setUpProperties Method
    func setUpProperties(){
        titleOutlet.text = "Imei not Found".localized()
        reportMobilePhoneBtn.setTitle("REPORT MOBILE PHONE".localized(), for: .normal)
        if (language == "en")
        {
        responseMessageOutlet.text = imei + " " + "not found in database. This device may be" + "\n" + "counterfeit or illegal. Please report this device through DCP!" + "\n\n" + "To fill the form press Report Mobile " + "\n" + "Phone"
    }
          if (language == "vi")
          {
        
        responseMessageOutlet.text = imei + " " + "không tìm thấy trong cơ sở dữ liệu. Thiết bị này có thể là hàng giả hoặc bất hợp pháp. Vui lòng báo cáo thiết bị này qua DCP!" + "\n\n" + "Để điền vào biểu mẫu nhấn Báo cáo" + "\n" + "Điện thoại di động."
        }
    }
     // MARK: Make reportMobilePhoneBtn Click Method
    @IBAction func ReportMobilePhoneBtn(_ sender: UIButton) {
        showReportVC()
    }
    // MARK: setup Method
    func setupView() {
        MainView.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: animatedView Method
    func animateView() {
        MainView.alpha = 0
        self.MainView.frame.origin.y = self.MainView.frame.origin.y + 80
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.MainView.alpha = 1.0
            self.MainView.frame.origin.y = self.MainView.frame.origin.y - 80
        })
    }
    
     // MARK: Make showReportVC Method
    func showReportVC(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as!  ReportViewController
        userVC.imei = imei
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg?.window?.rootViewController = userVC
    }
}
