# Notes-Clone-Application ⚙️

The Note App is a clone of Apple's Note application, developed using Swift and Xcode. It allows users to create, delete, search, and format notes. The application follows the MVVM (Model-View-ViewModel) design pattern for a clean and maintainable architecture. CoreData is used to persist the created and deleted notes.

## Features

- Create a new note with title and content.
- Delete an existing note.
- Search for existing notes based on title or content.
- Format the text in a note to be bold, italic, or underline.
- Uses CoreData for persistent storage of notes.
- Follows the MVVM design pattern for a structured and scalable architecture.

## Screenshots

## Requirements

- iOS 15.0+📲
- Xcode 14.0+
- Swift 5.0+

## Installation

1. [Clone or download](https://github.com/venkinyamagoudar/Notes-Clone-Application). the Note App repository to your local machine.

2. Open the project in Xcode.

3. Build and run the project on the iOS Simulator or a physical device.

## Usage

1. Launch the Note App on your iOS device or simulator.

2. The app will display a list of existing notes, if any.

3. To create a new note, tap on the "+" button.

4. Enter a title and content for the note in the provided fields.

5. To delete a note, swipe left on the note in the list and tap the "Delete" button.

6. To search for a note, use the search bar at the top of the screen. Enter keywords related to the note's title or content.

7. To format the text in a note, select the desired text and use the formatting options available (bold, italic, underline).

8. All notes and changes are automatically saved and persisted using CoreData.

## Architecture

The Note App follows the MVVM (Model-View-ViewModel) design pattern for a structured and scalable architecture. Here's a brief overview of each component:

- **Model**: Contains the data structures and logic for notes, including the title, content, and formatting information.
- **View**: Handles the user interface and displays the notes to the user. Provides input fields for creating and editing notes.
- **ViewModel**: Acts as a mediator between the Model and View, providing data and methods for manipulating notes. Handles CoreData interactions for data persistence.

## Contributing

Contributions to the Note App are welcome! If you would like to contribute, please follow these guidelines:

1. Fork the repository and clone it to your local machine.

2. Create a new branch for your feature or bug fix.

3. Implement your changes, following the existing code style and architecture.

4. Write appropriate tests for your code changes.

5. Commit your changes and push them to your forked repository.

6. Open a pull request, providing a detailed description of your changes and any relevant information.
