
import 'package:flutter/material.dart';

class Event {
  String title;
  DateTime date;
  TimeOfDay time;
  String icon;
  Color color;
  String notes;



  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.icon,
    required this.color,
    required this.notes,
  });

  // Convert Event to a map for storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'icon': icon,
      'color': color.value,
      'notes': notes,
    };
  }

  // Create Event from a map
  static Event fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      icon: map['icon'],
      color: Color(map['color']),
      notes: map['notes'],
    );

  }

}

