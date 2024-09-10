# LHDN e-Invoice API Client (B4X)
Version: 1.02\
Author: Aeric Poon

### Overview
This is a B4J project designed to interact with the LHDN e-Invoice API, enabling users to perform various API calls such as logging in as a taxpayer system and submitting documents in XML and JSON format. The project uses B4XPages to make it simple to build cross platform apps.

### Prerequisites
- **B4J**: Make sure you have B4J installed on your system. You can [download B4J here](https://www.b4x.com/b4j.html).
- **Java JDK**: The project has been tested with Java 11 and 14, so ensure you have a compatible version installed.

### Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/pyhoon/lhdn-einvoice-api-client-b4x.git
   ```
   Alternatively, you can download the ZIP file and extract it to your desired location.

2. **Install B4J**:
   - Download and install B4J by following the instructions provided on the [B4J website](https://www.b4x.com/b4j.html).
   - If you encounter any issues during installation, you can get support from the [B4X developer community forum](https://www.b4x.com/android/forum/).

3. **Configure the Project**:
   - Navigate to the project directory: `lhdn-einvoice-api-client-b4x/1.0/B4J`.
   - Open the `config.properties` file in a text editor.
   - Enter your `clientId` and `clientSecret` in the `config.properties` file. These credentials are required to make API calls.

4. **Important: Comment Out ROBOCOPY Command**:
   - If you **deleted** the `Shared Files` directory, you must comment out the ROBOCOPY command to prevent build errors.
   - Open the `B4XMainPage.b4j` file and locate the following section:
     ```b4x
     #Region Shared Files
     #CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
     'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
     #End Region
     ```
   - Comment out the `#CustomBuildAction` line by adding a single quote (`'`) at the beginning:
     ```b4x
     ' #CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
     ```

5. **Run the Project**:
   - Open the `lhdn-einvoice-api-client-b4x.b4j` file in the B4J IDE.
   - Click the **Run** button (the play button in the IDE).
   - The application interface will launch.

6. **Using the Application**:
   - Select an API from the dropdown list or combobox (e.g., "Login as Taxpayer System").
   - Click the green "SUBMIT" button to make the API call.

7. **Future versions**:
   - API Version 1.1
   - B4A and B4i to support Android and iOS

### Troubleshooting

- **Error: Source Directory Not Found**:
  - If you encounter an error related to the `Shared Files` directory during the build process, ensure you've commented out the ROBOCOPY command as described above.

- **Java Version Issues**:
  - Ensure you are using Java JDK 14 or a compatible version. If you experience issues, consider upgrading or downgrading your Java installation as necessary.

### License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

```

This `README.md` should now be more focused and relevant to the project, without any unnecessary sections.
