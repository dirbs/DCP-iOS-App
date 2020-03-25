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
import Alamofire
import Localize_Swift
import SwiftyJSON
class HomeWorker
{
    var baseUrl = Constants.Base_Url
    var jsonResult: JSON!
    var url = ""
    var statusCode: Int? = 0
    var statusMessage: String? = ""
    var deviceId :  String?  = ""
    var  brandName : String? = ""
    var modelName: String? = ""
    var internalModelName : String? = ""
    var marketingName: String? = ""
    var equipmentType: String? = ""
    var simSupport: String? = ""
    var nfcSupport: String? = ""
    var wlanSupport: String? = ""
    var blueToothSupport: String? = ""
    var operatingSystem = [JSON]()
    var radioInterface = [JSON]()
    var lpwan: String? = ""
    var deviceCertifybody = [JSON]()
    var manufacturer:  String? = ""
    var tacApprovedDate :  String? = ""
    var gsmaApprovedTac : String? = ""
    // MARK: Make getImei Method
    func getImei(Imei: String, flag: Bool, acess_token:String, completionHandler: @escaping (Int?, String?, String?, String?, String?, String?, String?, String?, String?, String?, String?,String?,[JSON]?,[JSON]?,String?,[JSON]?,String?,String?, String?) -> Void) {
        let parameters: Parameters = [ "imei": Imei]
        let headers = ["Authorization": "Bearer \(acess_token)",
            "Content-Type": "application/json",
            "Accept":"application/json"
        ]
        if(flag == false){
            url =  baseUrl+"api/lookup/iOSApp/manual"
        }
        if(flag == true){
            url =  baseUrl+"api/lookup/iOSApp/scanner"
        }
        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            let status = response.response?.statusCode
            self.statusCode = status
            if (status == 200){
                let data = response.data
                self.jsonResult = JSON(data!)
                // Parse json values
                if let device_id = self.jsonResult["data"]["deviceId"].string {
                    self.deviceId = device_id
                }
                if let brandName = self.jsonResult["data"]["brandName"].string {
                    self.brandName = brandName
                }
                if let modelName = self.jsonResult["data"]["modelName"].string {
                    self.modelName = modelName
                }
                if let internalModelName = self.jsonResult["data"]["internalModelName"].string {
                    self.internalModelName = internalModelName
                }
                if let marketingName = self.jsonResult["data"]["marketingName"].string {
                    self.marketingName = marketingName
                }
                if let equipmentType = self.jsonResult["data"]["equipmentType"].string {
                    self.equipmentType = equipmentType
                }
                if let simSupport = self.jsonResult["data"]["simSupport"].string {
                    self.simSupport = simSupport
                }
                if let nfcSupport = self.jsonResult["data"]["nfcSupport"].string {
                    self.nfcSupport = nfcSupport
                }
                if let  wlanSupport = self.jsonResult["data"]["wlanSupport"].string {
                    self.wlanSupport =  wlanSupport
                }
                if let blueToothSupport = self.jsonResult["data"]["blueToothSupport"].string {
                    self.blueToothSupport = blueToothSupport
                }
                if let operatingsystem = self.jsonResult["data"]["operatingSystem"].array {
                    for item in operatingsystem {
                        self.operatingSystem.append(item)
                    }
                }
                if let radioInterface = self.jsonResult["data"]["radioInterface"].array {
                    for item in radioInterface {
                        self.radioInterface.append(item)
                    }
                }
                if let lpwan = self.jsonResult["data"]["lpwan"].string {
                    self.lpwan = lpwan
                }
                if let deviceCertifybody = self.jsonResult["data"]["deviceCertifybody"].array {
                    for item in deviceCertifybody {
                        self.deviceCertifybody.append(item)
                    }
                }
                if let manufacturer = self.jsonResult["data"]["manufacturer"].string {
                    self.manufacturer = manufacturer
                }
                if let tacApprovedDate = self.jsonResult["data"]["tacApprovedDate"].string {
                    self.tacApprovedDate = tacApprovedDate
                }
                if let gsmaApprovedTac = self.jsonResult["data"]["gsmaApprovedTac"].string {
                    self.gsmaApprovedTac = gsmaApprovedTac
                    
                }
                completionHandler(self.statusCode,nil,self.deviceId,self.brandName,self.modelName,self.internalModelName,self.marketingName,self.equipmentType,self.simSupport,self.nfcSupport,self.wlanSupport,self.blueToothSupport,self.operatingSystem,self.radioInterface,self.lpwan,self.deviceCertifybody,self.manufacturer,self.tacApprovedDate,self.gsmaApprovedTac)
            }
            if (status == 401)
            {
                completionHandler(self.statusCode,nil,self.deviceId,self.brandName,self.modelName,self.internalModelName,self.marketingName,self.equipmentType,self.simSupport,self.nfcSupport,self.wlanSupport,self.blueToothSupport,self.operatingSystem,self.radioInterface,self.lpwan,self.deviceCertifybody,self.manufacturer,self.tacApprovedDate,self.gsmaApprovedTac)
            }
                
            else{
                completionHandler(self.statusCode,nil,self.deviceId,self.brandName,self.modelName,self.internalModelName,self.marketingName,self.equipmentType,self.simSupport,self.nfcSupport,self.wlanSupport,self.blueToothSupport,self.operatingSystem,self.radioInterface,self.lpwan,self.deviceCertifybody,self.manufacturer,self.tacApprovedDate,self.gsmaApprovedTac)
            }
        }
    }
}
