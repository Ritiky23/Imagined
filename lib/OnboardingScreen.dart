import 'package:flutter/material.dart';
import 'package:imagined/NotificationService.dart';
import 'package:imagined/StorageService.dart';
import 'MainScreen.dart'; // Import your MainScreen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1584A3), // Set background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center horizontally within the row
                children: [
                  Text(
                    "What's your ",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    "GOOD ",
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                  Text(
                    "Name?",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between text and TextField
            TextField(
              controller: _nameController,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                labelStyle: TextStyle(color: Colors.white), // Change label text color to white
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Change border color to white
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Change border color to white
                ),
              ),
              style: TextStyle(color: Colors.white), // Change text color to white
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  // Navigate to the gender selection screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenderSelectionScreen(
                        name: _nameController.text,
                      ),
                    ),
                  );
                } else {
                  // Show error if the name is not entered
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter your name.')),
                  );
                }
              },
              child: Text(
                "Next",
                style: TextStyle(color: Color(0xFF1584A3)), // Change button text color to blue
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Set the button background color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderSelectionScreen extends StatefulWidget {
  final String name;

  GenderSelectionScreen({required this.name});

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1584A3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select your Gender",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _selectGender('Female'),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _selectedGender == 'Female' ? Colors.pink[100] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.female,
                          size: 50,
                          color: Colors.pink,
                        ),
                        Text(
                          'Female',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _selectGender('Male'),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _selectedGender == 'Male' ? Colors.blue[100] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          size: 50,
                          color: Colors.blue,
                        ),
                        Text(
                          'Male',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
           _isLoading
    ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
    : SizedBox.shrink(), // Return an empty widget when not loading


                
          ],
        ),
      ),
    );
  }

  void _selectGender(String? value) {
    setState(() {
      _selectedGender = value;
      _isLoading = true; // Set loading state to true
    });

    // Simulate a delay of 3 seconds for loading
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false; // Stop loading after 3 seconds
        _showCustomTimePicker(context); // Show custom time picker after delay
      });
    });
  }

  Future<void> _showCustomTimePicker(BuildContext context) async {
    TimeOfDay _selectedTime = TimeOfDay.now();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Time for Weight Notification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  width: double.maxFinite, // Set width to maximum
                  child: Column(
                    children: [
                      Text('Choose a time:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1584A3)), // Set the background color
  ),
  onPressed: () async {
final TimeOfDay? picked = await showTimePicker(
  context: context,
  initialTime: _selectedTime,
  builder: (BuildContext context, Widget? child) {
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor: Color(0xFF1584A3), // Change the primary color for the selected time
        colorScheme: ColorScheme.light(primary: Color(0xFF1584A3)), // Change the accent color
        dialogBackgroundColor: Color(0xFF1584A3), // Set the background color of the dialog to blue
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // Change button text color
      ),
      child: child ?? SizedBox.shrink(), // Provide a child or a fallback
    );
  },
);


    if (picked != null) {
      // If a time is selected, save the data
      await _saveOnboardingData(context, picked);
    } else {
      // If canceled, navigate back to GenderSelectionScreen
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GenderSelectionScreen(name: widget.name)),
      );
    }
  },
  child: Text(
    'Select Time',
    style: TextStyle(color: Colors.white), // Set the text color to white
  ),
)

                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel' ,style: TextStyle(color: Color(0xFF1584A3)),),
            ),
          ],
        );
      },
    );
  }
 DateTime timeOfDayToDateTime(TimeOfDay time) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

  Future<void> _saveOnboardingData(BuildContext context, TimeOfDay picked) async {
    await StorageService.saveName(widget.name);
    await StorageService.saveGender(_selectedGender!);
    await StorageService.saveNotificationTime(picked);
 DateTime scheduledTime = timeOfDayToDateTime(picked);
    LocalNotifications.showScheduleNotification(
            title: 'Imagined',
            body: 'Time to Measure Weight!',
            payload: scheduledTime.toString(),
            scheduledTime: scheduledTime);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Start a future to navigate to the main screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to MainScreen
      );
    });

    return Scaffold(
      backgroundColor: Color(0xFF1584A3), // Set background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
            SizedBox(height: 20),
            Text('Lets Go!', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
