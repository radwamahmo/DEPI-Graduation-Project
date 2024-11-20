import 'package:event_countdown/generated/l10n.dart';
import 'package:event_countdown/data/event_data_model.dart';
import 'package:event_countdown/data/event_provider.dart';
import 'package:event_countdown/screens/notifications/local_notification_service.dart';
import 'package:event_countdown/widgets/button.dart';
import 'package:event_countdown/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/event.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final EventDataModel eventData = EventDataModel();

  void _saveEvent() {
    if (eventData.titleController.text.isEmpty ||
        eventData.selectedDate == null ||
        eventData.selectedTime == null) {
      return;
    }

    final newEvent = Event(
      title: eventData.titleController.text,
      date: eventData.selectedDate!,
      time: eventData.selectedTime!,
      icon: eventData.selectedIcon,
      color: eventData.selectedColor,
      notes: eventData.notesController.text,
    );
    LocalNotificationService.showScheduledNotification(newEvent);

    Provider.of<EventProvider>(context, listen: false).addEvent(newEvent);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).event_added_snackbar)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(S.of(context).add_event)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(S.of(context).event_title, style: TextStyle(fontSize: 18)),
              SizedBox(height: 15),
              TextField(
                controller: eventData.titleController,
                decoration: InputDecoration(
                  hintText: S.of(context).event_hint_text,
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Color(0xff0d1345)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).Date),
                  Text(
                    eventData.selectedDate != null
                        ? '${eventData.selectedDate}'.split(' ')[0]
                        : S.of(context).event_date_initial_value,
                  ),
                  TButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          eventData.selectedDate = pickedDate;
                        });
                      }
                    },
                    buttonText: S.of(context).date_picker,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).Time),
                  Text(
                    eventData.selectedTime != null
                        ? eventData.selectedTime!.format(context)
                        : S.of(context).event_time_initial_value,
                  ),
                  TButton(
                    onPressed: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          eventData.selectedTime = pickedTime;
                        });
                      }
                    },
                    buttonText: S.of(context).time_picker,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).Icon),

                  //! there is no displayed text even if there is no selected icon!!!
                  eventData.selectedIcon != null
                      ? Image.asset(eventData.selectedIcon,
                          width: 30, height: 30)
                      : Text(S.of(context).event_icon_initial_value),

                  TButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(S.of(context).choose_icon),
                            content: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: eventData.availableImageIcons
                                    .map((imagePath) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        eventData.selectedIcon = imagePath;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      imagePath,
                                      width: 30,
                                      height: 30,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    buttonText: S.of(context).choose_icon,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).Color),

                  //! there is no displayed text even if there is no selected Color!!!

                  eventData.selectedColor != null
                      ? Container(
                          width: 30, height: 30, color: eventData.selectedColor)
                      : Text(S.of(context).event_color_initial_value),
                  TButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(S.of(context).choose_color),
                            content: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    eventData.availableColors.map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        eventData.selectedColor = color;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      color: color,
                                      margin: EdgeInsets.all(4.0),
                                      child: eventData.selectedColor == color
                                          ? Icon(Icons.check,
                                              color: Colors.white)
                                          : null,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    buttonText: S.of(context).choose_color,
                  ),
                ],
              ),
              SizedBox(height: 26),
              Text(S.of(context).notes_title, style: TextStyle(fontSize: 16)),
              SizedBox(height: 15),
              TextField(
                controller: eventData.notesController,
                decoration: InputDecoration(
                  hintText: S.of(context).notes_hint_text,
                  hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(color: Color(0xff0d1345)),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 120),
              Center(
                  child: Button(
                onPressed: _saveEvent,
                buttonText: S.of(context).save_button,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
