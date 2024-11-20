import 'package:event_countdown/model/event.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
// import 'screens/event.dart';


class EventProvider with ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  EventProvider() {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    String? eventsString = prefs.getString('events');

    if (eventsString != null) {
      List<dynamic> eventsJson = json.decode(eventsString);
      _events = eventsJson.map((eventMap) => Event.fromMap(eventMap)).toList();
      notifyListeners();
    }
  }

  Future<void> addEvent(Event newEvent) async {
    _events.add(newEvent);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> eventMaps = _events.map((event) => event.toMap()).toList();
    String eventsString = json.encode(eventMaps);
    await prefs.setString('events', eventsString);
    notifyListeners();
  }
  // تحديث حدث موجود
  void updateEvent(int index, Event updatedEvent) {
    if (index >= 0 && index < _events.length) {
      _events[index] = updatedEvent;
      _saveEvents();
      notifyListeners();
    }
  }
  // حذف حدث
  void deleteEvent(int index) {
    if (index >= 0 && index < _events.length) {
      _events.removeAt(index);
      _saveEvents();
      notifyListeners();
    }
  }
}
