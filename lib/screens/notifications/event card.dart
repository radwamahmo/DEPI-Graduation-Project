import 'package:event_countdown/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../model/event.dart';

class EventCard extends StatelessWidget {
  final Event eventData;

  EventCard({required this.eventData});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        // color: Color(0xFFDEDEE7),
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventData.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${S.of(context).Date}: ${eventData.date.toIso8601String()}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${S.of(context).Time}: ${eventData.time.format(context)}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.notes,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${S.of(context).notes_title}: ${eventData.notes}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
