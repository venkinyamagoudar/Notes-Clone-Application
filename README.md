# Notes-Clone-Application

<hr>
> <b> NOTE: You can download the project [here](https://github.com/venkinyamagoudar/Notes-Clone-Application). </b> <br> 

## Overview 
This application is a clone of Apples Note application and is developed using Swift and Xcode. In this application you can create a new note, you can delete an existing 
note,you can search for and existing node and you can change the text in a note to bold, itallic or underline. The notes created and deleted are persisted using the CoreData.

## How to run the project
1. Install Xcode.
2. Download the git clone.
[https://github.com/venkinyamagoudar/Notes-Clone-Application](https://github.com/venkinyamagoudar/Notes-Clone-Application).
3. Open "MyNotes.xcworkspace" in Xcode.
4. TO compile and run the app in your simulator press CMD+R run the project.
5. Press CMD+U to run all the test Cases.


If you don't see any data, please check "Simulator" -> "Debug" -> "Location" to change the location.

The dataset used to develop and test the script can be found [here](/weather_data_denver.csv). This data has <b>145k</b> rows and <b>11</b> features. <br>

Here is a snapshot of the same data to understand what the input data should look like.

![image](https://user-images.githubusercontent.com/72503778/205184189-a46eca1e-3584-4027-b91c-63d7e24fee24.png)

<h3>Format your data in the following manner: </h3>

1) The first column has to be DateTime. 

2) If date and time are together in one column, the format should be `"dd-mm-YY hh:mm:ss"`

4) The time should be in 24-hour format

5) The dependent variable (if any) should be the last column of the dataset and should have the name `"output"` or `"target"`.

6) The data should be continuous (should not miss any dates).

## Loading data

<h3>There are two ways to load data into the model: </h3>

1) <b> Directly call CSV file using `pandas`: </b>

- Add the intended CSV file to the project directory
- On line `438` of the code, change the string variable `data_name` and set it to the name of the CSV file intended
- Run the code and look for `"Data Successfully Added!"` message in the terminal.
> In this case, all rows of the dataset will be called. To control the number of rows fetched, use the second method to load data.

2) <b> Fetch data from SQL Database: </b>
