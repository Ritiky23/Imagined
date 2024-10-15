import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StorageService {
  static const String _keyName = 'user_name';
  static const String _keyGender = 'user_gender'; // Key for gender
  static const String _keyNotificationTimeHour = 'notification_time_hour';
  static const String _keyNotificationTimeMinute = 'notification_time_minute';
  static const String _keyWeightEntries = 'weight_entries'; // Key for weight entries

  // Save user name
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  // Get user name
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  // Save user gender
  static Future<void> saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyGender, gender); // Save gender
  }

  // Get user gender
  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyGender); // Retrieve gender
  }

  // Save notification time
  static Future<void> saveNotificationTime(TimeOfDay time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNotificationTimeHour, time.hour);
    await prefs.setInt(_keyNotificationTimeMinute, time.minute);
  }

  // Get notification time
  static Future<TimeOfDay> getNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_keyNotificationTimeHour) ?? 8; // Default to 8 AM
    final minute = prefs.getInt(_keyNotificationTimeMinute) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Save weight entries (assume weight entries are stored as a list of doubles)
  static Future<void> saveWeightEntries(List<double> weights) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> weightStrings = weights.map((w) => w.toString()).toList(); // Convert double to String
    await prefs.setStringList(_keyWeightEntries, weightStrings);
  }

  // Get weight entries
  static Future<List<double>> getWeightEntries() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? weightStrings = prefs.getStringList(_keyWeightEntries);
    if (weightStrings != null) {
      return weightStrings.map((w) => double.parse(w)).toList(); // Convert String back to double
    }
    return [];
  }

  // Clear weight entries
  static Future<void> clearWeightEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyWeightEntries);
  }

  // Reset notification time and weight entries
 static Future<void> resetNotificationAndWeightData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNotificationTimeHour, 8); 
    await prefs.setInt(_keyNotificationTimeMinute, 0); 
    await prefs.remove(_keyWeightEntries);
  }

  // Check if user exists (name, gender, and notification time)
  static Future<bool> userExists() async {
    final name = await getName();
    final gender = await getGender(); // Check for gender as well
    final notificationTime = await getNotificationTime();
    return name != null && gender != null;// Adjust default if needed
  }

  // Reset all data (if needed)
  static Future<void> resetData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear everything
  }
}
