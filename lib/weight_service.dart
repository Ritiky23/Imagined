import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightEntry {
  final String date;
  final double? weight;

  WeightEntry({required this.date, this.weight});

  Map<String, dynamic> toJson() => {
        'date': date,
        'weight': weight,
      };

  static WeightEntry fromJson(Map<String, dynamic> json) {
    return WeightEntry(
      date: json['date'],
      weight: json['weight']?.toDouble(),
    );
  }
}

class WeightService {
  static const String _weightEntriesKey = 'weight_entries';

  static Future<List<WeightEntry>> getWeightEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_weightEntriesKey);

    if (entriesJson != null) {
      List<dynamic> entriesList = json.decode(entriesJson);
      return entriesList.map((entry) => WeightEntry.fromJson(entry)).toList();
    }
    return [];
  }

  static Future<void> addWeightEntry(WeightEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<WeightEntry> entries = await getWeightEntries();
    entries.add(entry);
    await prefs.setString(_weightEntriesKey, json.encode(entries.map((e) => e.toJson()).toList()));
  }

  static Future<void> editWeightEntry(int index, WeightEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    List<WeightEntry> entries = await getWeightEntries();
    if (index >= 0 && index < entries.length) {
      entries[index] = entry;
      await prefs.setString(_weightEntriesKey, json.encode(entries.map((e) => e.toJson()).toList()));
    }
  }
}
