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
import SwiftyJSON

class HistoryWorker
{
    var baseUrl = Constants.Base_Url
    var jsonResult: JSON!
    // MARK: Make  getHistory Method
    func getHistory(access_token:String ,language: String,page_No:String,
                              completionHandler: @escaping ( Int?,[String?],[String?],[String?],[String?],[String?],[String?], Int?) -> Void) {
        let headers = ["Authorization": "Bearer \(access_token)",
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept":"application/json",
            "x-localization": language
            
        ]
        let parameters: Parameters = [ "page":page_No]
        let  url =  baseUrl+"api/datatable/my-activity?page=\(page_No)"
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) -> Void in
            let status = response.response?.statusCode
            if (status == 200)
            {
                let data = response.data
                self.jsonResult = JSON(data!)
                var id = [String]()
                var date = [String]()
                var result1 = [String]()
                var user_device = [String]()
                var user_name = [String]()
                var visitor_ip = [String]()
                var last_Page = 0
                if let data = self.jsonResult["activity"]["data"].array {
                    for item in data {
                        if let result = item["imei_number"].string {
                           id.append(result)
                        }
                        if let result = item["created_at"].string {
                            date.append(result)
                        }
                        if let result = item["user_name"].string {
                            user_name.append(result)
                        }
                        if let result = item["result"].string {
                          result1.append(result)
                        }
                        
                        if let result = item["user_device"].string {
                            user_device.append(result)
                        }
                        if let result = item["visitor_ip"].string {
                            visitor_ip.append(result)
                        }   
                    }
                }
                if let Last_page = self.jsonResult["activity"]["last_page"].int {
                    last_Page = Last_page
                    }
           completionHandler(status,id,date,user_name,result1,user_device,visitor_ip,last_Page)
            }
            else if(status == 401)
            {
                completionHandler(status,[],[],[],[],[], [],0)
            }
            else
            {
                completionHandler(status,[],[],[],[],[], [],0)
            }
        }
    }
    // MARK: Make  getSearchHistory Method
    func getSearchtHistory(access_token:String ,language: String,page_No:String,imei_number: String,
                    completionHandler: @escaping ( Int?,[String?],[String?],[String?],[String?],[String?],[String?],Int?) -> Void) {
        let headers = ["Authorization": "Bearer \(access_token)",
            "Content-Type": "application/json",
            "Accept":"application/json",
            "x-localization": language
        ]
        let parameters1: Parameters = [ "to_search":imei_number]
        let  url =  baseUrl+"api/search_users_activity?page=\(page_No)"
        Alamofire.request(url, method:.post, parameters:parameters1, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
            let status = response.response?.statusCode
            if (status == 200)
            {
                let data = response.data
                self.jsonResult = JSON(data!)
                var id = [String]()
                var date = [String]()
                var result1 = [String]()
                var user_device = [String]()
                var user_name = [String]()
                var visitor_ip = [String]()
                var last_Page = 0
                if let data = self.jsonResult["activity"]["data"].array {
                    for item in data {
                        if let result = item["imei_number"].string {
                            id.append(result)
                        }
                        if let result = item["created_at"].string {
                            date.append(result)
                        }
                        if let result = item["user_name"].string {
                            user_name.append(result)
                        }
                        if let result = item["result"].string {
                            result1.append(result)
                        }
                        if let result = item["user_device"].string {
                            user_device.append(result)
                        }
                        if let result = item["visitor_ip"].string {
                            visitor_ip.append(result)
                            
                        }
                    }
                }
                if let Last_page = self.jsonResult["activity"]["last_page"].int {
                    last_Page = Last_page
                }
                
    completionHandler(status,id,date,user_name,result1,user_device,visitor_ip,last_Page)
            }
            else if(status == 401)
            {
                completionHandler(status,[],[],[],[],[], [],0)
            }
            else
            {
                completionHandler(status,[],[],[],[],[], [],0)
            }
        }   
    }
}
