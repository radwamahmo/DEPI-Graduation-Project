import 'dart:convert';
import 'dart:developer';

import 'package:event_countdown/model/event.dart';
import 'package:event_countdown/screens/notifications/notification.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  late final Event event;

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static List<Event> notifiedEvents = [];
  static onTap(NotificationResponse notificationResponse) {}
  static Future init() async {
    InitializationSettings settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings());

    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: onTap,
        onDidReceiveBackgroundNotificationResponse: onTap);
  }

  static void showScheduledNotification(Event event) async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails('id 1', 'scheduled notification',
            importance: Importance.max, priority: Priority.high));
    tz.initializeTimeZones();
    log(tz.local.name);
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    log(currentTimeZone);
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    final eventDateTime = tz.TZDateTime(
      tz.local,
      event.date.year,
      event.date.month,
      event.date.day,
      event.time.hour,
      event.time.minute,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, event.title, event.notes, eventDateTime, details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    NotificationHistory.notifiedEvents.add(event);
    await _saveNotifiedEvent(event);
  }

  static Future<void> _saveNotifiedEvent(Event event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? savedEvents = prefs.getStringList('notifiedEvents') ?? [];
    savedEvents.add(jsonEncode(event.toMap()));

    await prefs.setStringList('notifiedEvents', savedEvents);
  }
}
