QUARCS_APP Compilation Instructions (README)

Introduction:

QUARCS_APP is the mobile client of the Q.U.A.R.C.S software package. This APP has two function
1. Includes the QT web browser for the QUARCS user control interface. This interface will show the Vue front end of the QUARCS.
2. IP address detector to get the IP address of the server. The IP address detector will monitor the broadcast TCP/IP packet on the local area network.  This packet includes the identity code and IP address of the QUARCS server. There is two basic connection modes between the server and the client. One is the AP direction connection mode. The server is AP hot spot. Another is the LAN mode, both the server and the client are connected under a router.


Project Version Information:
Qt: 5.12.8
JDK: 1.8.0_321
Android Studio: 2021.1.1.22 for Linux
Android NDK: r21e for Linux x86-64

Compilation Steps:
1、Configure Android Development Environment:
Before compiling the Qt project, ensure that you have configured the Android development environment.  You can refer to the following link for configuration details：https://decovar.dev/blog/2017/12/28/qt-for-android/

2、Open Qt Project：
Use Qt Creator or your preferred Qt integrated development environment to open your project.

3、Compile the Project:
In Qt Creator, select the project file, then click the "Build" button.  Ensure that the project compiles successfully, and check the console output for any possible errors or warnings.

4、Generate Final Files:
After successful compilation, you will find the generated final files in the project directory or build directory.

5、Deploy to Android Device:
Deploy the generated application file (APK) to your Android device or emulator for testing.

Important Notes
Ensure that your Android device or emulator is in developer mode and USB debugging is enabled.
In Android Studio, you can use the device manager to check and set developer options for the device.

Feedback and Support
If you encounter any issues during the compilation process or have any questions, feel free to raise them or submit issues on GitHub.  We will do our best to provide support.

Thank you for using our APP!
