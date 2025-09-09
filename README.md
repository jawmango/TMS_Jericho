# TMS_Jericho
A simple transaction management system of a Flask RESTful API for data operations and a Flutter Web Application for displaying and adding transactions.

# Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [API Docs](#api-docs)
- [Testing](#testing)

## Prerequisites
The following software should be installed before setting up this project:

### Backend (Flask API):
- Python 3.8 or higher - [Download Python](https://www.python.org/downloads/)

### Frontend (Flutter APP):
- Flutter SDK 3.10 or higher - Install Flutter for [Windows](https://docs.flutter.dev/get-started/install/windows/web), [Mac](https://docs.flutter.dev/get-started/install/macos/web), or [Linux](https://docs.flutter.dev/get-started/install/linux/web)
- Google Chrome (For testing Flutter Application)

### Tools:
- Git - [Download Git](https://git-scm.com/downloads)
- VS Code (Code Editing)

### Vertify Installation:
Run the following commands on terminal to verify installations:
```
python3 --version

flutter --version

git --version
```
## Installation
### 1. Clone Repository
```
git clone https://github.com/jawmango/TMS_Jericho.git
cd TMS_Jericho
```
### 2. Backend Setup (Flask API)
#### Step 1: Navigate to the Backend Directory ('api' Folder)
```
cd api
```
#### Step 2: Create Virtual Environment
For windows:
```
python -m venv .venv
.venv\Scripts\activate
```
For macOS\Linux:
```
python3 -m venv .venv
source .venv/bin/activate
```
#### Step 3: Install Python Dependencies
```
pip install -r requirements.txt
```
### 3. Frontend Setup (Flutter)
#### Step 1: Navigate to the Frontend Directory ('tms' folder)
```
cd ../tms
```
If in the root directory:
```
cd tms
```
#### Step 2: Install flutter dependencies
```
flutter pub get
```
#### Step 3: Verify Flutter Setup
```
flutter doctor
```
## Configuration
### 1. Environment Variables (Optional)
Create a `.env` file in the `api` directory

```
FLASK_ENV=development
FLASK_DEBUG=True
API_HOST=0.0.0.0
API_PORT=5000
CSV_FILE=transactions.csv
```
### 2. CORS Configuration
The Flask app is configured to allow cross-origin requests from the Flutter app. No additional configuration needed.

## Running the Application
### 1. Start the Backend Server
#### Step 1: Navigate to Backend Directory ('api' Folder)
```
cd ../api
```
If in root directory:
```
cd api
```
#### Step 2: Activate Virtual Environment (once created)
For windows:
```
.venv\Scripts\activate
```
For macOS\Linux:
```
source .venv/bin/activate
```
#### Step 3: Start Flask Server
```
flask --app api --debug run
```
Output is similar to:
```
 * Serving Flask app 'api'
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on http://127.0.0.1:5000
Press CTRL+C to quit
 * Restarting with stat
 * Debugger is active!
```
### 2. Start the Frontend Application
Open a new terminal window/tab and:
#### Step 1: Navigate to the Frontend Directory ('tms' folder)
```
cd tms
```
#### Step 2: Run Flutter App
```
flutter run -d chrome
```
### 3. Access the application
Open http://localhost:port (port will be shown in terminal)
## API Docs
### Base URL
```
https://localhost:5000
```
### Endpoints
#### 1. Retrieve All Transactions
```
GET /transactions
```
#### Sample Response:
```
[
  {
    "Transaction Date": "2025-03-01",
    "Account Number": "7289-3445-1121",
    "Account Holder Name": "Maria Johnson",
    "Amount": 150.0,
    "Status": "Settled"
  },
  {
    "Transaction Date": "2025-03-02",
    "Account Number": "1122-3456-7890",
    "Account Holder Name": "John Smith",
    "Amount": 75.5,
    "Status": "Pending"
  },
]
```
#### 2. Add New Transaction
```
POST /transactions
Content-Type: application/json
```
#### Sample Request Body:
```
{
  "Transaction Date": "2025-03-01",
  "Account Number": "7289-3445-1121",
  "Account Holder Name": "Maria Johnson",
  "Amount": 150.0,
  "Status": "Settled"
},
```
#### Sample Success Response (201):
```
{
  "Transaction Date": "2025-03-01",
  "Account Number": "7289-3445-1121",
  "Account Holder Name": "Maria Johnson",
  "Amount": 150.0,
  "Status": "Settled"
},
```
#### Sample Error Response (400):
```
{'error': 'Invalid date format.'}
```
### Error Codes
- 200 - Success
- 201 - Successful Creation
- 400 - Validation Error
- 404 - Endpoint not Found
- 500 - Internal server error

### Testing
#### API Testing
#### Testing with Postman
1. Install [Postman](https://www.postman.com/downloads/)
2. Create an account and login
3. Create new HTTP Request (Click + as alternative)
4. Select your HTTP method (GET or POST)

#### For GET request:
1. Input API URL in the address bar (typically http://127.0.0.1:5000)
2. Click 'Send' button beside address bar
3. View response body at the bottom of application

#### For POST request:
1. Input API URL in the address bar (typically http://127.0.0.1:5000)
2. Select 'Body' tab on tab bar below address bar
3. Select raw and JSON for the dropdown lists located below tab bar
4. Input JSON data on input field below dropdown lists
5. Click 'Send' button beside address bar
6. View response body at the bottom of application

### Frontend Testing
### Flutter Test
#### Run Unit Tests:
```
cd tms
flutter test
```
For VS Code:
1. Click on Test icon button (Looks like a Flask) located at the side navigation bar
2. Select the play button icon below filter to run tests
3. Test results are shown next to the side navigation bar

#### Unit Test Structure:
#### Unit Test Files Location
- are located in `tms/test`
- named with _test.dart (e.g widget_test.dart)
#### Unit Test Functions:
1. group(): Test Group to logically group related tests together
   - Helps organize tests, especially when there are multiple tests for a single unit
2. test(): The actual test case
   - Contains logic for singlel test
3. expect(): The assertion
   - Verifies that the code behaves as expected
   - Compares actual result with expected result
#### Sample Code Structure:
```
void main(){
  group('Name of Test Group', () {
    test('should achieve test result', () {
      //logic
      
      expect(actualResult, expectedResult);
    });
}
```
- `widget_testing.dart` includes model test and status color assignment test

### Manual Testing:
1. Start Flask Server(Terminal 1)
```
flask --app api --debug run
```
2. Start Flutter App(Terminal 2)
```
flutter run -d chrome
```
3. Test Functionality

#### Table displaying all transactions
1. Once app is opened, there will be a table consisting of the API data. Check if data is the same with API
2. By default, 10 data rows will be displayed. Use the pagination bar to test content presentation
3. Click on the tabs on tab bar below table header to test content filtering

#### Submit Data to API endpoint
1. Click Add Transaction Button at Bottom Right
2. Select Date and Type in Input Fields to test Form functionality
3. Click Submit Button
4. Try invalid inputs to test form validation
5. After successful submission, check if table updates

## Author

**[Jericho James Obiedo](https://github.com/jawmango)**  
Creator and maintainer of this project.



