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
import SlideMenuControllerSwift
import Localize_Swift
import JGProgressHUD
protocol FeedBackDisplayLogic: class{
  func displayFeedback(viewModel: FeedBack.Feedback.ViewModel)
}
class FeedBackViewController: UIViewController, FeedBackDisplayLogic , UITextViewDelegate
{
    // outlet
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var submitFeedBackBtn: UIButton!
    @IBOutlet var countOutlet: UILabel!
    @IBOutlet var dcpFeedBackTitleOutlet: UILabel!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var feedBackTextView: UITextView!
    @IBOutlet var feedbackTitle: UILabel!
    // variables
    var access_token = ""
    var language = "en"
    let spinner = JGProgressHUD(style: .extraLight)
  var interactor: FeedBackBusinessLogic?
  var router: (NSObjectProtocol & FeedBackRoutingLogic & FeedBackDataPassing)?

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
    let interactor = FeedBackInteractor()
    let presenter = FeedBackPresenter()
    let router = FeedBackRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
     // MARK: Make textView delegate Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 255
    }
     // MARK: Make extension showLoading Method
    func showLoading(){
        self.spinner.textLabel.text = "Submitting FeedBack".localized()
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
    }
     // MARK: Make textViewDidchange event Method
    func textViewDidChange(_ textView: UITextView) {
        var countText = 0
        countText  = (feedBackTextView.text?.count)!
        countOutlet.text = "\(countText) / 255"
           }
  // MARK: Routing
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  // MARK: View lifecycle
  override func viewDidLoad(){
    super.viewDidLoad()
    setUpView()
    getLanguage()
  }
     // MARK: Make getLanguage Method
    func getLanguage(){
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
                 language = "vi"
            } else {
                language = "en"
            }
        }
    }
     // MARK: Make setUpView Method
    func setUpView(){
        feedBackTextView.delegate = self
        dcpFeedBackTitleOutlet.text = "feedBack".localized()
        submitFeedBackBtn.setTitle("SUBMIT FEEDBACK".localized(), for: .normal)
        feedbackTitle.text = "Send Feedback".localized()
         feedBackTextView.layer.cornerRadius = 10
         feedBackTextView.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        feedBackTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
         feedBackTextView.layer.borderWidth = 2
         // set gradient color of submit feedback btn
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = submitFeedBackBtn.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4
        submitFeedBackBtn.layer.cornerRadius = 10
        submitFeedBackBtn.layer.addSublayer(gradientLayer)
        errorMessage.text = "can't be empty!".localized()
        errorMessage.isHidden = true
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "AccessToken") != nil) {
            access_token = (preferences.object(forKey: "AccessToken") as? String)!
        }
        addButtonOnkeyboard()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     // MARK: Make showNetworkDiologBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    // MARK: Make backBtnPress Method
    @IBAction func backBtnPress(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = slideMenuController
        appDlg?.window?.makeKeyAndVisible()
    }
    // MARK: Make addButtonKeyBoard Method
    func addButtonOnkeyboard(){
        let doneBtn  = UIBarButtonItem(title: "DONE".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(ReportViewController.doneBtnPressed))
        doneBtn.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            doneBtn]
        numberToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        feedBackTextView.inputAccessoryView = numberToolbar
        MyVariables.scannerVisible = false
    }
    // MARK: donebtnPressed Method
    @objc func doneBtnPressed() {
        view.endEditing(true)
    }
    // MARK: Make submitFeedBackClick Method
    @IBAction func submitFeedBackClick(_ sender: UIButton) {
    let getFeedbackString = feedBackTextView.text.trimmingCharacters(in: .whitespaces)
        if(getFeedbackString.isEmpty)
        {
            errorMessage.isHidden = false
        }
        
        else{
            errorMessage.isHidden = true
            feedBackTextView.resignFirstResponder()
             if Reachability.isConnectedToNetwork() == true {
            showLoading()
          requestForFeedback()
            }
             else{
                showNetworkDialogBox()
            }
        }
    }
    // MARK: Make requestForFeedBack Method
  func requestForFeedback(){
    let request = FeedBack.Feedback.Request(message:feedBackTextView.text, access_Token:access_token,language:language)
    interactor?.doFeedBack(request: request)
    
    }
    // MARK: Make displayFeedback Method
  func displayFeedback(viewModel: FeedBack.Feedback.ViewModel){
    if(viewModel.status_code == 200)
    {
        spinner.dismiss()
        feedBackTextView.text = ""
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "successDilogBoxViewController") as!  SuccessDilogBoxViewController
        let message = viewModel.message
        userVC.message  = message
        userVC.messagetitle = "Feedback sent".localized()
        userVC.okBtnFlag = "FeeddbackScreen"
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
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




