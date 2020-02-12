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
protocol LoginBusinessLogic
{
  func loginRequest(request: Login.LoginResponse.Request)
    func forgotPasswordRequest(request: Login.ForgotPassword.Request)
}

protocol LoginDataStore
{
    var accessToken: String? {get set}
    var roles: String? {get set}
    var liscense: String? {get set}
}
class LoginInteractor: LoginBusinessLogic, LoginDataStore
{
   var presenter: LoginPresentationLogic?
   var worker: LoginWorker?
   var accessToken: String? = ""
   var roles: String? = ""
   var liscense: String? = ""
   var  status_code: Int = 0
  func loginRequest(request: Login.LoginResponse.Request)
  {
    worker = LoginWorker()
    worker?.getLoginResponse(email: request.email!, password: request.password!){(accessToken, roles,liscense, status_code ,agreed,user_id,active_id) in
       self.accessToken = accessToken
       self.roles = roles
       self.liscense = liscense
        let response = Login.LoginResponse.Response(accessToken: accessToken, roles: roles , liscense: liscense , status_code: status_code,agreed:agreed , user_id:user_id,active_id:active_id )
        self.presenter?.presentLogin(response: response)
  }
}
    // MARK: Make forgotPasswordrequest Method
    func forgotPasswordRequest(request: Login.ForgotPassword.Request)
    {
        worker = LoginWorker()
        worker?.setForgetPassword(email: request.email!, acess_token: request.access_token!){( status_code) in
    let response = Login.ForgotPassword.Response(status_code: status_code)
    self.presenter?.presentForgotPassword(response: response)
    }
    }
}
