# PlayMyHit 2.0

Here's how the PlayMyHit project is being managed.

Every week there will be a set of Milestones with respective
issues created on the PlayMyHit 2.0 project. Contribuitors should refer to the Issues tab to find pending issues. You should use tags to find issues based on their priority. Try to work on issues that have a high priority first, unless you don't know how to do it. Once you work on a specific issue, make sure you create a branch with a name that closely relates to the issue you are handling. When you push to your branch, create a pull request and in the commit message make sure you add the keyword fixes and the issue number preceeded by the pound (#) symbol. This will automatically link the issue to the pull request and we can tell wether an issue has been resolved. Additionally, make sure you go to the project board when you start working on an issue and move it's corresponding ticket to the "In Progress" section. And when you complete the work and the pull request has been approved, move the ticket to the "Done" section and you're completed with that ticket. Once a month one of our staff will update the list of contributors in this readme, reflecting all contributors with a link to their GitHub accounts. If you have any questions regarding the contribution process, send an email to aldanisvigo@gmail.com.

# Project Documentation

## Design

The designs for this project are all in Figma. You can access them by clicking on this link: . If you don't have access, you can request access in Figma, we usually provide access within 24 to 48 hours. Be patient. If it's been more that that please send a message to aldanisvigo@gmail.com.

## Documentation

# Framework
We are using the Flutter Framework for this application. The main programming language is Dart.

1. Flutter Documentation: [Flutter Documentation](https://flutter.dev/learn)
2. Dart Documentation: [Dart Documentation](https://dart.dev/guides)


# Design Pattern

The main design pattern for this project is the BLoC repository pattern. All UI views have a corresponding BLoC class that is responsible for all the business logic related to that screen. The BLoC accesses data from the backend storage, authentication and firestore systems through a repository class that is passed as an input parameter to the constructor of the BLoC. The BLoC uses this instance to perform CRUD operations, upload and download files, authenticate users or access any app related data. The BLoC uses the returned data to emit a new state which causes a rebuild of the corresponding UI screen or widget. The UI can listen for BLoC emitted states using the BlocProvider class in the flutter_bloc package. That means that we must include the flutter_bloc and bloc packages in the pubspec.yaml file.

# Backend

The backend for this application is Firebase. All services are available through the following packages which need to be added to the pubspec.yaml file:

Firebase Documentation: [Firebase Documentation](https://firebase.google.com/docs)

1. firebase_core     - Required package for all other firebase services. 
2. firebase_storage  - Provides utilities for storing and retieving files 
<br/>
[Firebase Storage Documentation](https://firebase.google.com/docs/storage)
3. firebase_auth     - Provides utilities for authenticating users, account recovery and profile information 
<br/>
[Firebase Authentication Documentation](https://firebase.google.com/docs/auth)
4. cloud_firestore   - Provides access to stored data documents
<br/>
[Firestore Documentation](https://firebase.google.com/docs/firestore)


For peer to peer communication we'll be using the following packages:
<br/>
1. flutter_webrtc - [Package Docs](https://pub.dev/packages/flutter_webrtc)