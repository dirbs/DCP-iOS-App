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
import SlideMenuControllerSwift
import JGProgressHUD
protocol LoginDisplayLogic: class{
    func displayLoginResponse(viewModel: Login.LoginResponse.ViewModel)
    func displayForgotPasswordResponse(viewModel: Login.ForgotPassword.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic ,UITextFieldDelegate{
    //Outlet
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var changeLanguageBtn: UIButton!
    @IBOutlet var passwordVisibilityBtn: UIButton!
    @IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var titleOulet: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet var customView: UIView!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var passwordErrorMessage: UILabel!
    @IBOutlet var emailErrorMessage: UILabel!
    var forgotPasswordViewController: ForgotPasswordViewController?
    var homeViewController: HomeViewController?
    var successDialogBox: SuccessDilogBoxViewController?
    var leftNeviagtionViewController: NeviagtionDrawerVC?
    @IBOutlet var titleImageView: UIImageView!
    //variabless
    var accessToken  = ""
    var loginFlag = false
    var adminFlag = false
    var lisscentActiveFlag = false
    var email = ""
    var reportStateFlag = false
    var language = ""
    let spinner = JGProgressHUD(style: .extraLight)
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    // MARK: Setup
    private func setup(){
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: Make save ValueInSharedPreferncess Method
    func saveValueInPrferncess( access_token:String ,roles:String , useremail: String){
        if(roles == "admin"){
            adminFlag = true
            loginFlag = true
        }
        let access_token = access_token
        email = useremail
        let preferences = UserDefaults.standard
        preferences.set(loginFlag, forKey: "loginFlag")
        _ = preferences.synchronize()
        preferences.set(adminFlag, forKey: "adminFlag")
        _ = preferences.synchronize()
        preferences.set(email, forKey: "email")
        _ = preferences.synchronize()
    }
    // MARK: Make show Loading  Method
    func showLoading(message: String?){
        self.spinner.textLabel.text = message
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
    }
    // MARK: Make setUpView Method
    func setUpView(){
        //set propertiess  of email text View
        emailTF.layer.cornerRadius = 5
        emailTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        emailTF.layer.borderWidth = 2
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email".localized(), attributes:[NSAttributedString.Key.foregroundColor:UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)])
        emailTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: emailTF.frame.height))
        emailTF.leftViewMode = .always
        emailTF.delegate = self
        //set propertiess  of scroll View
        scrollview.isScrollEnabled = false
        //set propertiess  of password text View
        passwordTF.layer.cornerRadius = 5
        passwordTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        passwordTF.layer.borderWidth = 2
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password".localized(), attributes:[NSAttributedString.Key.foregroundColor:UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)])
        passwordTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: passwordTF.frame.height))
        passwordTF.leftViewMode = .always
        passwordTF.delegate = self
        //set the title of title text
        titleOulet.text = "Device Characterisation Platform".localized()
        passwordErrorMessage.isHidden = true
        emailErrorMessage.isHidden = true
        //set the properties of Login Btn
        loginBtn.setTitle("LOGIN".localized(), for: .normal)
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = loginBtn.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.addSublayer(gradientLayer)
        passwordTF.isSecureTextEntry.toggle()
        //set the title of forgotPassword
        forgotPasswordBtn.setTitle("FORGOT PASSWORD?".localized(), for: .normal)
        //set the properties of title View
        titleView.layer.shadowColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        titleView.layer.shadowOpacity = 0.25
        titleView.layer.shadowRadius = 3
        titleView.layer.shadowOffset = CGSize(width: 5, height: 5)
        //add the  custom button on keyboard Method
        addButtonOnkeyboard()
        scrollview.isScrollEnabled = false
        passwordTF.isSecureTextEntry.toggle()
    }
    // MARK: Make visibilityBtn click Listener Method
    @IBAction func visiblityBtnClick(_ sender: UIButton) {
        if let ButtonImage = passwordVisibilityBtn.image(for: .normal),
            let Image = UIImage(named: "ic_visibility_off"),
            ButtonImage.pngData() == Image.pngData(){
            passwordVisibilityBtn.setImage(UIImage(named: "ic_visibility"), for: .normal)
            passwordTF.isSecureTextEntry.toggle()
        } else {
            
            passwordVisibilityBtn.setImage(UIImage(named: "ic_visibility_off"), for: .normal)
            passwordTF.isSecureTextEntry.toggle()
        }
    }
    // MARK: Make addButtonOnKeyBoard Method
    func addButtonOnkeyboard(){
        let doneBtn  = UIBarButtonItem(title: "DONE".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(LoginViewController.doneBtnPressed))
        doneBtn.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            doneBtn]
        numberToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        emailTF.inputAccessoryView = numberToolbar
        passwordTF.inputAccessoryView = numberToolbar
        MyVariables.scannerVisible = false
    }
    // MARK: donebtnPressed Method
    @objc func doneBtnPressed() {
        view.endEditing(true)
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
    // MARK: Make textFieldDidBeginEditing Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            animateViewMoving(up: true, moveValue: 100)
        }
        if textField == emailTF {
            if(emailErrorMessage.isHidden == true){
                emailTF.layer.borderWidth = 2
                emailTF.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
            }
        }
        if textField == passwordTF {
            if(passwordErrorMessage.isHidden == true){
                passwordTF.layer.borderWidth = 2
                passwordTF.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
            }
        }
    }
    // MARK: Make textFieldDidEndEditing Method
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            animateViewMoving(up: false, moveValue: 100)
        }
        if textField == emailTF {
            if(emailErrorMessage.isHidden == true)
            {
                emailTF.layer.borderWidth = 2
                emailTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
            }
        }
        if textField == passwordTF {
            if(passwordErrorMessage.isHidden == true)
            {
                passwordTF.layer.borderWidth = 2
                passwordTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
            }
        }
    }
    // MARK: Make forgotPasswordBtnClick Method
    @IBAction func forgotPasswordBtnClick(_ sender: UIButton) {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as!  ForgotPasswordViewController
        
        forgotPasswordViewController = userVC
        userVC.forgotPasswordcallBack = { (id) -> Void in
            self.forgotPasswordRequest(access_token: "335", email: id)
        }
        userVC.forgotPasswordCallBackNetworkDialogBox = {
            self.showNetworkDialogBox()
        }
        
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    // MARK: Make loginBtnClick Method
    @IBAction func loginBtnClick(_ sender: UIButton) {
        validate()
    }
    // MARK: Make changeLanguageBtn Click Listener Method
    @IBAction func changeLanuageBtn(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "CurrentLanguage") != nil) {
            var language = (preferences.object(forKey: "CurrentLanguage") as? String)!
            if(language == "vi") {
                language = "en"
                let preferences = UserDefaults.standard
                preferences.set(language, forKey: "CurrentLanguage")
                _ = preferences.synchronize()
                Localize.setCurrentLanguage("en")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg?.window?.rootViewController = vc
            } else {
                language = "vi"
                let preferences = UserDefaults.standard
                preferences.set(language, forKey: "CurrentLanguage")
                _ = preferences.synchronize()
                Localize.setCurrentLanguage("vi")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg?.window?.rootViewController = vc
            }
        }
    }
    // MARK: View lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        addStatusBar()
        getPrefrencessValue()
        setUpView()
        setLanguage()
        reportStateFlag   = UserDefaults.standard.bool(forKey: "ReportStatusFlage")
        if(reportStateFlag == true){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let HomeVC = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
            let appDlg = UIApplication.shared.delegate as? AppDelegate
            appDlg?.window?.rootViewController = HomeVC
        }
        else{
            if(lisscentActiveFlag == true){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "LiscenceAgrementViewController") as! LiscenceAgrementViewController
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg?.window?.rootViewController = HomeVC
            }
            else if  ( loginFlag == true){
                let HomeVC = storyboard!.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                HomeVC.getEmail = emailTF.text!
                let LeftNeviagationDrawer = storyboard!.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
                let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg?.window?.rootViewController = slideMenuController
            }
        }
    }
    // MARK: Make getPrefrencessValue Method
    func getPrefrencessValue(){
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "loginFlag") == nil) {
            preferences.set(false, forKey: "loginFlag")
            _ = preferences.synchronize()
        }
        if(preferences.object(forKey: "adminFlag") == nil) {
            
            preferences.set(false, forKey: "adminFlag")
            _ = preferences.synchronize()
        }
        if(preferences.object(forKey: "email") == nil) {
            preferences.set(email, forKey: "email")
            _ = preferences.synchronize()
        }
        if(preferences.object(forKey: "LiscenceFlag") == nil) {
            preferences.set(false, forKey: "LiscenceFlag")
            _ = preferences.synchronize()
        }
        loginFlag   = UserDefaults.standard.bool(forKey: "loginFlag")
        adminFlag   = UserDefaults.standard.bool(forKey: "adminFlag")
        lisscentActiveFlag = UserDefaults.standard.bool(forKey: "LiscenceFlag")
        if (preferences.object(forKey: "AccessToken") != nil) {
            accessToken = (preferences.object(forKey: "AccessToken") as? String)!
        }
    }
    // MARK: Make validate Method
    func validate(){
        if((emailTF.text?.isEmpty)!){
            emailErrorMessage.isHidden = false
            emailErrorMessage.text =  "can't be empty!".localized()
            emailTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        if((passwordTF.text?.isEmpty)!){
            passwordErrorMessage.isHidden = false
            passwordErrorMessage.text =  "can't be empty!".localized()
            passwordTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        if(!(emailTF.text?.isEmpty)!){
            emailErrorMessage.isHidden = true
            if (isValidEmail(emailStr: (emailTF.text)!)) {
                emailTF.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
            }
            else{
                emailErrorMessage.isHidden = false
                emailErrorMessage.text =  "Invalid email!".localized()
                emailTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
            }
        }
        if(!(passwordTF.text?.isEmpty)!){
            passwordErrorMessage.isHidden = true
            passwordErrorMessage.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        }
        if(((passwordTF.text?.count)!) <  6){
            passwordErrorMessage.isHidden = false
            passwordErrorMessage.text =  "Must be at least minmimim 6 character".localized()
            passwordTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        if(((passwordTF.text?.count)!) == 0){
            passwordErrorMessage.isHidden = false
            passwordErrorMessage.text =  "can't be empty!".localized()
            passwordTF.layer.borderColor = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0).cgColor
        }
        if(((passwordTF.text?.count)!) >= 6 && (isValidEmail(emailStr: (emailTF.text)!)) ){
            passwordErrorMessage.isHidden = true
            emailErrorMessage.isHidden = true
            emailTF.resignFirstResponder()
            passwordTF.resignFirstResponder()
            if Reachability.isConnectedToNetwork() == true {
                showLoading(message: "Authenticating".localized())
                loginRequest()
            }
            else{
                showNetworkDialogBox()
            }
        }
    }
    
    // MARK: Make showNetworkDialogBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    
    // MARK: Make setLanguage Method
    func setLanguage(){
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "CurrentLanguage") == nil) {
            let preferences = UserDefaults.standard
            preferences.set(language, forKey: "CurrentLanguage")
            _ = preferences.synchronize()
            print("preferencess")
        }
        if (preferences.object(forKey: "CurrentLanguage") != nil) {
            language = (preferences.object(forKey: "CurrentLanguage") as? String)!
            if(language == "vi") {
                self.changeLanguageBtn.setImage(UIImage(named: "ic_english"), for: .normal)
                changeLanguageBtn.imageView?.contentMode = .scaleAspectFit
                Localize.setCurrentLanguage("vi")
            } else {
                self.changeLanguageBtn.setImage(UIImage(named: "ic_vietnamese"), for: .normal)
                changeLanguageBtn.imageView?.contentMode = .scaleAspectFit
            }
        }
    }
    // MARK: Make loginRequest Method
    func loginRequest(){
        let request = Login.LoginResponse.Request(email: emailTF.text, password: passwordTF.text)
        interactor?.loginRequest(request: request)
    }
    // MARK: Make forgotPasswordRequest Method
    func forgotPasswordRequest(access_token: String,email:String){
        showLoading(message: "Verifiying".localized())
        let request = Login.ForgotPassword.Request(email: email, access_token: accessToken)
        interactor?.forgotPasswordRequest(request: request)
    }
    // MARK: Make displayLoginResponse Method
    func displayLoginResponse(viewModel: Login.LoginResponse.ViewModel){
        if(viewModel.status_code == 200){
            let preferences = UserDefaults.standard
            preferences.set(true, forKey: "loginFlag")
            _ = preferences.synchronize()
            if(viewModel.roles == "admin"){
                preferences.set(false, forKey: "adminFlag")
                _ = preferences.synchronize()
                self.spinner.dismiss()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                HomeVC.getEmail = emailTF.text!
                let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
                let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg!.window?.rootViewController = slideMenuController
                appDlg?.window?.makeKeyAndVisible()
            }
            if(viewModel.roles == "staff"){
                preferences.set(true, forKey: "adminFlag")
                _ = preferences.synchronize()
                if(viewModel.agreed == "Agreed" )
                {
                    if(viewModel.active_id == viewModel.user_id)
                    {
                        self.spinner.dismiss()
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        homeViewController = HomeVC
                        HomeVC.getEmail = emailTF.text!
                        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
                        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
                        let appDlg = UIApplication.shared.delegate as? AppDelegate
                        appDlg!.window?.rootViewController = slideMenuController
                        appDlg?.window?.makeKeyAndVisible()
                    }
                        
                    else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let HomeVC = storyboard.instantiateViewController(withIdentifier: "LiscenceAgrementViewController") as! LiscenceAgrementViewController
                        self.present(HomeVC, animated: true, completion: nil)
                        let preferences = UserDefaults.standard
                        preferences.set(true, forKey: "LiscenceFlag")
                        _ = preferences.synchronize()
                    }
                }
                    
                else{
                    let preferences = UserDefaults.standard
                    preferences.set(true, forKey: "LiscenceFlag")
                    _ = preferences.synchronize()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let HomeVC = storyboard.instantiateViewController(withIdentifier: "LiscenceAgrementViewController") as! LiscenceAgrementViewController
                    self.present(HomeVC, animated: true, completion: nil)
                }
            }
            preferences.set(emailTF.text!, forKey: "email")
            _ = preferences.synchronize()
        }
        if(viewModel.status_code == 401){
            self.spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
            userVC.message = "These credentials do not match our records".localized()
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
            
        else{
            self.spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
            userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
    }
    // MARK: Make isValidEmail Method
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    // MARK: Make ForgotPassworfResponse Method
    func displayForgotPasswordResponse(viewModel: Login.ForgotPassword.ViewModel) {
        if(viewModel.status_code == 200){
            spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "successDilogBoxViewController") as!  SuccessDilogBoxViewController
            successDialogBox = userVC
            userVC.message  = "A reset email has been sent! Please check your email".localized()
            userVC.messagetitle =  "Succesful".localized()
            userVC.okBtnFlag = "FeeddbackScreen"
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
        else{
            self.spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
            userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
    }
    // MARK: Make addStatusBar Method
    func addStatusBar(){
        if #available(iOS 13.0, *) {            let statusBar =  UIView()
            statusBar.frame = UIApplication.shared.statusBarFrame
            statusBar.backgroundColor = UIColor(red:0.04, green:0.22, blue:0.32, alpha:1.0)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar1.backgroundColor = UIColor(red:0.04, green:0.22, blue:0.32, alpha:1.0)
        }
    }
    // MARK: Make override preferredStatusBarstyle Method
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
}





