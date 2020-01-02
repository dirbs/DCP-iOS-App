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
import JGProgressHUD
protocol HistoryDisplayLogic: class
{
  func displayHistory(viewModel: History.History.ViewModel)
     func displaySearchHistory(viewModel: History.SearchHistory.ViewModel)
}

class HistoryViewController: UIViewController, HistoryDisplayLogic,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{
   //Outlet
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var searchBtn: UIButton!
    
   
    @IBOutlet var titleOutlet: UILabel!
    @IBOutlet var historyToolBarView: UIView!
    //variables
    var language = "en"
    var access_token = ""
    var hideTableViewFlag = false
    var lastPage_N0 = 0
    var currentPage_N0 = 1
    var lastPage_N0_Search = 0
    var currentPage_N0_Search = 1
    var searchBtnFlag = false
    var addSpinnerButoomFlag = false
    var addSpinnerButoomFlagSearch = false
    var imei_No = "1"
    var viewchangeFlag = false
    var  refreshControl = UIRefreshControl()
    var buttomSpinner = UIActivityIndicatorView()
    var historyFlag = false
    @IBOutlet var norrecordFound: UILabel!
    var interactor: HistoryBusinessLogic?
  var router: (NSObjectProtocol & HistoryRoutingLogic & HistoryDataPassing)?

    @IBOutlet var historyTitle: UILabel!
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var searchTF: UISearchBar!
    var user_id = [String]()
    var date = [String]()
    var result = [String]()
    var user_device = [String]()
    var user_name = [String]()
    var visitor_ip = [String]()
    let spinner = JGProgressHUD(style: .extraLight)
    var buttomscroll = false
    var buttomscrollSearch = false
    var searchFlag = false
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
  
