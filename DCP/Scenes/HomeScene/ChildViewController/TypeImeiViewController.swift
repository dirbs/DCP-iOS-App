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
import Localize_Swift
class TypeImeiViewController: UIViewController,UITextFieldDelegate {
    //Outlet
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var checkBtn: UIButton!
    @IBOutlet var enterImeiTextField: UITextField!
    var TypeImei = ""
    var checkBtnFalg = false
    var inputDialogBox: inputDialogBoxViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()   // Do any additional setup after loading the view.
    }
     // MARK: Make setUpView Method
    func setUpView(){
      //set Propertiess of enterImei textfield
        enterImeiTextField.layer.cornerRadius = 5
        enterImeiTextField.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        enterImeiTextField.attributedPlaceholder = NSAttributedString(string:"Enter Imei e.g. 123456789012345" .localized(), attributes:[NSAttributedString.Key.foregroundColor:UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)])
        enterImeiTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: enterImeiTextField.frame.height))
        enterImeiTextField.leftViewMode = .always
        enterImeiTextField.layer.borderWidth = 2
       
        errorMessage.text = "Please enter 14-16 digit IMEI".localized()
        errorMessage.isHidden = true
        enterImeiTextField.delegate = self
        if #available(iOS 10.0, *) {
            enterImeiTextField.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
        setUpButtonStyle()
        addButtonOnkeyBoard()
    }
     // MARK: Make addButtonOnKeyBoard Method
    func addButtonOnkeyBoard(){
        let doneBtn  = UIBarButtonItem(title: "DONE".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ReportViewController.doneBtnPressed))
         doneBtn.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            doneBtn]
        numberToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        enterImeiTextField.inputAccessoryView = numberToolbar
        MyVariables.scannerVisible = false
    }
    // MARK: donebtnPressed Method
    @objc func doneBtnPressed() {
         view.endEditing(true)
    }
     // MARK: Make checkBtnClick Method
    @IBAction func checkBtnClick(_ sender: UIButton) {
        checkBtnFalg = true
        validate()
    }
    // MARK: Make displayLoginResponse Method
    func validate(){
        if(((enterImeiTextField.text?.isEmpty)!) || (enterImeiTextField.text?.count)!<14) {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
               enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        let enteredText = Int(enterImeiTextField.text!)
        if enteredText == nil {
            errorMessage.isHidden = false
            errorMessage.text = "IMEI must only contain numbers".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        
        if(enteredText == nil  && (enterImeiTextField.text?.isEmpty)!) {
            errorMessage.isHidden = true
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        if(enteredText != nil) {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
             enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor       }
        if(((enterImeiTextField.text?.count)!) >= 14 && ((enterImeiTextField.text?.count)!) <= 16) {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                errorMessage.isHidden = false
                errorMessage.text = "IMEI must only contain numbers".localized()
               enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
            else{
                errorMessage.isHidden = true
                enterImeiTextField.resignFirstResponder()
                enterImeiTextField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
                showTypeImeiDialogBoxVC()
            }
        }
        if((enterImeiTextField.text?.count) == 15  && (enteredText == nil))  {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                print(" Not integar")
                errorMessage.isHidden = false
                errorMessage.text = "IMEI must only contain numbers".localized()
                enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
            else{
               errorMessage.isHidden = true
                
            }
        }
    }
    // MARK: Make stateSaveValidate Method
    func stateSaveValidation(){
        if(((enterImeiTextField.text?.isEmpty)!) || (enterImeiTextField.text?.count)!<14) {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        let enteredText = Int(enterImeiTextField.text!)
        if enteredText == nil {
            print(" Not integar")
            errorMessage.isHidden = false
            errorMessage.text = "IMEI must only contain numbers".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        
        if(enteredText == nil  && (enterImeiTextField.text?.isEmpty)!) {
            errorMessage.isHidden = true
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
            
        }
        if(enteredText != nil) {
            errorMessage.isHidden = false
            errorMessage.text = "Please enter 14-16 digit IMEI".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor       }
        if(((enterImeiTextField.text?.count)!) >= 14 && ((enterImeiTextField.text?.count)!) <= 16) {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                print(" Not integar")
                errorMessage.isHidden = false
                errorMessage.text = "IMEI must only contain numbers".localized()
                enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
                
                
            else{
                
                errorMessage.isHidden = true
                enterImeiTextField.resignFirstResponder()
                enterImeiTextField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
            }
            
        }
        if((enterImeiTextField.text?.count) == 15  && (enteredText == nil))  {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                errorMessage.isHidden = false
                errorMessage.text = "IMEI must only contain numbers".localized()
                enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
            else{
                errorMessage.isHidden = true
            }
        }
    }
    
    // MARK: Make textFieldDidBeginEditing Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(errorMessage.isHidden == true)
        {
         enterImeiTextField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
    }
    // MARK: Make showTypeDialogBoxVc Method
    func showTypeImeiDialogBoxVC() {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "inputDialogBoxViewController") as!  inputDialogBoxViewController
        userVC.titleText = "Verify Input".localized()
        userVC.messageTitle = "Please verify IMEI number you entered.Press OK to continue or CANCAL to re-enter".localized()
        userVC.enterImeiTextFieldPlaceholder = "IMEI"
        userVC.getImei = enterImeiTextField.text!
         inputDialogBox = userVC
        userVC.typeImeicallBack = { (id) -> Void in
            (self.parent as?  HomeViewController)?.requsetForImei(Imei: id , sharedFlag: false)
        }
        userVC.typeImeiresetCallBackCancelBtn = {
        }
        userVC.typeImeishowNetworkDialogBox = {
            (self.parent as?  HomeViewController)?.showNetworkDialogBox(flag: false)
        }
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
     // MARK: Make setUpButtonStyleMethod
    func setUpButtonStyle(){
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = checkBtn.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4
        checkBtn.layer.cornerRadius = 10
        checkBtn.layer.addSublayer(gradientLayer)
        checkBtn.setTitle("CHECK".localized(), for: .normal)
    }
}
