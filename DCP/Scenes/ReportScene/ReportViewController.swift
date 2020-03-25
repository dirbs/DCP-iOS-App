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
import Photos
import Foundation
import AMPopTip
import JGProgressHUD
import ImagePicker
protocol ReportDisplayLogic: class{
    func displayReport(viewModel: Report.Report.ViewModel)
}
class ReportViewController: UIViewController,UITextFieldDelegate, ReportDisplayLogic , UICollectionViewDelegate, UICollectionViewDataSource{
    // outlet
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var submitHeight: NSLayoutConstraint!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    @IBOutlet var storeNameErrorMessage: UILabel!
    @IBOutlet var submitBtnOutlet: UIButton!
    @IBOutlet var selectImageBtn: UIButton!
    @IBOutlet var deviceImageOutlet: UILabel!
    @IBOutlet var descriptionErrorMessage: UILabel!
    @IBOutlet var descriptionTf: UITextField!
    @IBOutlet var modelNameTf: UITextField!
    @IBOutlet var mobilePhoneBrandErrorMessage: UILabel!
    @IBOutlet var mobilePhoneBrandTf: UITextField!
    @IBOutlet weak var smallContainerView: UIView!
    @IBOutlet var addressErrorMessage: UILabel!
    @IBOutlet var addressTf: UITextField!
    @IBOutlet var modelNameErrorMessage: UILabel!
    @IBOutlet var storeNameTf: UITextField!
    @IBOutlet var reportMobilePhoneOutlet: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet var selectImageDescriptionBtn: UIButton!
    @IBOutlet var modelNameBtn: UIButton!
    @IBOutlet var mobilePhoneBrandBtn: UIButton!
    @IBOutlet var descriptionBtn: UIButton!
    @IBOutlet var addressBtn: UIButton!
    @IBOutlet var storeNameBtn: UIButton!
    // variables
    var arrayOfImage:[UIImage] = []
    let ImageViewBackButton = UIButton()
    var reportStateSave = false
    var saveMobilePhoneBrand = ""
    var saveModelName = ""
    var saveStoreName = ""
    var saveAddress = ""
    var saveDescription = ""
    let popTip = PopTip()
    var Imagecount = 0
    var imei = ""
    var access_Token = ""
    var language = "en"
    let spinner = JGProgressHUD(style: .extraLight)
    var selectImageFlag  = false
    var interactor: ReportBusinessLogic?
    var router: (NSObjectProtocol & ReportRoutingLogic & ReportDataPassing)?
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as!  CollectionViewCell
        cell.imageView.image = arrayOfImage[indexPath.row]
        cell.backBtn.tag = indexPath.row
        cell.backBtn.addTarget(self, action: #selector(editGroupAction(sender:)), for: .touchUpInside)
        return cell
        
    }
    // MARK: Make editGroupAction Method
    @objc func editGroupAction(sender: UIButton) {
        print("Button \(sender.tag) Clicked")
        arrayOfImage.remove(at: sender.tag)
        collectionView.reloadData()
        if(arrayOfImage.count == 0){
            viewHeight.constant = 590
            submitHeight.constant = 60
            collectionView.isHidden = true
            collectionView.isHidden = true
            selectImageFlag  = false
        }
    }
    // MARK: Make setUpTooltip Method
    func setUpToolTip(){
        popTip.edgeMargin = 5
        popTip.offset = 2
        popTip.edgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        popTip.backgroundColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0)
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.textColor = Color.white
        popTip.shadowColor = Color.white
        popTip.bubbleColor = Color.black
    }
    // MARK: Make saveReportData Method
    func saveReportDate(){
        saveMobilePhoneBrand = mobilePhoneBrandTf.text!
        saveModelName = modelNameTf.text!
        saveStoreName = storeNameTf.text!
        saveAddress = addressTf.text!
        saveDescription = descriptionTf.text!
        reportStateSave = true
        let preferences = UserDefaults.standard
        if(preferences.object(forKey: "MobilePhoneBrand") == nil) {
            
            preferences.set(saveMobilePhoneBrand, forKey: "MobilePhoneBrand")
            _ = preferences.synchronize()
        }
        if(preferences.object(forKey: "ModelName") == nil) {
            
            preferences.set(saveModelName, forKey: "ModelName")
            _ = preferences.synchronize()
        }
        if(preferences.object(forKey: "StoreName") == nil) {
            preferences.set(saveStoreName, forKey: "StoreName")
            _ = preferences.synchronize()
            
        }
        if(preferences.object(forKey: "Address") == nil) {
            
            preferences.set(saveAddress, forKey: "Address")
            _ = preferences.synchronize()
            
        }
        if(preferences.object(forKey: "Description") == nil) {
            
            preferences.set(saveDescription, forKey: "Description")
            _ = preferences.synchronize()
            
        }
        
        if(preferences.object(forKey: "Imei") == nil) {
            
            preferences.set(imei, forKey: "Imei")
            _ = preferences.synchronize()
            
        }
        if(preferences.object(forKey: "ReportStatusFlage") == nil) {
            preferences.set(reportStateSave, forKey: "ReportStatusFlage")
            _ = preferences.synchronize()
            
        }
    }
    // MARK: Make getSaveData Method
    func getSaveData(){
        reportStateSave   = UserDefaults.standard.bool(forKey: "ReportStatusFlage")
        if(reportStateSave == true){
            let preferences = UserDefaults.standard
            if(preferences.object(forKey: "MobilePhoneBrand") != nil) {
                (preferences.object(forKey: "MobilePhoneBrand") as? String)!
                mobilePhoneBrandTf.text = (preferences.object(forKey: "MobilePhoneBrand") as? String)!
            }
            if(preferences.object(forKey: "ModelName") != nil) {
                modelNameTf.text = (preferences.object(forKey: "ModelName") as? String)!
            }
            if(preferences.object(forKey: "StoreName") != nil) {
                storeNameTf.text = (preferences.object(forKey: "StoreName") as? String)!
            }
            if(preferences.object(forKey: "Address") != nil) {
                addressTf.text = (preferences.object(forKey: "Address") as? String)!
            }
            if(preferences.object(forKey: "Description") != nil) {
                descriptionTf.text = (preferences.object(forKey: "Description") as? String)!
            }
            if(preferences.object(forKey: "Imei") != nil) {
                imei = (preferences.object(forKey: "Imei") as? String)!
                
            }
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "MobilePhoneBrand")
            defaults.removeObject(forKey: "ModelName")
            defaults.removeObject(forKey: "StoreName")
            defaults.removeObject(forKey: "Address")
            defaults.removeObject(forKey: "Description")
            defaults.removeObject(forKey: "Imei")
            defaults.removeObject(forKey: "ReportStatusFlage")
            defaults.synchronize()
        }
    }
    // MARK: Make setUpProperties Method
    func  setUpProperties(){
        // set properties of report Phone Brand text field
        mobilePhoneBrandTf.layer.cornerRadius = 5
        mobilePhoneBrandTf.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        mobilePhoneBrandTf.layer.borderWidth = 2
        mobilePhoneBrandTf.placeholder = "Mobiel Phone Brand".localized()
        mobilePhoneBrandTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: mobilePhoneBrandTf.frame.height))
        mobilePhoneBrandTf.leftViewMode = .always
        mobilePhoneBrandTf.delegate = self
        // set properties of  model Name text field
        modelNameTf.layer.cornerRadius = 5
        modelNameTf.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        modelNameTf.layer.borderWidth = 2
        modelNameTf.placeholder = "Model Name".localized()
        modelNameTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height:  modelNameTf.frame.height))
        modelNameTf.leftViewMode = .always
        modelNameTf.delegate = self
        // set properties of   store name   text field
        storeNameTf.layer.cornerRadius = 5
        storeNameTf.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        storeNameTf.layer.borderWidth = 2
        storeNameTf.placeholder = "Store Name".localized()
        storeNameTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: storeNameTf.frame.height))
        storeNameTf.leftViewMode = .always
        storeNameTf.delegate = self
        // set properties of address text field
        addressTf.layer.cornerRadius = 5
        addressTf.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        addressTf.layer.borderWidth = 2
        addressTf.placeholder = "Address".localized()
        addressTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: addressTf.frame.height))
        addressTf.leftViewMode = .always
        addressTf.delegate = self
        // set properties of description text field
        descriptionTf.layer.cornerRadius = 5
        descriptionTf.layer.borderColor = UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.0).cgColor
        descriptionTf.layer.borderWidth = 2
        descriptionTf.placeholder = "Description".localized()
        descriptionTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: descriptionTf.frame.height))
        descriptionTf.leftViewMode = .always
        descriptionTf.delegate = self
        // set properties of device image  outlet
        deviceImageOutlet.text = "Device Image".localized()
        // set properties of submit btn
        submitBtnOutlet.setTitle("SUBMIT".localized(), for: .normal)
        reportMobilePhoneOutlet.text = "Report Mobile Phone".localized()
        // set gradient color of submit btn
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = submitBtnOutlet.frame.size
        let startColor = UIColor(red: 18/255, green: 93/255, blue: 141/255, alpha: 1.0)
        let endColor = UIColor(red: 11/255, green: 56/255, blue: 82/255, alpha: 1.0)
        gradientLayer.colors =
            [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 4
        submitBtnOutlet.layer.cornerRadius = 5
        submitBtnOutlet.layer.addSublayer(gradientLayer)
        // set properties of select Image btn
        selectImageBtn.setTitle("SELECT IMAGES".localized(), for: .normal)
        selectImageBtn.backgroundColor = UIColor.white
        selectImageBtn.layer.shadowColor = UIColor.black.cgColor
        selectImageBtn.layer.shadowOpacity = 0.25
        selectImageBtn.layer.shadowRadius = 3
        selectImageBtn.layer.shadowOffset = .zero
        // set properties of mobile phone brand error message
        mobilePhoneBrandErrorMessage.text = "can't be empty!".localized()
        mobilePhoneBrandErrorMessage.isHidden = true
        // set properties of model name  error message
        modelNameErrorMessage.text = "can't be empty!".localized()
        modelNameErrorMessage.isHidden = true
        // set properties of store name error message
        storeNameErrorMessage.text = "can't be empty!".localized()
        storeNameErrorMessage.isHidden = true
        // set properties of address error message
        addressErrorMessage.text = "can't be empty!".localized()
        addressErrorMessage.isHidden = true
        // set properties of decription error message
        descriptionErrorMessage.text = "can't be empty!".localized()
        descriptionErrorMessage.isHidden = true
        addButtonOnkeyboard()
        setUpToolTip()
        contentView.backgroundColor = UIColor.white
        let preferences = UserDefaults.standard
        if (preferences.object(forKey: "AccessToken") != nil) {
            access_Token = (preferences.object(forKey: "AccessToken") as? String)!
            print(access_Token)
        }
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
        mobilePhoneBrandTf.inputAccessoryView = numberToolbar
        modelNameTf.inputAccessoryView = numberToolbar
        storeNameTf.inputAccessoryView = numberToolbar
        addressTf.inputAccessoryView = numberToolbar
        descriptionTf.inputAccessoryView = numberToolbar
    }
    // MARK: donebtnPressed Method
    @objc func doneBtnPressed() {
        view.endEditing(true)
    }
    // MARK: Make validate Method
    func valiadte(){
        let getModelName = modelNameTf.text!.trimmingCharacters(in: .whitespaces)
        let getMobilePhoneBrand = mobilePhoneBrandTf.text!.trimmingCharacters(in: .whitespaces)
        let getStoreName = storeNameTf.text!.trimmingCharacters(in: .whitespaces)
        let getAddress = addressTf.text!.trimmingCharacters(in: .whitespaces)
        let getDescription = descriptionTf.text!.trimmingCharacters(in: .whitespaces)
        if((getModelName.isEmpty)){
            modelNameErrorMessage.isHidden = false
            modelNameTf.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(!(getModelName.isEmpty)){
            modelNameErrorMessage.isHidden = true
            modelNameTf.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if(getMobilePhoneBrand.isEmpty){
            mobilePhoneBrandErrorMessage.isHidden = false
            mobilePhoneBrandTf.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(!(getMobilePhoneBrand.isEmpty)){
            
            mobilePhoneBrandErrorMessage.isHidden = true
            mobilePhoneBrandTf.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if(getStoreName.isEmpty){
            storeNameErrorMessage.isHidden = false
            storeNameTf.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(!(getStoreName.isEmpty)){
            storeNameErrorMessage.isHidden = true
            storeNameTf.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if((getAddress.isEmpty)){
            addressErrorMessage.isHidden = false
            addressTf.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(!(getAddress.isEmpty)){
            addressErrorMessage.isHidden = true
            addressTf.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if((getDescription.isEmpty)){
            descriptionErrorMessage.isHidden = false
            descriptionTf.layer.borderColor = UIColor(red:0.85, green:0.13, blue:0.01, alpha:1.0).cgColor
        }
        if(!(getDescription.isEmpty)){
            descriptionErrorMessage.isHidden = true
            descriptionTf.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if(((!(getMobilePhoneBrand.isEmpty)) && !(getModelName.isEmpty)   && !(getStoreName.isEmpty) && !(getAddress.isEmpty) && !(getDescription.isEmpty))){
            mobilePhoneBrandTf.resignFirstResponder()
            modelNameTf.resignFirstResponder()
            storeNameTf.resignFirstResponder()
            addressTf.resignFirstResponder()
            descriptionTf.resignFirstResponder()
            modelNameErrorMessage.isHidden = true
            mobilePhoneBrandErrorMessage.isHidden = true
            storeNameErrorMessage.isHidden = true
            addressErrorMessage.isHidden = true
            descriptionErrorMessage.isHidden = true
            if Reachability.isConnectedToNetwork() == true {
                showLoading()
                requestForReport(imei_number: imei, access_Token: access_Token, language:language , brand_name: mobilePhoneBrandTf.text, model_name: modelNameTf.text, store_name: storeNameTf.text, address: addressTf.text, description: descriptionTf.text, arrayOfImage: arrayOfImage)
            }
            else{
                showNetworkDialogBox()
            }
        }
    }
    // MARK: Make showNetworkdialogBox Method
    func showNetworkDialogBox(){
        let userVC = self.storyboard?.instantiateViewController(withIdentifier: "NetworkdialogBoxViewController") as!  NetworkdialogBoxViewController
        userVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(userVC, animated: true, completion: nil)
    }
    // MARK: Make showLoading Method
    func showLoading(){
        self.spinner.textLabel.text = "Adding Device Information...".localized()
        self.spinner.textLabel.textColor = UIColor.black
        self.spinner.show(in: self.view)
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
    // MARK: Make mobilePhoneBtnClick Method
    @IBAction func mobilePhoneBtnClick(_ sender: UIButton) {
        popTip.show(text: "Enter the valid brand name of the device".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.mobilePhoneBrandBtn.frame)
    }
    // MARK: Make modelNameBtnClick Method
    @IBAction func modelNameBtnClick(_ sender: UIButton) {
        popTip.show(text: "Enter the valid model name of the device".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.modelNameBtn.frame)
    }
    // MARK: Make storeNameClick Method
    @IBAction func storeNameClick(_ sender: UIButton) {
        popTip.show(text: "Enter the valid store name of the device".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.storeNameBtn.frame)
    }
    // MARK: Make addressBtnClick Method
    @IBAction func addressBtnClick(_ sender: UIButton) {
        popTip.show(text: "Enter the valid address where the device is located.".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.addressBtn.frame)
    }
    // MARK: Make descriptionBtnClick Method
    @IBAction func descriptionBtnClick(_ sender: UIButton) {
        popTip.show(text: "Add description for your device".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.descriptionBtn.frame)
    }
    // MARK: Make selectImagetoolTipClick Method
    @IBAction func selectImagetoolTipClick(_ sender: UIButton) {
        popTip.show(text: "Upload valid images of the device".localized(), direction: .down, maxWidth: 250, in: self.contentView, from: self.selectImageDescriptionBtn.frame)
    }
    // MARK: Make checkPermission Method
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            AllowPermissionDialogBox()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    
                }
            })
        case .restricted:
            
            print("User do not have access to photo album.")
        case .denied:
            showPermissionDialogBox()
        }
    }
    // MARK: Make AllowPermissionDialogBox Method
    func AllowPermissionDialogBox(){
        allowPermissionOfcamera()
    }
    // MARK: Make showPermissionDialogBox Method
    func showPermissionDialogBox(){
        let alert = UIAlertController(title: title, message: "Allow DCP to access the Photos".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Allow".localized(), style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        self.saveReportDate()
                    })
                } else {
                    
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Deny".localized(), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: Make allowPermissionOfcamera Method
    func allowPermissionOfcamera(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            showCamerPermissionDialogBox()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            let configuration = Configuration()
            configuration.recordLocation = false
            configuration.doneButtonTitle = "DONE".localized()
            configuration.cancelButtonTitle = "CANCEL".localized()
            let imagePickerController = ImagePickerController(configuration: configuration)
            imagePickerController.imageLimit = 5
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
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
    // MARK: Make  showCamerPermissionDialogBox Method
    func showCamerPermissionDialogBox(){
        let alert = UIAlertController(title: title, message: "Allow DCP to access the camera".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Allow".localized(), style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                        self.saveReportDate()
                    })
                } else {
                    print ("open the camera")
                    // Fallback on earlier versions
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Deny".localized(), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: Setup
    private func setup(){
        let viewController = self
        let interactor = ReportInteractor()
        let presenter = ReportPresenter()
        let router = ReportRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    override func viewDidLoad(){
        super.viewDidLoad()
        getSaveData()
        getLanguage()
        setUpProperties()
        addScrolViewHide()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewHeight.constant = 590
        submitHeight.constant = 60
        collectionView.isHidden = true
    }
    // MARK: Make  selectImageBtnClick Method
    @IBAction func selectImageBtnClick(_ sender: UIButton) {
        arrayOfImage.removeAll()
        checkPermission()
    }
    // MARK: Make  selectImgaedescriptionBtnClick Method
    @IBAction func selectImagedescriptionBtnClick(_ sender: UIButton) {
        print("select Image description")
    }
    // MARK: Make  submitBtnClick Method
    @IBAction func submitBtnClick(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "MobilePhoneBrand")
        defaults.removeObject(forKey: "ModelName")
        defaults.removeObject(forKey: "StoreName")
        defaults.removeObject(forKey: "Address")
        defaults.removeObject(forKey: "Description")
        defaults.removeObject(forKey: "Imei")
        defaults.removeObject(forKey: "ReportStatusFlage")
        defaults.synchronize()
        valiadte()
    }
    // MARK: Make  textFieldDidBegainEditing Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addressTf {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if textField == mobilePhoneBrandTf {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if textField == descriptionTf{
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if textField == storeNameTf {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
        if textField == modelNameTf {
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor(red:0.07, green:0.36, blue:0.55, alpha:1.0).cgColor
        }
    }
    // MARK: Make  addScrolViewHide Method
    func addScrolViewHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    // MARK: Make  keyboardWillShow delegate Method
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if(selectImageFlag == true){
                viewHeight.constant = 1000
            }
            else{
                viewHeight.constant = 900
            }
        }
    }
    // MARK: Make  keyboardWillHide delegate Method
    @objc func keyboardWillHide(notification: NSNotification) {
        if(selectImageFlag == true){
            viewHeight.constant = 690
        }
        if(selectImageFlag == false){
            viewHeight.constant = 590
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("ligh content")
        return .lightContent
    }
    // MARK: Make  requestForreport Method
    func requestForReport( imei_number: String?,
                           access_Token: String?,language: String?,brand_name: String?,model_name: String?,store_name: String?,address: String?,description: String?,arrayOfImage: [UIImage]){
        let request = Report.Report.Request(imei_number: imei_number,access_Token: access_Token,language:language,brand_name:brand_name,model_name:model_name,store_name:store_name,address:address,description:description,arrayOfImage:arrayOfImage)
        interactor?.doReport(request: request)
    }
    // MARK: Make  displayReport Method
    func displayReport(viewModel: Report.Report.ViewModel){
        if(viewModel.status_code == 200){
            spinner.dismiss()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "successDilogBoxViewController") as!  SuccessDilogBoxViewController
            let message = viewModel.message
            userVC.message  = message
            userVC.messagetitle = "Reported".localized()
            userVC.okBtnFlag = "Report"
            userVC.reportbackResetCallBackOkBtn = {
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
    // MARK: Make  showHomeVC Method
    func showHomeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let HomeVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let appDlg = UIApplication.shared.delegate as? AppDelegate
        appDlg?.window?.rootViewController = HomeVC
    }
}
// MARK:Make  extension  imgaePickerdelegate Method
extension ReportViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        if(images.count >= 1){
            viewHeight.constant = 690
            submitHeight.constant = 160
            collectionView.isHidden = false
            selectImageFlag  = true
        }
        Imagecount = images.count - 1
        for i in 0..<images.count {
            if(arrayOfImage.count < 5){
                print(images[i].jpegData(compressionQuality: 0.7)!)
                arrayOfImage.append(images[i])
            }
        }
        collectionView.reloadData()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        imagePicker.dismiss(animated: true, completion: nil)
        
    }   
}
