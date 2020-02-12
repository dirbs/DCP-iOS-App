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
import Localize_Swift
import SlideMenuControllerSwift
class NeviagtionDrawerVC: UIViewController {
    // Outlet
    @IBOutlet var userName: UILabel!
    @IBOutlet var feedBackImageView: UIImageView!
    @IBOutlet var logoutImageView: UIImageView!
    @IBOutlet var historyImageView: UIImageView!
    @IBOutlet var homeImageView: UIImageView!
    @IBOutlet var feedbackBtn: UIButton!
    @IBOutlet var changeLanguageBtn: UIButton!
    @IBOutlet var historyBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!
    @IBOutlet var homeBtn: UIButton!
    @IBOutlet var emailOutlet: UILabel!
    // variables
    var flag = false
    var email = ""
    var user_Name = ""
    var language = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "email") != nil) {
            email = (preferences.object(forKey: "email") as? String)!
        }
        if (preferences.object(forKey: "user_Name") != nil) {
            user_Name = (preferences.object(forKey: "user_Name") as? String)!
            print("user_Name")
            userName.text = user_Name
        }
         flag  = UserDefaults.standard.bool(forKey: "adminFlag")
        setUpView()
    }
    
    
   // MARK: Make setUpView Method
    func setUpView(){
        
        //set the title of button
        homeBtn.setTitle("Home".localized(), for: .normal)
        historyBtn.setTitle("History".localized(), for: .normal)
        logoutBtn.setTitle("Logout".localized(), for: .normal)
        feedbackBtn.setTitle("feedBack".localized(), for: .normal)
        emailOutlet.text = email
        if (flag == false)
        {
            feedbackBtn.isHidden = true
            feedBackImageView.isHidden = true
        }
        else{
            feedbackBtn.setTitle("Logout".localized(), for: .normal)
            logoutImageView.image = UIImage(named: "ic_feedback")
            logoutBtn.setTitle("feedBack".localized(), for: .normal)
            feedBackImageView.image = UIImage(named: "ic_input")
        }
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
    
    // MARK: Make feedBackBtnclick Method
    @IBAction func feedbackBtnClick(_ sender: UIButton) {
        if (flag == false)
        {
            showfeedback()
        }
        else{
            showLogoutDialogBox()
        }
    }
    // MARK: Make showfeedBack Method
    func showfeedback(){
        logoutBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        historyBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        homeBtn.backgroundColor = UIColor.white
        //change the tint color of logout Btn
        logoutImageView.image = logoutImageView.image?.withRenderingMode(.alwaysTemplate)
        logoutImageView.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        logoutBtn.setTitleColor(UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0), for: .normal)
        //change the tint color of history Btn
        historyImageView.image = historyImageView.image?.withRenderingMode(.alwaysTemplate)
        historyImageView.tintColor = UIColor.lightGray
        historyBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of logout Btn
        homeImageView.image = homeImageView.image?.withRenderingMode(.alwaysTemplate)
        homeImageView.tintColor = UIColor.lightGray
        homeBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of feedback Btn
        feedBackImageView.image = feedBackImageView.image?.withRenderingMode(.alwaysTemplate)
        feedBackImageView.tintColor = UIColor.lightGray
        feedbackBtn.setTitleColor(UIColor.black, for: .normal)
        self.slideMenuController()?.closeLeft()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC  = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackViewController") as!  FeedBackViewController
        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = slideMenuController
        appDlg?.window?.makeKeyAndVisible()
    }
    // MARK: Make homeBtnTouchDown Method
    @IBAction func homeBtnTouchDown(_ sender: UIButton) {
        //change the tint color of btn
        homeBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        feedbackBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        historyBtn.backgroundColor = UIColor.white
    }
    // MARK: Make historybtnTouchdown Method
    @IBAction func historyBtntouchDown(_ sender: UIButton) {
         //change the tint color of btn
        historyBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        feedbackBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        homeBtn.backgroundColor = UIColor.white
    }
    // MARK: Make logoutTouchdown Method
    @IBAction func logouttouchdown(_ sender: UIButton) {
         //change the tint color of btn
        logoutBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        feedbackBtn.backgroundColor = UIColor.white
        homeBtn.backgroundColor = UIColor.white
        historyBtn.backgroundColor = UIColor.white
    }
    // MARK: Make feedbackTouchDown Method
    @IBAction func feedbackTouchDown(_ sender: Any) {
        feedbackBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        homeBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        historyBtn.backgroundColor = UIColor.white
    }
    // MARK: Make historyBtnClick Method
    @IBAction func historyBtnClick(_ sender: UIButton) {
        showHistoryVC()
    }
    // MARK: Make homeBtnClick Method
    @IBAction func homeBtnClick(_ sender: UIButton) {
      showHomeVC()
    }
    // MARK: Make logOutBtn Method
    @IBAction func logOutBtn(_ sender: UIButton) {
        if (flag == false)
        {
         showLogoutDialogBox()
        }
        else{
             showfeedback()
        }
    }
    // MARK: Make showHomeVC Method
    func showHomeVC(){
        homeBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        historyBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        feedbackBtn.backgroundColor = UIColor.white
        //change the tint color of home Btn
        homeImageView.image = homeImageView.image?.withRenderingMode(.alwaysTemplate)
        homeImageView.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        homeBtn.setTitleColor(UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0), for: .normal)
        //change the tint color of history Btn
        historyImageView.image = historyImageView.image?.withRenderingMode(.alwaysTemplate)
        historyImageView.tintColor = UIColor.lightGray
        historyBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of feedback Btn
        feedBackImageView.image = feedBackImageView.image?.withRenderingMode(.alwaysTemplate)
        feedBackImageView.tintColor = UIColor.lightGray
        feedbackBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of logout Btn
        logoutImageView.image = logoutImageView.image?.withRenderingMode(.alwaysTemplate)
        logoutImageView.tintColor = UIColor.lightGray
        logoutBtn.setTitleColor(UIColor.black, for: .normal)
        self.slideMenuController()?.closeLeft()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = slideMenuController
        appDlg?.window?.makeKeyAndVisible()
    }
    // MARK: Make showLogoutDialogBox Method
    func showLogoutDialogBox(){
        logoutBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        historyBtn.backgroundColor = UIColor.white
        homeBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        //change the tint color of feedback Btn
        feedBackImageView.image = feedBackImageView.image?.withRenderingMode(.alwaysTemplate)
        feedBackImageView.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        feedbackBtn.setTitleColor(UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0), for: .normal)
        //change the tint color of logout Btn
        logoutImageView.image = logoutImageView.image?.withRenderingMode(.alwaysTemplate)
        logoutImageView.tintColor = UIColor.lightGray
        logoutBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of history Btn
        historyImageView.image = historyImageView.image?.withRenderingMode(.alwaysTemplate)
        historyImageView.tintColor = UIColor.lightGray
        historyBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of home Btn
        homeImageView.image = homeImageView.image?.withRenderingMode(.alwaysTemplate)
        homeImageView.tintColor = UIColor.lightGray
        homeBtn.setTitleColor(UIColor.black, for: .normal)
        self.slideMenuController()?.closeLeft()
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutDialogBoxViewController") as!  LogOutDialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    @IBAction func hh(_ sender: UIButton) {
        
          print("drag outside")
    }
    // MARK: Make showHistoryVC Method
    func showHistoryVC(){
        
        historyBtn.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        homeBtn.backgroundColor = UIColor.white
        logoutBtn.backgroundColor = UIColor.white
        feedbackBtn.backgroundColor = UIColor.white
        //change the tint color of history Btn
        historyImageView.image = historyImageView.image?.withRenderingMode(.alwaysTemplate)
        historyImageView.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        historyBtn.setTitleColor(UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0), for: .normal)
        //change the tint color of home Btn
        homeImageView.image = homeImageView.image?.withRenderingMode(.alwaysTemplate)
        homeImageView.tintColor = UIColor.lightGray
        homeBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of feedback Btn
        feedBackImageView.image = feedBackImageView.image?.withRenderingMode(.alwaysTemplate)
        feedBackImageView.tintColor = UIColor.lightGray
        feedbackBtn.setTitleColor(UIColor.black, for: .normal)
        //change the tint color of logout Btn
        logoutImageView.image = logoutImageView.image?.withRenderingMode(.alwaysTemplate)
        logoutImageView.tintColor = UIColor.lightGray
        logoutBtn.setTitleColor(UIColor.black, for: .normal)
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeLeft()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as!  HistoryViewController
        let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
        let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = slideMenuController
        appDlg?.window?.makeKeyAndVisible()
    }
    
    // MARK: Make changeLanguageBtn Method
    @IBAction func changeLanguageBtn(_ sender: UIButton) {
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "CurrentLanguage") != nil) {
            var language = (preferences.object(forKey: "CurrentLanguage") as? String)!
            if(language == "vi") {
                language = "en"
                let preferences = UserDefaults.standard
                preferences.set(language, forKey: "CurrentLanguage")
                _ = preferences.synchronize()
                Localize.setCurrentLanguage("en")
                self.slideMenuController()?.closeLeft()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
                let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
                 let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg!.window?.rootViewController = slideMenuController
                appDlg!.window?.makeKeyAndVisible()
            } else {
                language = "vi"
                let preferences = UserDefaults.standard
                preferences.set(language, forKey: "CurrentLanguage")
                _ = preferences.synchronize()
                Localize.setCurrentLanguage("vi")
                self.slideMenuController()?.closeLeft()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let LeftNeviagationDrawer = storyboard.instantiateViewController(withIdentifier: "NeviagtionDrawerVC") as! NeviagtionDrawerVC
                let slideMenuController = SlideMenuController(mainViewController: HomeVC, leftMenuViewController: LeftNeviagationDrawer)
                let appDlg = UIApplication.shared.delegate as? AppDelegate
                appDlg!.window?.rootViewController = slideMenuController
                appDlg?.window?.makeKeyAndVisible()
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
