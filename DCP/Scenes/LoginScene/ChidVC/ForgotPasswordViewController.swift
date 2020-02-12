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
class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    //Outlet
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var emailErrorMessage: UILabel!
    @IBOutlet var messageOutlet: UILabel!
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var customView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var emailTF: UITextField!
    //callBacks
    var forgotPasswordcallBack: ((_ id: String) -> Void)?
    var forgotPasswordCallBackNetworkDialogBox: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        //calling of function
        setupView()
        setUpProperties()
        animateView()
    }
    // MARK: setUpView Method
    func setupView() {
        customView.layer.cornerRadius = 5
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    // MARK: animatedView Method
    func animateView() {
        customView.alpha = 0
        self.customView.frame.origin.y = self.customView.frame.origin.y + 80
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.customView.alpha = 1.0
            self.customView.frame.origin.y = self.customView.frame.origin.y - 80
        })
    }
    // MARK: Make setUpProperties Method
    func setUpProperties(){
        //set the title text of dilogBox
        titleOutlet.text  = "Reset Password".localized()
        //set the message text of dilogBox
        messageOutlet.text = "Please enter your email address to reset your Password".localized()
        emailErrorMessage.isHidden = true
        //set the Properties of email text field
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderColor  = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        emailTF.layer.borderWidth = 2
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email".localized(), attributes:[NSAttributedString.Key.foregroundColor:UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)])
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTF.frame.height))
        emailTF.leftViewMode = .always
        //set the title of ok Btn
        okBtn.setTitle("Ok".localized(), for: .normal)
        //set the title of cancel Btn
        cancelBtn.setTitle("CANCEL".localized(), for: .normal)
                emailTF.delegate = self
        //add button On keyboard
        addButtonOnkeyboard()
    }
    // MARK: Make textfield delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 80)
        if(emailErrorMessage.isHidden == true)
        {
        emailTF.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
    }
    }
    // MARK: Make textfield delegate Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 80)
    }
    // MARK: Make animateMoving Method
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
   // MARK: Make okBtn click Listener Method
    @IBAction func okBtn(_ sender: UIButton) {
        validate()
    }
     // MARK: Make addButtonOnkeyboard Method
    func addButtonOnkeyboard(){
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "DONE".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ReportViewController.doneBtnPressed))]
        numberToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        emailTF.inputAccessoryView = numberToolbar
    }
    // MARK: donebtnPressed Method
    @objc func doneBtnPressed() {
         view.endEditing(true)
    }
    // MARK: Make validate Method
    func validate(){
        if((emailTF.text?.isEmpty)!)
        {
            emailErrorMessage.isHidden = false
            emailErrorMessage.text =  "can't be empty!".localized()
            emailTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
       
        if(!(emailTF.text?.isEmpty)!)
        {
            emailErrorMessage.isHidden = true
            if (isValidEmail(emailStr: (emailTF.text)!)) {
                 emailTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
            if Reachability.isConnectedToNetwork() == true {
                self.dismiss(animated: true, completion: nil)
                self.forgotPasswordcallBack!(emailTF.text!)
            }
        else{
                 self.dismiss(animated: true, completion: nil)
                    self.forgotPasswordCallBackNetworkDialogBox!()
                }
            }
                
            else{
                emailErrorMessage.isHidden = false
                emailErrorMessage.text =  "Invalid email!".localized()
                emailTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
            }
        }
    }
   // MARK: Make showNetworkDialogBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    // MARK: Make cancelBtn click Listener Method
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
