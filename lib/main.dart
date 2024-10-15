import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import local notifications
import 'package:imagined/NotificationService.dart';
import 'package:timezone/data/latest.dart' as tz; // Import timezone data
import 'OnboardingScreen.dart';
import 'MainScreen.dart'; // Import the MainScreen
import 'StorageService.dart'; // Import the StorageService
 import 'package:timezone/timezone.dart' as tz;
// Initialize the FlutterLocalNotificationsPlugin
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

//  handle in terminated state
  var initialNotification =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(Duration(seconds: 1), () {
      // print(event);
      navigatorKey.currentState!.pushNamed('/WeightListScreen',
          arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(MyApp());
}
 
 
void displayCurrentTimeInTimezone() {
  final now = tz.TZDateTime.now(tz.local);
  debugPrint('Current time in local timezone: $now');

}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker App',
      theme: ThemeData(
        fontFamily: 'Poppins', // Set Poppins as the default font
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Poppins'),
          bodyText2: TextStyle(fontFamily: 'Poppins'),
          button: TextStyle(fontFamily: 'Poppins'),
          headline6: TextStyle(fontFamily: 'Poppins'),
        ),
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: StorageService.userExists(), // Check if user exists
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading, show a splash screen or a loading indicator
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // Handle any error that occurs
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            // Check if user data exists
            if (snapshot.data == true) {
              return MainScreen(); // If user exists, go to MainScreen
            } else {
              return OnboardingScreen(); // If user does not exist, go to OnboardingScreen
            }
          }
        },
      ),
      routes: {
        '/WeightListScreen': (context) => MainScreen(),
      },
    );
  }

 
}
