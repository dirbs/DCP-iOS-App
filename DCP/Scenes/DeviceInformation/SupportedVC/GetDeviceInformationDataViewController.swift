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
import SwiftyJSON
class GetDeviceInformationDataViewController: UIViewController {
    //Outlet
    @IBOutlet var lpwanDetailTV: UITextView!
    @IBOutlet var lpwanImageView: UIImageView!
    @IBOutlet var lpwanTV: UITextView!
    @IBOutlet var wlanSupportDetailTV: UITextView!
    @IBOutlet var wlanSupportImageView: UIImageView!
    @IBOutlet var wlanSupportTV: UITextView!
    @IBOutlet var bluetoothSupportDetailTV: UITextView!
    @IBOutlet var blueToothSupportImageView: UIImageView!
    @IBOutlet var blurtoothSupportTV: UITextView!
    @IBOutlet var nfcSupportDetailTV: UITextView!
    @IBOutlet var nfcSupportImageView: UIImageView!
    @IBOutlet var nfcSupportTV: UITextView!
    @IBOutlet var simSupportDetailTV: UITextView!
    @IBOutlet var simSupportImageView: UIImageView!
    @IBOutlet var simSupportTV: UITextView!
    @IBOutlet var opertaingSystemDetailTV: UITextView!
    @IBOutlet var opertaingSystemImageView: UIImageView!
    @IBOutlet var OperatingSystemTV: UITextView!
    @IBOutlet var radioInterfaceImageView: UIImageView!
    @IBOutlet var radioInterfaceDetailTv: UITextView!
    @IBOutlet var radioInterfaceTV: UITextView!
    @IBOutlet var deviceCertifyDetailTV: UITextView!
    @IBOutlet var deviceCertifyBodyImageView: UIImageView!
    @IBOutlet var deviceCertifyBodyTV: UITextView!
    @IBOutlet var tacApprovedDateDetailTV: UITextView!
    @IBOutlet var tacApprovedDateImageView: UIImageView!
    @IBOutlet var internalModelNameDetailTv: UITextView!
    @IBOutlet var tacApprovedDateTV: UITextView!
    @IBOutlet var internalModelNameImageView: UIImageView!
    @IBOutlet var internalModelNameTV: UITextView!
    @IBOutlet var markeetingNameDetail: UITextView!
    @IBOutlet var markeetingNameImageView: UIImageView!
    @IBOutlet var marketingNameTV: UITextView!
    @IBOutlet var modelNameDetail: UITextView!
    @IBOutlet var modelNameImageView: UIImageView!
    @IBOutlet var modelNameTV: UITextView!
    @IBOutlet var brandNameDetailTV: UITextView!
    @IBOutlet var brandNameImageView: UIImageView!
    @IBOutlet var equipmentDetailTV: UITextView!
    @IBOutlet var brandNameTV: UITextView!
    @IBOutlet var equipmentTypeImageView: UIImageView!
    @IBOutlet var equipmentTypeTV: UITextView!
    @IBOutlet var manufacturedDetailTV: UITextView!
    @IBOutlet var manufacturedImageView: UIImageView!
    @IBOutlet var manufacturedTV: UITextView!
    @IBOutlet var deviceIdDetailTV: UITextView!
    @IBOutlet var deviceIdImageView: UIImageView!
    @IBOutlet var deviceIdTV: UITextView!
    // variables
    var Imei = ""
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    // MARK: Make  setUpView Method
    func setUpView(){
        deviceIdTV.text = "Device ID".localized()
        deviceIdTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        deviceIdDetailTV.text = Imei
        deviceIdDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        manufacturedTV.text = "Manufacturer".localized()
        manufacturedTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        manufacturedDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        manufacturedDetailTV.text = manufacturer
        equipmentTypeTV.text = "Equipment Type".localized()
        equipmentTypeTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        equipmentDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        equipmentDetailTV.text = equipmentType
        brandNameTV.text = "Brand Name".localized()
        brandNameTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        brandNameDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        brandNameDetailTV.text = brandName
        modelNameTV.text = "Model Name".localized()
        modelNameTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        modelNameDetail.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        modelNameDetail.text = modelName
        marketingNameTV.text = "Marketing Name".localized()
        marketingNameTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        markeetingNameDetail.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        markeetingNameDetail.text = marketingName
        internalModelNameTV.text = "Internal Model Name".localized()
        internalModelNameTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        internalModelNameDetailTv.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        internalModelNameDetailTv.text = internalModelName
        tacApprovedDateTV.text = "TAC Approved Date".localized()
        tacApprovedDateTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        tacApprovedDateDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        tacApprovedDateDetailTV.text = tacApprovedDate
        deviceCertifyBodyTV.text = "Device Certify Body".localized()
        deviceCertifyBodyTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        deviceCertifyDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        for obj in deviceCertifybody {
            deviceCertifyDetailTV.text = obj.stringValue
        }
        radioInterfaceTV.text = "Radio Interface".localized()
        radioInterfaceTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        radioInterfaceDetailTv.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        var getradioInterface = ""
        for obj in radioInterface {
            if(radioInterface.count > 1){
                getradioInterface  = getradioInterface   + "\u{2022}" + " " +  obj.stringValue + "\n"
            }
            else{
                getradioInterface  =  obj.stringValue
            }
            
        }
        radioInterfaceDetailTv.text = getradioInterface.trimmingCharacters(in: .whitespacesAndNewlines)
        OperatingSystemTV.text = "Operating System".localized()
        OperatingSystemTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        var getOperatingValue = ""
        for obj in operatingSystem {
            if(operatingSystem.count > 1){
                getOperatingValue =  getOperatingValue + "\u{2022}" + " "  +  obj.stringValue + "\n"
            }
            else{
                getOperatingValue = obj.stringValue
            }
        }
        opertaingSystemDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        opertaingSystemDetailTV.text = getOperatingValue.trimmingCharacters(in: .whitespacesAndNewlines)
        simSupportTV.text = "SIM Support".localized()
        simSupportTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        simSupportDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        simSupportDetailTV.text = simSupport
        nfcSupportTV.text = "NFC Support".localized()
        nfcSupportTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        nfcSupportDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        nfcSupportDetailTV.text = nfcSupport
        blurtoothSupportTV.text = "Bluetooth Support".localized()
        blurtoothSupportTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        bluetoothSupportDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        bluetoothSupportDetailTV.text = blueToothSupport
        wlanSupportTV.text = "WLAN Support".localized()
        wlanSupportTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        wlanSupportDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        wlanSupportDetailTV.text = wlanSupport
        lpwanTV.text = "LPWAN".localized()
        lpwanTV.textContainerInset = UIEdgeInsets(top: 8, left: 30, bottom: 0, right: 0)
        lpwanDetailTV.textContainerInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 0)
        lpwanDetailTV.text = lpwan
    }
}

