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
protocol HistoryBusinessLogic{
    func doHistory(request: History.History.Request)
    func doSearchHistory(request: History.SearchHistory.Request)
}
protocol HistoryDataStore{
    //var name: String { get set }
}
class HistoryInteractor: HistoryBusinessLogic, HistoryDataStore{
    var presenter: HistoryPresentationLogic?
    var worker: HistoryWorker?
    //var name: String = ""
    // MARK: Do doHistory
    func doHistory(request: History.History.Request){
        worker = HistoryWorker()
        worker?.getHistory(access_token: request.access_Token!, language: request.language!, page_No: request.page_No!)  {(status_code,id,date,user_name,result,user_device,visitor_ip, last_Page) in
            let response = History.History.Response(status_code: status_code,id:id as! [String],date:date as! [String],result:result as! [String], user_device:user_device as! [String], user_name:user_name as! [String],visitor_ip:visitor_ip as! [String], last_Page: last_Page)
            self.presenter?.presentHistory(response: response)
        }
    }
    // MARK: Do  doSearchHistory
    func doSearchHistory(request: History.SearchHistory.Request){
        worker = HistoryWorker()
        worker?.getSearchtHistory(access_token: request.access_Token!, language: request.language!, page_No: request.page_No! ,imei_number: request.imei_number!)  {(status_code,id,date,user_name,result,user_device,visitor_ip,last_Page) in
            let response = History.SearchHistory.Response(status_code: status_code,id:id as! [String],date:date as! [String],result:result as! [String], user_device:user_device as! [String], user_name:user_name as! [String],visitor_ip:visitor_ip as! [String],last_Page: last_Page)
            self.presenter?.presentSearchHistory(response: response)
        }
    }
}
