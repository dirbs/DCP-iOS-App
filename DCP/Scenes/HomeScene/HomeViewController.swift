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
import MTBBarcodeScanner
import TTGSnackbar
import SlideMenuControllerSwift
import Foundation
import JGProgressHUD
protocol HomeDisplayLogic: class
{
  func displayGetImeiResponse(viewModel: Home.GetImei.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic
{
    // Outlet
    @IBOutlet var infoImageView: UIImageView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var scanImeiBtn: UIButton!
    @IBOutlet var typeImeiBtn: UIButton!
     var menuButton: IconButton!
    @IBOutlet var paragraphOutlet: UILabel!
    @IBOutlet var instructionOutlet: UILabel!
    @IBOutlet var scanImeiVC: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var typeImeiVC: UIView!
    @IBOutlet var cameraAccessVC: UIView!
    @IBOutlet var dcpToolBar: Toolbar!
    // variables
    var resultflag = false
    var typeImeiViewController: TypeImeiViewController?
    var scanImeiViewController: ScanImeiViewController?
     var allowAccessViewController: AllowAccessViewController?
    var resultViewController: ResultViewController?
    var deviceInformationViewController: DeviceInformationViewController?
    
    var language = "en"
    var getToken = ""
    var getEmail = ""
    var access_Token = ""
    var imei = ""
    var sharedflag = false
    let spinner = JGProgressHUD(style: .extraLight)
    var window: UIWindow?
    var typeImeiFlag = false
    var checkBtnFlag = false
    var scanBtnFlag = false
    
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
    
     // MARK: Make prepareMenueButton Method
    func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu, tintColor: .white)
        menuButton.pulseColor = .white
        menuButton.addTarget(self, action: #selector(menuBtnClick(button:)), for: .touchUpInside)
    }
     // MARK: Make preparetoolBar Method
    func prepareToolbar() {
        dcpToolBar.title = "Home".localized()
        dcpToolBar.titleLabel.textColor = .white
        dcpToolBar.titleLabel.font   = UIFont.boldSystemFont(ofSize: 18.0)
        dcpToolBar.titleLabel.textAlignment = .left
        dcpToolBar.leftViews = [menuButton]
    }
     // MARK: Make setUpView Method
    func setUpView()
    {
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
                Localize.setCurrentLanguage("vi")
                            } else {
                Localize.setCurrentLanguage("en")
            }
        }
        instructionOutlet.text = "Instructions".localized()
        paragraphOutlet.text = "The IMEI (International Mobile Equipment Identity) is a globally unique number to identify any SIM based mobile device. You can view the mobile phone's IMEI by pressing *#06# on dialpad of the device. If the device has two simcards, you will see two 14-16 digit codes. Enter the 14-16 digit IMEI number in the box and click on the check  box to view its detail.".localized()
        // set the title of Button
        typeImeiBtn.setTitle("TYPE IMEI".localized(), for: .normal)
        scanImeiBtn.setTitle("SCAN IMEI".localized(), for: .normal)
        typeImeiBtn.imageView?.contentMode = .scaleAspectFit
        scanImeiBtn.imageView?.contentMode = .scaleAspectFit
        //set the properties of main View
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = .zero
        mainView.layer.shadowRadius = 2
        if (preferences.object(forKey: "AccessToken") != nil) {
             access_Token = (preferences.object(forKey: "AccessToken") as? String)!
        }
        showTypeImeiVC()
    }
     // MARK: Make showLoading Method
    func showLoading()
    {
        self.spinner.textLabel.text = "Checking".localized()
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
    }
    
     // MARK: Make typeImeiBtnClick Method
    @IBAction func typeImeBtnClick(_ sender: UIButton) {
        let typeVisible = MyVariables.scannerVisible
        if(typeVisible == true)
        {
        showTypeImeiVC()
        }
    }
     // MARK: Make scanImeiBtnClick Method
    @IBAction func scanImeiBtnClick(_ sender: UIButton) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            showAllowAccessVC()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
              let typeVisible = MyVariables.scannerVisible
            if(typeVisible == false)
            {
                showScanVC()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        }
    }
     // MARK: Make showSnackBar Method
    func showSnackBar(message: String) {
        let snackbar = TTGSnackbar(message: message, duration: .middle)
        snackbar.messageTextAlign = .left
        snackbar.show()
    }
  // MARK: Setup
  private func setup()
  {
    let viewController = self
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
 
  override func viewDidLoad()
  {
    super.viewDidLoad()
    prepareMenuButton()
    prepareToolbar()
    setUpView()
    scrollview.isScrollEnabled = false
    addStatusBar()
  }
     // MARK: Make addStatusBar Method
    func addStatusBar()
    {
      if #available(iOS 13.0, *) {            let statusBar =  UIView()
            statusBar.frame = UIApplication.shared.statusBarFrame
            statusBar.backgroundColor = UIColor(red:0.04, green:0.22, blue:0.32, alpha:1.0)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
       } else {
            let statusBar1: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar1.backgroundColor = UIColor(red:0.04, green:0.22, blue:0.32, alpha:1.0)
        }
    }
     // MARK: Make textFieldShouldReturn Method
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
     // MARK: Make override preferredStatusBarstyle Method
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: Make requestforImei Method
    func requsetForImei(Imei: String , sharedFlag: Bool)
    {
       showLoading()
       getImeiRequest(imei: Imei, flag: sharedFlag, acces_Token: access_Token)
        sharedflag = sharedFlag
        imei = Imei
    }
    
     // MARK: Make showResultdialogBox Method
    func showResultDialogBox()
    {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as!  ResultViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(userVC, animated: true, completion: nil)
    }
     // MARK: Make showNetworkDiologBox Method
    func showNetworkDialogBox(flag: Bool)
    {
        if(flag == false)
        {
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
            
            userVC.sharedFlag = false
        userVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(userVC, animated: true, completion: nil)
    }
    if(flag == true)
    {
        
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.sharedFlag = true
         userVC.scanresetCallBackNoBtn = {
            self.scanImeiViewController?.creatCameraView()
        }
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    }
     // MARK: Make showScanVC Method
    func showScanVC()
    {
        if(scanBtnFlag == false)
        {
        showSnackBar(message: "Please place the barcode inside the box.".localized())
        typeImeiVC.isHidden = true
        scanImeiVC.isHidden = false
        cameraAccessVC.isHidden = true
        typeImeiBtn.isDividerHidden = true
        scanImeiBtn.isDividerHidden = false
        typeImeiFlag = true
        scanBtnFlag = true
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ScanImeiViewController") as! ScanImeiViewController
        scanImeiViewController = userVC
        userVC.view.frame = CGRect(x: 0, y: 0, width: scanImeiVC.frame.size.width, height: scanImeiVC.frame.size.height)
        addChild(userVC)
        userVC.scanImei = (typeImeiViewController?.enterImeiTextField.text)!
        scanImeiVC.addSubview(userVC.view)
        userVC.didMove(toParent: self)
        typeImeiViewController?.enterImeiTextField.resignFirstResponder()
        }
    }
    
     // MARK: Make showtypeImeiVc Method
    func showTypeImeiVC()
    {
        let TypeVisible = MyVariables.scannerVisible
        typeImeiVC.isHidden = false
        scanImeiVC.isHidden = true
        scanBtnFlag = false
        cameraAccessVC.isHidden = true
        scanImeiVC.isHidden = true
        scanImeiBtn.isDividerHidden = true
        typeImeiBtn.isDividerHidden = false
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "TypeImeiViewController") as! TypeImeiViewController
        typeImeiViewController = userVC
        userVC.view.frame = CGRect(x: 0, y: 0, width: typeImeiVC.frame.size.width, height: typeImeiVC.frame.size.height)
        addChild(userVC)
        typeImeiVC.addSubview(userVC.view)
        userVC.didMove(toParent: self)
        if(typeImeiFlag == true)
        {
                typeImeiViewController?.enterImeiTextField.text = self.scanImeiViewController?.scanImei
                self.typeImeiViewController?.stateSaveValidation()
            typeImeiViewController?.enterImeiTextField.resignFirstResponder()
        }
    }
     // MARK: Make showAllowAccess Method
    func showAllowAccessVC()
    {
        typeImeiVC.isHidden = true
        scanImeiVC.isHidden = true
        cameraAccessVC.isHidden = false
        scanImeiVC.isHidden = true
        typeImeiBtn.isDividerHidden = true
        scanImeiBtn.isDividerHidden = false
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "AllowAccessViewController") as! AllowAccessViewController
        allowAccessViewController = userVC
        userVC.view.frame = CGRect(x: 0, y: 0, width: cameraAccessVC.frame.size.width, height: cameraAccessVC.frame.size.height)
        addChild(userVC)
        cameraAccessVC.addSubview(userVC.view)
        userVC.didMove(toParent: self)
    }
     // MARK: Make getImeirequest Method
    func getImeiRequest(imei:String ,flag:Bool,acces_Token:String)
  {
    let request = Home.GetImei.Request(imei:imei,imeiflag:flag ,access_Token: acces_Token)
    interactor?.doGetImei(request: request)
  }
   // MARK: Make displayGetImeiResponse Method
  func displayGetImeiResponse(viewModel: Home.GetImei.ViewModel)
  {
    if(viewModel.statusCode == 200)
    {
        spinner.dismiss()
        if(viewModel.gsmaApprovedTac == "Yes")
        {
         let userVC = self.storyboard?.instantiateViewController(withIdentifier: "DeviceInformationViewController") as!  DeviceInformationViewController
            userVC.Imei = imei
            userVC.deviceId = viewModel.deviceId!
            userVC.manufacturer = viewModel.manufacturer!
            userVC.equipmentType = viewModel.equipmentType!
            userVC.brandName = viewModel.brandName!
            userVC.modelName = viewModel.modelName!
            userVC.marketingName = viewModel.marketingName!
            userVC.internalModelName = viewModel.internalModelName!
            userVC.tacApprovedDate = viewModel.tacApprovedDate!
            userVC.deviceCertifybody = viewModel.deviceCertifybody
            userVC.radioInterface = viewModel.radioInterface
            userVC.operatingSystem = viewModel.operatingSystem
            userVC.simSupport = viewModel.simSupport!
            userVC.nfcSupport = viewModel.nfcSupport!
            userVC.blueToothSupport = viewModel.blueToothSupport!
            userVC.wlanSupport = viewModel.wlanSupport!
            userVC.lpwan = viewModel.lpwan!
             deviceInformationViewController = userVC
            let appDlg = UIApplication.shared.delegate as? AppDelegate
            appDlg?.window?.rootViewController = userVC
        }
         if(viewModel.gsmaApprovedTac == "No")
         {
            if( sharedflag == true)
            {
                scanImeiViewController?.scanner?.stopScanning()
            }
            
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as!  ResultViewController
             userVC.language = language
            userVC.imei = imei
            resultViewController = userVC
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
    }
    else if(viewModel.statusCode == 401)
    {
        self.spinner.dismiss()
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "SessionDialogBoxViewController") as!  SessionDialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
        
    else {

        self.spinner.dismiss()
        if( sharedflag == true)
        {
            scanImeiViewController?.creatCameraView()
        }
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
        userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
  }
}
 // MARK: Make extension menuBtnClick Method
fileprivate extension HomeViewController {
    @objc
    func menuBtnClick(button: UIButton) {
        print("menu Btn")
        self.slideMenuController()?.openLeft()
    }
}
 // MARK: extension UIApplication Method
extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}
 // MARK: Make struct  global variables
struct MyVariables {
    static var scannerVisible = false
}

