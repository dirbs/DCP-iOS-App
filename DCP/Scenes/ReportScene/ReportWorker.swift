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
class ReportWorker
{
    var baseUrl = Constants.Base_Url
    var jsonResult: JSON!
    // MARK: Make makeMultipartRequest Method
    func makeMultipartRequest(arrayOfImageToUpload:[UIImage],access_token:String ,language: String,imei_number:String,brand_name:String,model_name:String,store_name :String,address:String,description:String,
       completionHandler: @escaping (Int?,Bool, String?) -> Void) {
        let headers = ["Authorization": "Bearer \(access_token)",
            "Content-Type": "application/json",
            "Accept":"application/json",
            "x-localization": language
            
        ]
        let parameters: Parameters = [ "imei_number": imei_number,
                                       "brand_name": brand_name,
                                       "model_name": model_name,
                                       "store_name": store_name,
                                       "address": address,
                                       "description": description,
                                       ]
    
        let url =  baseUrl+"api/counterfiet"
        Alamofire.upload(multipartFormData: { multipartFormData in
            let count = arrayOfImageToUpload.count
            for i in 0..<count{
          multipartFormData.append(arrayOfImageToUpload[i].jpegData(compressionQuality: 0.7)!, withName: "counterImage[\(i)]", fileName: "photo\(i).jpeg" , mimeType: "image/jpeg")
            }
            for (key, value) in parameters {
                if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                }
                
            }
        }, to: url,method: .post,
           headers:headers,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let status = response.response?.statusCode
                    if (status == 200)
                    {
                        let data = response.data
                        self.jsonResult = JSON(data!)
                        print(self.jsonResult)
                        var success = false
                        var message = ""
                        if self.jsonResult.count > 0
                        {
                            success  = self.jsonResult["success"].bool!
                            message  = self.jsonResult["message"].string!
                        }
                        completionHandler(status,success,message)
                    }
                    if (status == 401)
                    {
                        completionHandler(status,false,nil)
                    }
                        
                    else{
                        completionHandler(status,false,nil)
                        print("error: "+response.error.debugDescription)
                    }
                    
                }
            case .failure( _):
                completionHandler(0,false,nil)
            }
            
        })
    }
}
