import 'package:flutter/material.dart';

class EventDataModel {
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  Color selectedColor = Colors.red;
  String selectedIcon = 'assets/images/1.png'; // Default icon
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final List<String> availableImageIcons = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png',
    'assets/images/7.png',
    'assets/images/8.png',
    'assets/images/9.png',
    'assets/images/10.png',
    'assets/images/11.png',
    'assets/images/12.png',
    'assets/images/13.png',
    'assets/images/14.png',
    'assets/images/15.png',
    'assets/images/16.png',
    'assets/images/17.png',
    'assets/images/18.png',
    'assets/images/19.png',
    'assets/images/20.png',
    'assets/images/21.png',
    'assets/images/22.png',
    'assets/images/23.png',
    'assets/images/24.png',
    'assets/images/25.png',
    'assets/images/26.png',
    'assets/images/27.png',
    'assets/images/28.png',
    'assets/images/29.png',
    'assets/images/30.png',
  ];
  List<Color> availableColors = [
    const Color(0xffa85f4d),
    const Color(0xff558b6e),
    const Color(0xffe98a15),
    const Color(0xff1f7a8c),
    const Color(0xff963128),
    const Color(0xffff6b6b),
    const Color(0xff45462a),
    const Color(0xff595e89),
    const Color(0xfff9cb40),
    const Color(0xffa76571),
  ];
}