  // MARK: Setup
  private func setup()
  {
    let viewController = self
    let interactor = HistoryInteractor()
    let presenter = HistoryPresenter()
    let router = HistoryRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
//    if let scene = segue.identifier {
//      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//      if let router = router, router.responds(to: selector) {
//        router.perform(selector, with: segue)
//      }
//    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    getLanguage()
    setUpView()
    addRefreshControll(Flag: true)
    requestForhistory(page_No: 1, flag: true)
    historyTableView.delegate = self
    historyTableView.dataSource = self
    addSpinnerButoomFlagSearch = true
    buttomscrollSearch = true
  }
     // MARK: Make  backBtnClick Method
    @IBAction func backBtnClick(_ sender: Any) {
        
        searchTF.resignFirstResponder()
        showHomeVC()
    }
     // MARK: Make  showHomeVC  Method
    func showHomeVC()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg!.window?.rootViewController = HomeVC
        appDlg?.window?.makeKeyAndVisible()
    }
     // MARK: Make  addButtomSpinner Method
    func addButtomSpinner()
    {
         buttomSpinner = UIActivityIndicatorView(style: .gray)
         buttomSpinner.startAnimating()
         buttomSpinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: historyTableView.bounds.width, height: CGFloat(44))
        self.historyTableView.tableFooterView =  buttomSpinner
        self.historyTableView.tableFooterView?.isHidden = false
    }
     // MARK: Make  override statusbarstyle Method
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
     // MARK: Make  setUpView Method
    func setUpView()
    {
        searchTF.placeholder = "Search IMEI".localized()
        historyTitle.text = "History".localized()
        titleOutlet.text = "History".localized()
        searchTF.delegate  = self
        addButtonOnkeyboard()
        searchTF.showsCancelButton = true
        searchTF.isHidden = true
        norrecordFound.text = "No record found!".localized()
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "AccessToken") != nil) {
            access_token = (preferences.object(forKey: "AccessToken") as? String)!
        }
        norrecordFound.isHidden = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "CANCEL".localized()
        self.searchTF.tintColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = UIColor.white
        let textFieldInsideUISearchBar = searchTF.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.white
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = UIColor(red:0.44, green:0.64, blue:0.77, alpha:1.0)
    }
     // MARK: Make  getLanguage Method
    func getLanguage()
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
                language = "vi"
            } else {
                language = "en"
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user_id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for:indexPath) as! HistoryTableViewCell
    if(user_id.count > 0)
    {
        cell.idOutlet.text = user_id[indexPath.row]
        cell.dateOutlet.text = date[indexPath.row]
        cell.userNameOutlet.text = user_name[indexPath.row]
        cell.resultOutlet.text = result[indexPath.row]
        cell.user_device_Outlet.text = user_device[indexPath.row]
        cell.visitor_ip_outlet.text = visitor_ip[indexPath.row]
        }
        return cell
    }
     // MARK: Make  addButtonOnKeyboard Method
    func addButtonOnkeyboard()
    {
        let donebtn =   UIBarButtonItem(title: "CANCEL".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HistoryViewController.cancelBtnPressed))
        donebtn.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        let searchBtn =  UIBarButtonItem(title: "Search".localized(), style: UIBarButtonItem.Style.plain, target: self, action: #selector(HistoryViewController.searchBtnPressed))
         searchBtn.tintColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0)
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        numberToolbar.items = [donebtn,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),searchBtn]
        numberToolbar.sizeToFit()
        numberToolbar.sizeToFit()
        searchTF.inputAccessoryView = numberToolbar
    }
     // MARK: Make  cancelBtnPressed Method
    @objc func cancelBtnPressed() {
        view.endEditing(true)
    }
    // MARK: donebtnPressed Method
    @objc func searchBtnPressed() {
        search()
        
        
    }
    // MARK: Make search Method
    func search()
    {
         searchTF.resignFirstResponder()
        if((searchTF.text?.isEmpty)!)
        {
        }
        else{
        if(searchBtnFlag == false)
        {
        buttomscroll = true
        buttomSpinner.isHidden = true
        addSpinnerButoomFlag = true
        buttomSpinner.isHidden = true
        refreshControl.removeFromSuperview()
        refreshControl.removeTarget(self, action: #selector(refreshistory), for: UIControl.Event.valueChanged)
        addRefreshControll(Flag: false)
        searchBtnFlag = true
        }
        let enteredText = Int(searchTF.text!)
        if enteredText != nil {
            requestForSearchhistory(page_No: 1, flag: true)
            }
        }
    }
     // MARK: Make searchBtnClick Method
    @IBAction func searchBtnClick(_ sender: UIButton) {
        historyToolBarView.isHidden = true
        searchTF.isHidden = false
        searchTF.becomeFirstResponder()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0;//Choose your custom row height
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         searchTF.showsCancelButton = true
        let totalCharacters = (searchBar.text?.appending(text).count ?? 0) - range.length
        return totalCharacters <= 16
    }
    
    
     // MARK: Make searchBarTextDidBegainEditing delegate Method
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchTF.showsCancelButton = true
    }
     // MARK: Make searchBarCancelButtonClicked delgate  Method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTF.isHidden = true
        historyToolBarView.isHidden = false
        refreshControl.removeFromSuperview()
        refreshControl.removeTarget(self, action: #selector(refreshSearch), for: UIControl.Event.valueChanged)
        addRefreshControll(Flag: true)
        searchTF.resignFirstResponder()
        user_id.removeAll()
        user_device.removeAll()
        date.removeAll()
        visitor_ip.removeAll()
        user_name.removeAll()
        result.removeAll()
        buttomscroll = false
        addSpinnerButoomFlag = false
        buttomscrollSearch = false
        addSpinnerButoomFlagSearch = false
        historyTableView.isHidden = true
        searchBtnFlag = false
        norrecordFound.isHidden = true
        buttomSpinner.isHidden = false
        historyFlag = false
        requestForhistory(page_No: 1, flag: true)
    }

     // MARK: Make scrollViewdidScroll Method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if(addSpinnerButoomFlag == false)
            {
                addButtomSpinner()
                addSpinnerButoomFlag = true
            }
            if(buttomscroll == false)
            {
                buttomscroll = true
                requestForhistory(page_No: 1, flag: false)
            }
            if(addSpinnerButoomFlagSearch == false)
            {
                addButtomSpinner()
                addSpinnerButoomFlagSearch = true
            }
            if(buttomscrollSearch == false)
            {
                buttomscrollSearch = true
                requestForSearchhistory(page_No: 1, flag: false)
            }
        }
    }
     // MARK: Make showLoading Method
    func showLoading()
    {
        self.spinner.textLabel.text = ""
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
    }
     // MARK: Make requestForHistory Method
    func requestForhistory(page_No: Int,flag:Bool)
  {
    if Reachability.isConnectedToNetwork() == true {
    if (flag == true)
    {
          showLoading()
        let convertedString = "\(page_No)"
        let request = History.History.Request(access_Token:access_token,language:language,page_No: convertedString)
        interactor?.doHistory(request: request)
    }
    else{
        if(currentPage_N0 <= lastPage_N0)
        {
            historyFlag = true
            currentPage_N0 += 1
            let converted_String  = "\(currentPage_N0)"
            let request = History.History.Request(access_Token:access_token,language:language,page_No:converted_String)
            interactor?.doHistory(request: request)
        }
        else{
            buttomSpinner.isHidden = true
            currentPage_N0 = 1
        }
    }
    }
    else{
           showNetworkDialogBox()
        
    }
  }
     // MARK: Make showNetworkDialogBox Method
    func showNetworkDialogBox()
    {
        spinner.dismiss()
        norrecordFound.isHidden = false
        buttomSpinner.isHidden = true
        addSpinnerButoomFlag = true
        buttomscroll = true
        user_id.removeAll()
        user_device.removeAll()
        date.removeAll()
        visitor_ip.removeAll()
        user_name.removeAll()
        result.removeAll()
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
        userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        self.refreshControl.endRefreshing()
        self.historyTableView.contentOffset = CGPoint.zero
    }
    // MARK: Make requestForSearch Method
    func requestForSearchhistory(page_No: Int,flag:Bool)
    {
        if Reachability.isConnectedToNetwork() == true {
        if (flag == true)
        {
            showLoading()
            searchFlag = false
            var convertedString = "\(page_No)"
            let request = History.SearchHistory.Request(imei_number:searchTF.text, access_Token:access_token,language:language,page_No:"1")
            interactor?.doSearchHistory(request: request)
        }
        else{
            if(currentPage_N0_Search <= lastPage_N0_Search)
            {
                searchFlag = true
                currentPage_N0_Search += 1
                let converted_String  = "\(currentPage_N0_Search)"
                let request = History.SearchHistory.Request(imei_number:imei_No, access_Token:access_token,language:language,page_No:converted_String)
                interactor?.doSearchHistory(request: request)
            }
            else{
                self.historyTableView.tableFooterView = UIView()
                currentPage_N0_Search = 1
            }
        }
        }
         else{
                 showNetworkDialogBox()
        }
    }
     // MARK: Make addRefreshControll Method
    func addRefreshControll(Flag:Bool)
    {
        if (Flag == true)
        {
            
            self.refreshControl.tintColor = UIColor.darkGray
        self.refreshControl.addTarget(self, action: #selector(refreshistory), for: UIControl.Event.valueChanged)
        historyTableView.addSubview(refreshControl)
    }
   if (Flag == false)
   {
           self.refreshControl.tintColor = UIColor.darkGray
            self.refreshControl.addTarget(self, action: #selector(refreshSearch), for: UIControl.Event.valueChanged)
            historyTableView.addSubview(refreshControl)
    }
    }
     // MARK: Make refreshHistory Method
    @objc func refreshistory(sender:AnyObject) {
        historyFlag = false
        requestForhistory(page_No: 1, flag: true)
    }
    
     // MARK: Make refreshSearch Method
    @objc func refreshSearch(sender:AnyObject) {
        requestForSearchhistory(page_No: 1, flag: true)
    }
    // MARK: Make displaySearch Method
    func displaySearchHistory(viewModel: History.SearchHistory.ViewModel){
        lastPage_N0_Search = viewModel.last_Page!
        print(viewModel.last_Page!)
        if(viewModel.status_code == 200)
        {
            spinner.dismiss()
            imei_No = searchTF.text!
            if(viewModel.id.count == 0)
            {
                if(searchFlag == false)
                {
                user_id = viewModel.id
                date = viewModel.date
                user_name = viewModel.user_name
                user_device = viewModel.user_device
                result = viewModel.result
                visitor_ip = viewModel.visitor_ip
                norrecordFound.isHidden = false
                addSpinnerButoomFlagSearch = true
                buttomscrollSearch = true
                buttomSpinner.isHidden = true
                refreshControl.endRefreshing()
                }
                else{
                    user_id.append(contentsOf: viewModel.id)
                    date.append(contentsOf: viewModel.date)
                    user_name.append(contentsOf: viewModel.user_name)
                    result.append(contentsOf: viewModel.result)
                    user_device.append(contentsOf: viewModel.user_device)
                    visitor_ip.append(contentsOf: viewModel.visitor_ip)
                    buttomscrollSearch = false
                }
            }
            if(viewModel.id.count != 0)
            {
                 addSpinnerButoomFlagSearch = false
                 norrecordFound.isHidden = true
                if(searchFlag == false)
                {
                    user_id = viewModel.id
                    date = viewModel.date
                    user_name = viewModel.user_name
                    user_device = viewModel.user_device
                    result = viewModel.result
                    visitor_ip = viewModel.visitor_ip
                }
                
                if(searchFlag == true)
                {
                    user_id.append(contentsOf: viewModel.id)
                    date.append(contentsOf: viewModel.date)
                    user_name.append(contentsOf: viewModel.user_name)
                    result.append(contentsOf: viewModel.result)
                    user_device.append(contentsOf: viewModel.user_device)
                    visitor_ip.append(contentsOf: viewModel.visitor_ip)
                }
                refreshControl.endRefreshing()
                buttomscrollSearch = false
            }
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
        else  if(viewModel.status_code == 401)
        {
            spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "SessionDialogBoxViewController") as!  SessionDialogBoxViewController
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
        }
            
        else  {
            spinner.dismiss()
            norrecordFound.isHidden = false
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
            userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
            userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(userVC, animated: true, completion: nil)
            refreshControl.endRefreshing()
            self.historyTableView.contentOffset = CGPoint.zero
        }
    }
   // MARK: Make displayHistory Method
  func displayHistory(viewModel: History.History.ViewModel)
  {
    lastPage_N0 = viewModel.last_Page!
    if(viewModel.status_code == 200)
    {
         spinner.dismiss()
         historyTableView.isHidden = false
        if(historyFlag == true)
        {
            norrecordFound.isHidden = true
            user_id.append(contentsOf: viewModel.id)
            date.append(contentsOf: viewModel.date)
            user_name.append(contentsOf: viewModel.user_name)
            result.append(contentsOf: viewModel.result)
            user_device.append(contentsOf: viewModel.user_device)
            visitor_ip.append(contentsOf: viewModel.visitor_ip)
            refreshControl.endRefreshing()
            buttomSpinner.isHidden = false
            buttomscroll = false
            
        }
        else{
            norrecordFound.isHidden = true
            user_id.removeAll()
            date.removeAll()
            user_name.removeAll()
            user_device.removeAll()
            result.removeAll()
            visitor_ip.removeAll()
            user_id = viewModel.id
            date = viewModel.date
            user_name = viewModel.user_name
            user_device = viewModel.user_device
            result = viewModel.result
            visitor_ip = viewModel.visitor_ip
             refreshControl.endRefreshing()
            buttomSpinner.isHidden = false
            buttomscroll = false
        }
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
    }
    else  if(viewModel.status_code == 401)
    {
         spinner.dismiss()
         let userVC = self.storyboard?.instantiateViewController(withIdentifier: "SessionDialogBoxViewController") as!  SessionDialogBoxViewController
         userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
         self.present(userVC, animated: true, completion: nil)

    }
        
    else  {
        spinner.dismiss()
        norrecordFound.isHidden = false
        spinner.isHidden = true
        spinner.removeFromSuperview()
        addSpinnerButoomFlag = true
        user_id.removeAll()
        date.removeAll()
        user_name.removeAll()
        user_device.removeAll()
        result.removeAll()
        visitor_ip.removeAll()
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "ErrorDilogBoxViewController") as!  ErrorDilogBoxViewController
        userVC.message = "Sorry, somthing went wrong. Try again a little later.".localized()
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
            
        }
        self.refreshControl.endRefreshing()
        self.historyTableView.contentOffset = CGPoint.zero
    }
  }
}
