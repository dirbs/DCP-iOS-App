//
//  LoginWorker.swift
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
import AVFoundation
import SwiftyJSON
class LoginWorker{
    // get base_Url in constant File
    var baseUrl = Constants.Base_Url
    var jsonResult: JSON!
    var liscenceData = [JSON]()
    var url = ""
    // MARK: Make getLoginResponse Method
    func getLoginResponse(email: String, password: String, completionHandler: @escaping (String?, String?, String? ,Int?,String?,Int?,Int?) -> Void) {
        let parameters: Parameters = [ "email": email,
                                       "password": password]
        let headers = [ "Content-Type": "application/json",
                        "Accept":"application/json"
        ]
        let url =  baseUrl+"api/login"
        Alamofire.request(url, method:.post, parameters:parameters, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            let status = response.response?.statusCode
            if (status == 200){
                let data = response.data
                self.jsonResult = JSON(data!)
                var user_Name = ""
                var first_Name = ""
                var last_Name = ""
                var access_token = ""
                var roles = ""
                var agreed = ""
                let user_id = ""
                //Parse the json response
                if let items = self.jsonResult["roles"].array {
                    for item in items {
                        if let slug = item["slug"].string {
                            roles = slug
                        }
                    }
                }
                if let get_access_token = self.jsonResult["meta"]["token"].string {
                    access_token = get_access_token
                }
                if let get_active_Liscence = self.jsonResult["current_active_license"]["user_name"].string {
                    var  get_active_Liscence = get_active_Liscence
                }
                //save value in shareed Preferncess
                let userDefaults = UserDefaults.standard
                userDefaults.set(access_token , forKey: "AccessToken")
                if let agreedValue = self.jsonResult["data"]["agreement"].string {
                    agreed  = agreedValue
                }
                if let Liscence = self.jsonResult["licenses"].array {
                    for item in Liscence {
                        self.liscenceData = [item]
                    }
                    var user_id = 0
                    var get_user_id = 0
                    var   get_active_id = 0
                    if(self.liscenceData.count > 0){
                        get_user_id = self.liscenceData[0]["id"].int!
                        get_active_id   = self.jsonResult["current_active_license"]["id"].int!
                    }
                    if let User_id = self.jsonResult["data"]["id"].int {
                        user_id = User_id
                        userDefaults.set(get_user_id, forKey: "User_id")
                    }
                    if let first_name  = self.jsonResult["data"]["first_name"].string {
                        first_Name = first_name
                    }
                    if let last_name  = self.jsonResult["data"]["last_name"].string {
                        last_Name = last_name
                    }
                    user_Name = first_Name + " " + last_Name
                    userDefaults.set(user_Name, forKey: "user_Name")
                    completionHandler(access_token,roles,nil,status,agreed,get_user_id,get_active_id)
                }
            }
            if (status == 401){
                completionHandler(nil,nil,nil,status,nil,0,0)
            }
            else{
                completionHandler(nil,nil,nil,status,nil,0,0)
                print("error: "+response.error.debugDescription)
            }
        }
    }
    // MARK: Make setForgotPassword Method
    func setForgetPassword(email: String, acess_token:String, completionHandler: @escaping (Int? ) -> Void) {
        let parameters: Parameters = [ "email": email]
        url =  baseUrl+"api/recover"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding(), headers:  nil).responseJSON { (test) in
            let status = test.response?.statusCode
            if (status == 200){
                print(self.jsonResult)
                completionHandler(status)
            }
            if (status == 401){
                completionHandler(status)
            }
                
            else{
                completionHandler(status)
                print("error: "+test.error.debugDescription)
            }
        }
    }
}

