//! Edit event page ----> Nourhan

import 'package:event_countdown/generated/l10n.dart';
import 'package:event_countdown/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/event.dart';
import '../data/event_data_model.dart';
import '../data/event_provider.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  final int eventIndex;

  EditEventPage({required this.event, required this.eventIndex});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late EventDataModel eventData;

  @override
  void initState() {
    super.initState();
    eventData = EventDataModel();

    eventData.titleController.text = widget.event.title;
    eventData.selectedDate = widget.event.date;
    eventData.selectedTime = widget.event.time;
    eventData.selectedIcon = widget.event.icon;
    eventData.selectedColor = widget.event.color;
    eventData.notesController.text = widget.event.notes;
  }

  void _saveEditedEvent() {
    if (eventData.titleController.text.isEmpty ||
        eventData.selectedDate == null ||
        eventData.selectedTime == null) {
      return;
    }

    final editedEvent = Event(
      title: eventData.titleController.text,
      date: eventData.selectedDate!,
      time: eventData.selectedTime!,
      icon: eventData.selectedIcon,
      color: eventData.selectedColor,
      notes: eventData.notesController.text,
    );

    Provider.of<EventProvider>(context, listen: false)
        .updateEvent(widget.eventIndex, editedEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).event_edited_snackbar)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).edit_event),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(S.of(context).edit_event_details,
                    style: TextStyle(fontSize: 18)),
                _buildTextField(
                    S.of(context).event_title, eventData.titleController),
                SizedBox(height: 30),
                _buildDatePicker(),
                SizedBox(height: 20),
                _buildTimePicker(),
                SizedBox(height: 20),
                _buildIconPicker(),
                SizedBox(height: 20),
                _buildColorPicker(),
                SizedBox(height: 20),
                _buildNotesField(),
                SizedBox(height: 120),
                Center(
                  child: Button(
                    onPressed: _saveEditedEvent,
                    buttonText: S.of(context).save_button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).notes_title, style: TextStyle(fontSize: 18)),
        _buildTextField(
            S.of(context).notes_hint_text, eventData.notesController),
      ],
    );
  }

  Widget _buildDatePicker() {
    return _buildPicker(
      title: S.of(context).Date,
      displayText: eventData.selectedDate != null
          ? '${eventData.selectedDate}'.split(' ')[0]
          : S.of(context).event_date_initial_value,
      onEdit: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: eventData.selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            eventData.selectedDate = pickedDate;
          });
        }
      },
    );
  }

  Widget _buildTimePicker() {
    return _buildPicker(
      title: S.of(context).Time,
      displayText: eventData.selectedTime != null
          ? eventData.selectedTime!.format(context)
          : S.of(context).event_time_initial_value,
      onEdit: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: eventData.selectedTime ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            eventData.selectedTime = pickedTime;
          });
        }
      },
    );
  }

  Widget _buildIconPicker() {
    return _buildPicker(
      title: S.of(context).Icon,
      displayWidget: eventData.selectedIcon.isNotEmpty
          ? Image.asset(eventData.selectedIcon, width: 30, height: 30)
          : Text(S.of(context).event_icon_initial_value),
      onEdit: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).choose_icon),
              content: SingleChildScrollView(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: eventData.availableImageIcons.map((imagePath) {
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
    );
  }

  Widget _buildColorPicker() {
    return _buildPicker(
      title: S.of(context).Color,
      displayWidget: Container(
        width: 30,
        height: 30,
        color: eventData.selectedColor,
      ),
      onEdit: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).choose_color),
              content: SingleChildScrollView(
                child: Wrap(
                  spacing: 10, // space between columns
                  runSpacing: 10, // space between rows
                  children: eventData.availableColors.map((color) {
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
                            ? Icon(Icons.check, color: Colors.white)
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
    );
  }

  Widget _buildPicker({
    required String title,
    String? displayText, // for time and date
    Widget? displayWidget, // for icons and colors
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        displayWidget ?? Text(displayText ?? ''),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ),
      ],
    );
  }
}
