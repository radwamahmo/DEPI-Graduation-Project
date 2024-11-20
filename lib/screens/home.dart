//! الصفحة الرئيسية -> بسنت سعيد

import 'package:event_countdown/generated/l10n.dart';
import 'package:event_countdown/data/event_data_model.dart';
import 'package:event_countdown/data/event_provider.dart';
import 'package:event_countdown/screens/event_view.dart';
import 'package:flutter/material.dart';
import 'package:event_countdown/screens/drawer.dart';
import 'package:provider/provider.dart';
import 'add_event_page.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  List<EventDataModel> events = [];

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.of(context).app_name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
//!          الذهاب لصفحة اضافة الحدث -> بشمهندس محمود فاروق
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEventPage(),
                  ));
            },
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: eventProvider.events.length,
        itemBuilder: (context, index) {
          final event = eventProvider.events[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Image.asset(event.icon,
                  width: 40, height: 40), // Use Image.asset for icon
              title: Text(event.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${event.date.day}/${event.date.month}/${event.date.year} - ${event.time.hour}:${event.time.minute}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              tileColor: event.color,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EventView(event: event, eventIndex: index),
                  ),
                );
              },

              // You can add more details here
            ),
          );
        },
      ),
//!           الصفحة الجانبية للاعدادات-> بشمهندسة نورهان
      drawer: AppDrawer(),
    );
  }
}
