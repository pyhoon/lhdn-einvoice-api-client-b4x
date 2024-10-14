# LHDN e-Invoice API Client (B4X)
Version: 1.06\
Author: Aeric Poon

### Overview
This is a B4X project designed to interact with the LHDN e-Invoice API, enabling users to perform various API calls such as logging in as a taxpayer system and submitting documents in XML and JSON format. The project uses B4XPages to make it simple to build cross platform apps.

### Prerequisites
- **B4J**: To build Desktop app (Windows/Linux/Mac), you need to install [B4J](https://www.b4x.com/b4j.html) (free) on your Windows system.
- **B4A**: To build Android app (for smartphone/tablet), you need to install [B4A](https://www.b4x.com/b4a.html) (free) on your Windows system.
- **B4i**: To build iOS app (for iPhone/iPad), you need to install [B4i](https://www.b4x.com/b4i.html) on your Windows system. You need to [purchase a license](https://www.b4x.com/store.html).
- **Java JDK**: The IDEs requires Java [JDK 11](https://www.b4x.com/b4j/files/java/jdk-11.0.1.zip)/[JDK 14](https://www.b4x.com/b4j/files/java/jdk-14.0.1.zip)/[JDK 19](https://www.b4x.com/b4j/files/jdk-19.0.2.zip) installed.
- **Apple Developer account**: To build iOS app, you need active [Apple Developer account](https://developer.apple.com/account/) to create provisional profile and certificate.
- **Mac + Xcode**: You need a Mac or MacBook with supported version of Xcode installed to build the iOS app. You need an iPhone or iPad. You can also use simulator from Xcode.
- **Hosted Builder**: If you don't have a Mac, you can use the [cloud service](https://www.b4x.com/store.html) to build your iOS app on Windows. You need an iPhone or iPad. You cannot use a simulator.

### Installation and Setup
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/pyhoon/lhdn-einvoice-api-client-b4x.git
   ```
   Alternatively, you can download the ZIP file and extract it to your desired location.
   
3. **Install B4J/B4A/B4i**:
   - Download and install [B4J](https://www.b4x.com/b4j.html) / [B4A](https://www.b4x.com/b4a.html) / [B4i](https://www.b4x.com/b4i.html) by following the instructions provided on the website.
   - If you encounter any issues during installation, you can get support from the [B4X developer community forum](https://www.b4x.com/android/forum/).
   - For B4A, you need to install `B4A-Bridge` on an Android device for debugging. You can also use an Android Virtual Device (emulator).
   - For B4i, you need to install `B4i-Bridge` on an iOS device for debugging. Make sure you have specify the filenames for `#CertificateFile` and `#ProvisionFile` downloaded from Apple Developer website.

4. **Additional libraries**
   - This project requires an external [Encryption](https://www.b4x.com/android/forum/attachments/encryption1-1-zip.6666/) library
   - Download the zip file and unzip the content to B4A/B4J or B4X directory inside the folder you have configured in the IDE menu Tools > Configure Paths. 
   - Refresh the Libraries Manager tab
  
### Configure the Project
1. Navigate to `Shared Files` folder and open `config.properties` file in a text editor.
2. Enter your registered ERP `clientId` and `clientSecret` in the `config.properties` file and save it. These credentials are required to generate an access token to make API calls.
#### **Important: Do not distribute your app with production Client Id and Secret!**
- This app is use for the purpose of quick testing only.
- Do not publish the final binary app to the public.

### Open the Project
1. Double click the file `lhdn-einvoice-api-client-b4x.b4j` for B4J or `lhdn-einvoice-api-client-b4x.b4a` for B4A or `lhdn-einvoice-api-client-b4x.b4i` for B4i to open the project.
2. Click the `B4XMainPage` module (if not already open) and locate the following section:
```B4X
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region
```
3. Press and hold Ctrl key on keyboard and mouse click on the link: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True\
This will copy the files from `Shared Files` folder to your B4J/B4A/B4i `Files` folder.
4. Click the **Run** button (play button).
5. Wait for the compilation and the application interface will launch.
6. For Android, you need to click install from the device. 

### Running the Application
1. Select an API from the dropdown list or combobox (e.g. "Login as Taxpayer System").
2. Click the green "SUBMIT" button to make the API call.
3. After getting the `access token`, you can proceed to call other APIs.
4. Stop the process by clicking on the stop button on the IDE.
5. Make changes to any parameters in the code and make further testing. e.g provide valid TIN or UUID values.
6. The subs you need to focus are `B4XComboBox1_SelectedIndexChanged` and `BtnSubmit_Click`.
7. You may also want to replace the `1.x-Invoice-Sample.xml` or `1.x-Invoice-Sample.json` files with your copy.
8. By default, the IDE is using `Default` build configuration to make API calls to LHDN Sandbox environment.
9. To make API calls to LHDN Production environment, you need to specify the correct credentials in config.properties file. In the IDE, select `Production` from the build configuration dropdown list (next to Debug dropdown list) which is selected as `Default` by default.
10. This is same for all platforms (B4J, B4A and B4i).

### Troubleshooting

1. If you see the following warning in the Logs:
   ```
   File 'xxx.xxx' is missing from the Files tab (warning #17)
   ```
   Press Ctrl + click to sync: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True

2. If you see the following warning in the Logs:
   ```
   File 'xxx.xxx' in Files folder was not added to the Files tab.
   You should either delete it or add it to the project.
   You can choose Tools - Clean unused files. (warning #14)
   ```
   Go to Files Manager tab and click the 'Sync' button

3. Compilation error in B4J:\
   Make sure you are using Java JDK listed on the installation website.\
   Otherwise, it may be missing JavaFX support and the application will not run.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
