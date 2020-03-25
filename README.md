![Image of DIRBS Logo](https://avatars0.githubusercontent.com/u/42587891?s=100&v=4)


# DCP-iOS-App
## License
Copyright (c) 2019 Qualcomm Technologies, Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted (subject to the limitations in the disclaimer below) provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Qualcomm Technologies, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
* The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment is required by displaying the trademark/log as per the details provided here: https://www.qualcomm.com/documents/dirbs-logo-and-brand-guidelines
* Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
* This notice may not be removed or altered from any source distribution.

NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Features
- Enter or Scan IMEI
- Verify the integrity of TAC from GSMA database
- Report counterfiet devices
- View search history
- Send feedback to administrator
- Mutlilingual, currently supports English and Vietnamese

## System Requirements
### Software Requirements
Below mentioned are the software requirements.
-	Xcode 9.4.1
-	Minimum iOS version 9.0
-	Mac OS 10.13.4

### Hardware Requirements
Minimum hardware requirements to run DCP app using xcode.
-	At least 8 GB of RAM
-	Processor: 2.5 GHz Intel Core i5
-	At least 20GB of disk space
-	Internet Connection

Minimum hardware requirements to test DCP app on iOS device.
-	iOS Device with Camera
-	Internet Connection


## Configuration
-	To change the logo of app go to DCP/DCP/ Accets.xcassets/AppIcon and paste logo file in this folder
-	To change app icon update all PNG files named “ic_launcher” in folders DCP/DCP/ Accets.xcassets  
-	To change DCP backend API base URL open DCP/DCP/Scenes/Constant.swift and update value of Base_Url in variable.
## Architecture
DCP iOS application is developed using clean swift architecture.
### Dependencies
DCP app utilizes some open source libraries to meet its functional requirements. The libraries used and the purpose of their usage are
-	Alamofire for making network calls.
-	MTBBarcodeScanner for scanning barcode of IME.
- SlideMenuControllerSwift for left Nevigation Drawer. 
-	Hippolyte for unit testing.
-	Image picker for selecting or taking images.

### File Structure
In DCP source code files are structured in a way that files related to a screen are placed in a folder having sub folders for scenes, view, presenter and worker calls.
