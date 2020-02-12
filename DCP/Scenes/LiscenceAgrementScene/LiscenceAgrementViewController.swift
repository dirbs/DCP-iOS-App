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
protocol LiscenceAgrementDisplayLogic: class
{
  func displayLiscenceUpdateResponse(viewModel: LiscenceAgrement.LiscenceUpdate.ViewModel)
}
class LiscenceAgrementViewController: UIViewController, LiscenceAgrementDisplayLogic
{
  var interactor: LiscenceAgrementBusinessLogic?
  var router: (NSObjectProtocol & LiscenceAgrementRoutingLogic & LiscenceAgrementDataPassing)?
    // Outlet
    @IBOutlet var continueBtn: UIButton!
    @IBOutlet var agreedCheckBtn: CheckButton!
    //Variables
    var getUserId  = 0
    var access_token = ""
    var htmlString = ""
    var language = ""
    var checkAgreedflag = false
    let spinner = JGProgressHUD(style: .extraLight)
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
    let interactor = LiscenceAgrementInteractor()
    let presenter = LiscenceAgrementPresenter()
    let router = LiscenceAgrementRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  // MARK: View lifecycle
  override func viewDidLoad(){
    super.viewDidLoad()
    //  Calling of Method
    getValueInPreferncess()
    setUpView()
  }
    // MARK: Creat getValueInPreferncess Method
    func getValueInPreferncess(){
        
        //Get the user_id in shared_Preferncess
        let preferences = UserDefaults.standard
        getUserId   = preferences.integer(forKey: "User_id")
        if (preferences.object(forKey: "AccessToken") != nil) {
            access_token = (preferences.object(forKey: "AccessToken") as? String)!
        }
    }
// MARK: Make setUpView Method
    func setUpView(){
        //set the title of agreed checkBtn
        agreedCheckBtn.setTitle("I agreed".localized(), for: .normal)
       //set the gradient color agreed checkBtn
        agreedCheckBtn.setIconColor(UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0), for: .selected)
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = continueBtn.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4

        //set the propertiess of continue Btn
        continueBtn.layer.cornerRadius = 5
        continueBtn.layer.addSublayer(gradientLayer)
        continueBtn.setTitle("CONTINUE".localized(), for: .normal)
        continueBtn.isUserInteractionEnabled = false
        continueBtn.alpha = 0.5
    }
  // MARK: Creat click Listener in continue Btn
    @IBAction func continueBtn(_ sender: UIButton) {
        //convert int value to string value
        let convertedString = "\(getUserId)"
        //check the internet conecticvity
         if Reachability.isConnectedToNetwork() == true {
        //request for network
        updateLiscenceRequest(access_Token: access_token, user_id: convertedString)
        }
         else{
            showNetworkDialogBox()
        }
    }
    // MARK: Override Method of statusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     // MARK: Creat showNetworkDialogBoxMethod
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
     // MARK: Creat click Listener agreed check Btn
    @IBAction func agreedCheckBtn(_ sender: CheckButton) {
        if(agreedCheckBtn.isSelected == true)
        {
            continueBtn.isUserInteractionEnabled = true
            continueBtn.alpha = 1
        }
        else{
            continueBtn.isUserInteractionEnabled = false
            continueBtn.alpha = 0.5
        }
    }
     // MARK: Make updeteLiscencerequest  Method
    func updateLiscenceRequest(access_Token: String ,user_id: String)
  {
    let request = LiscenceAgrement.LiscenceUpdate.Request(accessToken:access_Token,User_id:user_id)
    interactor?.doLiscenceUpdate(request: request)
  }
   // MARK: Make displayLiscenceUpdateResponse  Method
  func displayLiscenceUpdateResponse(viewModel: LiscenceAgrement.LiscenceUpdate.ViewModel){
    if(viewModel.status_code == 200)
    {
        let preferences = UserDefaults.standard
        preferences.set(false, forKey: "LiscenceFlag")
        _ = preferences.synchronize()
        spinner.dismiss()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        
        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = slideMenuController
        appDlg?.window?.makeKeyAndVisible()
    }
    
    if(viewModel.status_code == 401)
    {
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
