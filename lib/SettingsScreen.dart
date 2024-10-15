import 'package:flutter/material.dart';
import 'package:imagined/NotificationService.dart';
import 'package:imagined/StorageService.dart';
import 'package:lottie/lottie.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay _notificationTime = TimeOfDay.now();
  String? _gender = 'Male'; // Default value

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationTime = await StorageService.getNotificationTime() ?? TimeOfDay.now();
    _gender = await StorageService.getGender(); // Fetch gender from storage
    setState(() {}); // Update the UI after fetching values
  }

  DateTime timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1584A3),
      ),
      body: Column(
        children: [
          // Top section with animation
          Container(
            height: MediaQuery.of(context).size.height * 0.4, // Top 30% of screen
            decoration: BoxDecoration(
              color: Color(0xFF1584A3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    _gender == 'Male' ? 'assets/animations/male2.json' : 'assets/animations/female.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Be Ready',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Time to lose weight!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Stylish ListTile for notification time
          GestureDetector(
            onTap: () => _changeNotificationTime(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Color(0xFF1584A3),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_active, color: Colors.white, size: 30),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Change Notification Time",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        _notificationTime.format(context),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Stylish Reset Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () => StorageService.resetNotificationAndWeightData(),
              icon: Icon(Icons.restore, color: Colors.white),
              label: Text(
                "Reset Data",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1584A3),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                shadowColor: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeNotificationTime(BuildContext context) async {

   final TimeOfDay? picked = await showTimePicker(
  context: context,
  initialTime: _notificationTime,
  builder: (BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: Color(0xFF1584A3), // Change the primary color (for the selected time)
         // Change the accent color
        colorScheme: ColorScheme.light(primary: Color(0xFF1584A3)), // Change the color scheme
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Change button text color
      ),
      child: child ?? SizedBox.shrink(), // Provide a child or a fallback
    );
  },
);
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
      await StorageService.saveNotificationTime(_notificationTime);
      DateTime scheduledTime = timeOfDayToDateTime(picked);
      debugPrint('Notification Scheduled for $scheduledTime');
             LocalNotifications.showScheduleNotification(
            title: 'Scheduled Notification',
            body: 'Loss weight',
            payload: scheduledTime.toString(),
            scheduledTime: scheduledTime);
    }
  }
}
