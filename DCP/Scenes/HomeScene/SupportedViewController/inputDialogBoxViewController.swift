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
import Foundation
import SystemConfiguration
class inputDialogBoxViewController: UIViewController ,UITextFieldDelegate  {
    //Outlet
    @IBOutlet var customViewOulet: UIView!
    @IBOutlet var okBtnOutlet: UIButton!
    @IBOutlet var cancelBtnOutlet: UIButton!
    @IBOutlet var errorMessageOutlet: UILabel!
    @IBOutlet var enterImeiTextField: UITextField!
    @IBOutlet var messageOutlet: UILabel!
    @IBOutlet var titleOutlet: UILabel!
    // typeImei callBack
    var typeImeicallBack: ((_ id: String) -> Void)?
    var typeImeiresetCallBackCancelBtn: (() -> Void)?
    var typeImeiresetCallBackDoneBtn: (() -> Void)?
    var typeImeishowNetworkDialogBox: (() -> Void)?
    //scanImei callBack
    var scanImeicallBack: ((_ id: String) -> Void)?
    var scanImeiresetCallBackCancelBtn: (() -> Void)?
    var scanImeiresetCallBackDoneBtn: (() -> Void)?
    var scanImeishowNetworkDialogBox: (() -> Void)?
    //variables
    var  titleText = ""
    var messageTitle = ""
    var enterImeiTextFieldPlaceholder = ""
    var  errorMessage = ""
    var sharedFlag = false
    var getImei = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpProperties()
        animateView()
    }
    // MARK: Make setUpProperties Method
    func setUpProperties(){
        titleOutlet.text  = titleText
        messageOutlet.text = messageTitle
        errorMessageOutlet.isHidden = true
        errorMessageOutlet.text = "Please enter 14-16 digit IMEI".localized()
         //set the propertiess of enterImeiTextfield
        enterImeiTextField.layer.cornerRadius = 5
        enterImeiTextField.layer.borderColor  = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        enterImeiTextField.layer.borderWidth = 2
        enterImeiTextField.attributedPlaceholder = NSAttributedString(string: enterImeiTextFieldPlaceholder, attributes:[NSAttributedString.Key.foregroundColor:UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)])
        enterImeiTextField.text = getImei
        enterImeiTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: enterImeiTextField.frame.height))
        enterImeiTextField.leftViewMode = .always
        //set the title of okbtn
        okBtnOutlet.setTitle("Ok".localized(), for: .normal)
         //set the title of cancelbtn
        cancelBtnOutlet.setTitle("CANCEL".localized(), for: .normal)
        if #available(iOS 10.0, *) {
            enterImeiTextField.keyboardType = .asciiCapableNumberPad
        } else {
            // Fallback on earlier versions
        }
        enterImeiTextField.delegate = self
        addButtonOnkeyBoard()
    }
     // MARK: Make valiadete Method
    func validate(){
        if(((enterImeiTextField.text?.isEmpty)!) || (enterImeiTextField.text?.count)!<14) {
            errorMessageOutlet.isHidden = false
            errorMessageOutlet.text = "Please enter 14-16 digit IMEI".localized()
             enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        let enteredText = Int(enterImeiTextField.text!)
        if enteredText == nil {
            errorMessageOutlet.isHidden = false
            errorMessageOutlet.text = "IMEI must only contain numbers".localized()
            enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(enteredText == nil  && (enterImeiTextField.text?.isEmpty)!) {
            errorMessageOutlet.isHidden = true
            errorMessageOutlet.isHidden = false
            errorMessageOutlet.text = "Please enter 14-16 digit IMEI".localized()
             enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            
        }
        if(enteredText != nil) {
            errorMessageOutlet.isHidden = false
            errorMessageOutlet.text = "Please enter 14-16 digit IMEI".localized()
             enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(((enterImeiTextField.text?.count)!) >= 14 && ((enterImeiTextField.text?.count)!) <= 16 && enteredText != nil ) {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                errorMessageOutlet.isHidden = false
                errorMessageOutlet.text = "IMEI must only contain numbers".localized()
                 enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
            else{
                if Reachability.isConnectedToNetwork() == true {
                    errorMessageOutlet.isHidden = true
                    enterImeiTextField.resignFirstResponder()
                     enterImeiTextField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
                    if(sharedFlag == true)
                    {
                        self.dismiss(animated: true, completion: nil)
                        self.scanImeicallBack!(enterImeiTextField.text!)
                    }
                    else{
                        self.dismiss(animated: true, completion: nil)
                        self.typeImeicallBack!(enterImeiTextField.text!)
                    }
                } else {
                    errorMessageOutlet.isHidden = true
                    enterImeiTextField.resignFirstResponder()
                    self.dismiss(animated: true, completion: nil)
                    if(sharedFlag == true)
                    {
                    self.scanImeishowNetworkDialogBox!()
                    }
                    else{
                      self.typeImeishowNetworkDialogBox!()
                    }
                }
            }
        }
        if((enterImeiTextField.text?.count) == 15  && (enteredText == nil))  {
            let enteredText = Int(enterImeiTextField.text!)
            if enteredText == nil {
                print(" Not integar3")
                errorMessageOutlet.isHidden = false
                errorMessageOutlet.text = "IMEI must only contain numbers".localized()
                 enterImeiTextField.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
            }
            else{
             errorMessageOutlet.isHidden = true
            }
        }
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
    // MARK: setup Method
    func setupView() {
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
    
     // MARK: Make textFieldDidBegainInEditing Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            animateViewMoving(up: true, moveValue: 50)
        }
         enterImeiTextField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
    }
    // MARK: Make textFieldDidEndEditing Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            animateViewMoving(up: false, moveValue: 50)
        }
    }
    // MARK: Make animateViewMoving Method
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        print("animation")
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    // MARK: Make okBtnClick Method
    @IBAction func OkBtn(_ sender: UIButton) {
        validate()
    }
     // MARK: Make cancelBtnClick Method
    @IBAction func cancelBtn(_ sender: UIButton) {
      if(sharedFlag == true)
      {
        self.scanImeiresetCallBackCancelBtn!()
         self.dismiss(animated: true, completion: nil)
        
        }
      else{
     self.dismiss(animated: true, completion: nil)
        }
    }
}
 // MARK: Make Reachability class
public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}


