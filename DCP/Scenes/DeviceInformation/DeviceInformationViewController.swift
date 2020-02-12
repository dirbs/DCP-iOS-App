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
import SwiftyJSON
import JGProgressHUD
protocol DeviceInformationDisplayLogic: class{
    func displayMatchedImei(viewModel: DeviceInformation.ImeiMatched.ViewModel)
    
    func displayNotMatchedImei(viewModel: DeviceInformation.ImeiNotMatched.ViewModel)
}
class DeviceInformationViewController: UIViewController, DeviceInformationDisplayLogic{
    //Outlet
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var customDialogBoxView: UIView!
    @IBOutlet var getDeviceDataVC: UIView!
    @IBOutlet var scrollVieButtom: NSLayoutConstraint!
    @IBOutlet var noBtn: UIButton!
    @IBOutlet var yasBtn: UIButton!
    @IBOutlet var messageOutlet: UILabel!
    //variables
    var getDeviceViewController:GetDeviceInformationDataViewController!
    var Imei = ""
    let spinner = JGProgressHUD(style: .extraLight)
    var deviceId   = ""
    var  brandName  = ""
    var modelName = ""
    var internalModelName  = ""
    var marketingName = ""
    var equipmentType = ""
    var simSupport = ""
    var nfcSupport  = ""
    var wlanSupport = ""
    var blueToothSupport = ""
    var operatingSystem = [JSON]()
    var radioInterface = [JSON]()
    var lpwan = ""
    var deviceCertifybody = [JSON]()
    var manufacturer = ""
    var tacApprovedDate  = ""
    var gsmaApprovedTac  = ""
    var access_Token = ""
    var backBtnflag = false
    var okflag = false
    var interactor: DeviceInformationBusinessLogic?
    var router: (NSObjectProtocol & DeviceInformationRoutingLogic & DeviceInformationDataPassing)?
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
        let interactor = DeviceInformationInteractor()
        let presenter = DeviceInformationPresenter()
        let router = DeviceInformationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: Make  backBtnclick Method
    @IBAction func backBtn(_ sender: UIButton) {
        if(backBtnflag == false){
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportDialogBoxViewController") as!  ReportDialogBoxViewController
            userVC.ReportResetCallBackDoneBtn = {
                self.showLoading()
                self.requestForCheckMatchedImei(flag: true)
            }
            userVC.reportResetCallBackCancelBtn = {
                self.showLoading()
                self.requestForCheckNonMathedImei(flag: true)
            }
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
        if(backBtnflag == true){
            showHomeVC()
        }
    }
    // MARK: Make  showHomeVC Method
    func showHomeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = HomeVC
        appDlg?.window?.makeKeyAndVisible()
    }
    // MARK: Make  yasBtnClick Method
    @IBAction func yasBtnClick(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            showLoading()
            requestForCheckMatchedImei(flag: false)
        }
        else{
            showNetworkDialogBox()
        }
    }
    func showLoading(){
        self.spinner.textLabel.text = "Updating Device Status".localized()
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
    }
    // MARK: Make  noBtnClick Method
    @IBAction func noBtnClick(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            showLoading()
            requestForCheckNonMathedImei(flag: false)
        }
        else{
            showNetworkDialogBox()
        }
    }
    // MARK: View lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        showGetDataVC()
        setUpView()
        
    }
    // MARK: Make  override statusBar Method
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: Make  setUpView Method
    func setUpView(){
        // set properties if custom dialog box view
        customDialogBoxView.layer.shadowColor = UIColor.black.cgColor
        customDialogBoxView.layer.shadowOpacity = 1
        customDialogBoxView.layer.shadowOffset = .zero
        customDialogBoxView.layer.shadowRadius = 3
        messageOutlet.text =  "Does the record field match with the device?".localized()
        //set properties of yas btn
        yasBtn.setTitle("YES".localized(), for: .normal)
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
        //set properties of no report btn
        let gradientLayer1:CAGradientLayer = CAGradientLayer()
        gradientLayer1.frame.size = noBtn.frame.size
        let startColor1 = UIColor(red:0.90, green:0.45, blue:0.45, alpha:1.0)
        let endColor1 = UIColor(red:0.72, green:0.11, blue:0.11, alpha:1.0)
        gradientLayer1.colors =
            [startColor1.cgColor, endColor1.cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer1.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer1.cornerRadius = 4
        noBtn.layer.cornerRadius = 5
        noBtn.layer.addSublayer(gradientLayer1)
        noBtn.setTitle("NO,REPORT".localized(), for: .normal)
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "AccessToken") != nil) {
            access_Token = (preferences.object(forKey: "AccessToken") as? String)!
        }
        scrollVieButtom.constant = 220
    }
    // MARK: Make  showGetDataVC Method
    func showGetDataVC(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "GetDeviceInformationDataViewController") as! GetDeviceInformationDataViewController
        getDeviceViewController = userVC
        userVC.Imei = Imei
        userVC.deviceId = deviceId
        userVC.manufacturer = manufacturer
        userVC.equipmentType = equipmentType
        userVC.brandName = brandName
        userVC.modelName = modelName
        userVC.marketingName = marketingName
        userVC.internalModelName = internalModelName
        userVC.tacApprovedDate = tacApprovedDate
        userVC.deviceCertifybody = deviceCertifybody
        userVC.radioInterface = radioInterface
        userVC.operatingSystem = operatingSystem
        userVC.simSupport = simSupport
        userVC.nfcSupport = nfcSupport
        userVC.blueToothSupport = blueToothSupport
        userVC.wlanSupport = wlanSupport
        userVC.lpwan = lpwan
        userVC.view.frame = CGRect(x: 0, y: 0, width: getDeviceDataVC.frame.size.width, height: getDeviceDataVC.frame.size.height)
        addChild(userVC)
        getDeviceDataVC.addSubview(userVC.view)
        userVC.didMove(toParent: self)
    }
    // MARK: Make  requestForCheckMatchedImei Method
    func requestForCheckMatchedImei(flag: Bool){
        okflag = flag
        let request = DeviceInformation.ImeiMatched.Request(imei_number:Imei ,access_Token: self.access_Token)
        interactor?.doMatchedImei(request: request)
    }
    // MARK: Make  showNetworkDialogBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    // MARK: Make  requestForCheckNonMatchedImei Method
    func requestForCheckNonMathedImei(flag: Bool){
        okflag = flag
        let request = DeviceInformation.ImeiNotMatched.Request(imei_number:Imei ,access_Token: self.access_Token)
        interactor?.doNotMatchedImei(request: request)
    }
    // MARK: Make  displayNonMatchedImei Method
    func displayNotMatchedImei(viewModel: DeviceInformation.ImeiNotMatched.ViewModel){
        if(viewModel.status_code == 200){
            spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportViewController") as!  ReportViewController
            userVC.imei = Imei
            let appDlg = UIApplication.shared.delegate as? AppDelegate
            appDlg?.window?.rootViewController = userVC
        }
        if(viewModel.status_code == 401){
            self.spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "SessionDialogBoxViewController") as!  SessionDialogBoxViewController
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
    // MARK: Make  displayMatchedImei Method
    func displayMatchedImei(viewModel: DeviceInformation.ImeiMatched.ViewModel){
        if(viewModel.status_code == 200){
            spinner.dismiss()
            backBtnflag = true
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "successDilogBoxViewController") as!  SuccessDilogBoxViewController
            userVC.message  = "Does status Updated successsfuly".localized()
            userVC.messagetitle = "Succesful".localized()
            userVC.okBtnFlag = "DeviceInfo"
            userVC.deviceInfo = okflag
            userVC.resetCallBackOkBtn = {
                self.customDialogBoxView.isHidden = true
                self.scrollVieButtom.constant = 50
            }
            userVC.deviceInfoResetCallBackOkBtn =
                {
                    self.showHomeVC()
            }
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
        if(viewModel.status_code == 401){
            self.spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "SessionDialogBoxViewController") as!  SessionDialogBoxViewController
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
}
