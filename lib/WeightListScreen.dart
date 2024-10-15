import 'package:flutter/material.dart';
import 'package:imagined/StorageService.dart';
import 'package:intl/intl.dart';
import 'weight_service.dart'; // Import the file containing WeightEntry and WeightService
import 'package:lottie/lottie.dart';

class WeightListScreen extends StatefulWidget {
  @override
  _WeightListScreenState createState() => _WeightListScreenState();
}

class _WeightListScreenState extends State<WeightListScreen> {
  List<WeightEntry> _weightEntries = [];
  String? _gender; // Variable to store the gender

  @override
  void initState() {
    super.initState();
    _loadWeightEntries();
    _loadUserGender(); // Load user gender
  }

  Future<void> _loadUserGender() async {
    _gender = await StorageService.getGender(); // Get gender from StorageService
    setState(() {}); // Update the state to rebuild the UI
  }

  Future<void> _loadWeightEntries() async {
    final entries = await WeightService.getWeightEntries();
    setState(() {
      _weightEntries = entries;
    });
  }

  void _addWeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? weight;
        return AlertDialog(
          title: Text('Add Weight',style: TextStyle(color:Color(0xFF1584A3))),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
  labelStyle: TextStyle(color: Color(0xFF1584A3)), // Label text color
  labelText: 'Enter your weight (kg)',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5), // Rounded corners
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF1584A3), width: 2.0), // Blue border when not focused
    borderRadius: BorderRadius.circular(5),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF1584A3), width: 2.0), // Blue border when focused
    borderRadius: BorderRadius.circular(5),
  ),
),

            onChanged: (value) {
              weight = double.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (weight != null) {
                  String currentDate = DateFormat('yyyy-MM-dd - hh:mm a').format(DateTime.now());



                  debugPrint(currentDate);
                  WeightEntry newEntry = WeightEntry(date: currentDate, weight: weight);
                  bool exists = _weightEntries.any((entry) => entry.date == currentDate && entry.weight == weight);

                  if (!exists) {
                    await WeightService.addWeightEntry(newEntry);
                    setState(() {
                      _weightEntries.insert(0, newEntry);
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Weight entry for this date already exists')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid weight')),
                  );
                }
              },
              child: Text('Submit', style: TextStyle(color: Color(0xFF1584A3)),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(color: Color(0xFF1584A3))),
            ),
          ],
        );
      },
    );
  }

  void _editWeight(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? weight = _weightEntries[index].weight;
        return AlertDialog(
          title: Text('Edit Weight',style: TextStyle(color: Color(0xFF1584A3))),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
  labelStyle: TextStyle(color: Color(0xFF1584A3)), // Label text color
  labelText: 'Enter your weight (kg)',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5), // Rounded corners
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF1584A3), width: 2.0), // Blue border when not focused
    borderRadius: BorderRadius.circular(5),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF1584A3), width: 2.0), // Blue border when focused
    borderRadius: BorderRadius.circular(5),
  ),
),
            onChanged: (value) {
              weight = double.tryParse(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (weight != null) {
                  String date = _weightEntries[index].date; // Keep the existing date
                  WeightEntry updatedEntry = WeightEntry(date: date, weight: weight);
                  await WeightService.editWeightEntry(index, updatedEntry);
                  setState(() {
                    _weightEntries[index] = updatedEntry;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid weight',style: TextStyle(color: Color(0xFF1584A3)))),
                  );
                }
              },
              child: Text('Update',style: TextStyle(color: Color(0xFF1584A3))),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel',style: TextStyle(color: Color(0xFF1584A3))),
            ),
          ],
        );
      },
    );
  }

String _formatDate(String date) {
  try {
    // Correct the date format string
    DateTime parsedDate = DateFormat('yyyy-MM-dd - hh:mm a').parse(date); // Replace em dash with a normal hyphen
    String formattedDate = DateFormat('EEEE, MMM d, y hh:mm a').format(parsedDate); // Format with AM/PM
    return formattedDate;
  } catch (e) {
    debugPrint('Error parsing date: $e');
    return 'Invalid Date'; // Fallback in case of error
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF1584A3), // Set AppBar color to sky blue
        title: Text("Weight Tracker", style: TextStyle(color: Colors.white)), // White text
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: _addWeight,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sky Blue Card with Weight Icon and Text
          Container(
  height: MediaQuery.of(context).size.height * 0.4, // Top 30% of screen
  decoration: BoxDecoration(
    color: Color(0xFF1584A3), // Sky blue color
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(30), // Set bottom-left radius
      bottomRight: Radius.circular(30), // Set bottom-right radius
    ),
  ),
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          _gender == 'Male' ? 'assets/animations/male2.json' : 'assets/animations/female.json', // Path to your Lottie file based on gender
          width: 200, // Set width for the Lottie animation
          height: 200, // Set height for the Lottie animation
          fit: BoxFit.cover, // Fit the animation within the specified width and height
        ),
        SizedBox(height: 10), // Spacing between animation and text
        Text(
          'Be Ready',
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 24, // Text size
            fontWeight: FontWeight.bold, // Text bold
          ),
        ),
        Text(
          'Time to lose weight!',
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize: 18, // Text size
            fontWeight: FontWeight.bold, // Text bold
          ),
        ),
      ],
    ),
  ),
),

          // Weight List
          Expanded(
            child: _weightEntries.isEmpty // Check if the list is empty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty, size: 50, color: Colors.grey), // Empty icon
                        SizedBox(height: 20),
                        Text(
                          'No weight entries yet.',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _weightEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _weightEntries[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Add margin for spacing
                        decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF1584A3), // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners for the card
      ),
                        child: Card(
                          elevation: 0, // Add shadow effect
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 16), // Padding inside the ListTile
                            title: Text(
                              _formatDate(entry.date), // Display formatted date
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // Bold date
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              entry.weight != null ? "${entry.weight} kg" : "Missed",
                              style: TextStyle(
                                color: Colors.grey[600], // Grey text for weight
                                fontSize: 14,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF1584A3)), // Edit button color
                              onPressed: () => _editWeight(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

          ),
        ],
      ),
    );
  }
}
