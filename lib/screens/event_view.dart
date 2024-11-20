import 'package:event_countdown/data/event_provider.dart';
import 'package:event_countdown/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_event_page.dart';
import '../model/event.dart';
import 'dart:async';

class EventView extends StatefulWidget {
  final Event event;
  final int eventIndex;
  EventView({required this.event, required this.eventIndex});

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> with WidgetsBindingObserver {
  Duration remainingTime = Duration();
  Timer? countdownTimer;
  bool eventEnded = false;
  DateTime? endDateTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadEndDateTime();
    _startCountdown();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _calculateRemainingTime();
    }
  }

  void _loadEndDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // استخدام مفتاح فريد يعتمد على eventIndex
    String? storedEndDateTime = prefs.getString('endDateTime_${widget.eventIndex}');
    if (storedEndDateTime != null) {
      setState(() {
        endDateTime = DateTime.parse(storedEndDateTime);
      });
    } else {
      final eventDateTime = DateTime(
        widget.event.date.year,
        widget.event.date.month,
        widget.event.date.day,
        widget.event.time.hour,
        widget.event.time.minute,
      );
      setState(() {
        endDateTime = eventDateTime;
        _saveEndDateTime(); // حفظ الوقت النهائي للحدث
      });
    }
    _calculateRemainingTime();
  }

  void _saveEndDateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // استخدام مفتاح فريد يعتمد على eventIndex
    await prefs.setString('endDateTime_${widget.eventIndex}', endDateTime!.toIso8601String());
  }
  void _calculateRemainingTime() {
    final now = DateTime.now();
    if (endDateTime != null && endDateTime!.isAfter(now)) {
      setState(() {
        remainingTime = endDateTime!.difference(now);
        eventEnded = false;
      });
    } else {
      setState(() {
        eventEnded = true;
        remainingTime = Duration.zero;
      });
    }
  }

  void _startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime = remainingTime - Duration(seconds: 1);
        } else {
          eventEnded = true;
          countdownTimer?.cancel(); // إيقاف المؤقت عند انتهاء الحدث
        }
      });
    });
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.event.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عنوان تفاصيل الحدث
              Text(
                S
                    .of(context)
                    .event_details,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Row يحتوي على الأيقونة والنص وTextField
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة الخاصة بالحدث
                  Image.asset(widget.event.icon, width: 80, height: 110),

                  SizedBox(width: 20), // مسافة بين الأيقونة والنص

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // النص "What is the event about?"
                        Text(
                          S
                              .of(context)
                              .event_title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),

                        // حقل إدخال للعنوان
                        Text(
                          "${TextEditingController(text: widget.event.title)
                              .text}",
                          style: TextStyle(fontSize: 18),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // الملاحظات
              Text(S
                  .of(context)
                  .notes_title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text(
                "${TextEditingController(text: widget.event.notes).text}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),

              // التاريخ

              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // لجعل النص في اليمين والبيانات في اليسار
                children: [
                  Text(
                    S
                        .of(context)
                        .Date,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.event.date.year}-${widget.event.date
                        .month}-${widget.event.date.day}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // الوقت
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // لجعل النص في اليمين والبيانات في اليسار
                children: [
                  Text(
                    S
                        .of(context)
                        .Time,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.event.time.hour}:${widget.event.time.minute}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 100),

              // العدّاد
              eventEnded
                  ? Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 27, 67),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child:Text(
                  S.of(context).ended_event,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),)
              )
                  : Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                      255, 0, 27, 67), // اللون الأزرق الغامق للصندوق الكبير
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // صندوق لعدد الأيام
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                          Colors.white, // اللون الأبيض للصندوق الداخلي
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .Days,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${remainingTime.inDays}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // صندوق لعدد الساعات
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                          Colors.white, // اللون الأبيض للصندوق الداخلي
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .Hours,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${remainingTime.inHours % 24}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // صندوق لعدد الدقائق
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                          Colors.white, // اللون الأبيض للصندوق الداخلي
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .Minutes,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${remainingTime.inMinutes % 60}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // صندوق لعدد الثواني
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                          Colors.white, // اللون الأبيض للصندوق الداخلي
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .Seconds,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "${remainingTime.inSeconds % 60}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(), // هذا الفاصل لدفع الزرارين إلى أسفل الصفحة

              // Row يحتوي على زر Edit وزر Delete
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // لجعل الزرين على الجانبين
                children: [
                  // زر Edit
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // الانتقال إلى صفحة EditEventPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditEventPage(
                                    event: widget.event,
                                    eventIndex: widget
                                        .eventIndex), // استخدم المتغير المناسب eventIndex حسب صفحتك
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // لون الزر
                        padding: EdgeInsets.symmetric(vertical: 15), // حجم الزر
                      ),
                      child: Text(S
                          .of(context)
                          .Edit,
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),

                  SizedBox(width: 10), // مسافة بين الزرين

                  // زر Delete
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // تأكيد عملية الحذف من خلال Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(S
                                  .of(context)
                                  .delete),
                              content:
                              Text(S
                                  .of(context)
                                  .delete_event_confirmation),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // إغلاق الـ Dialog بدون حذف
                                  },
                                  child: Text(S
                                      .of(context)
                                      .cancel),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // تنفيذ عملية الحذف
                                    Provider.of<EventProvider>(context,
                                        listen: false)
                                        .deleteEvent(widget
                                        .eventIndex); // استخدم المتغير المناسب eventIndex حسب صفحتك
                                    Navigator.of(context)
                                        .pop(); // إغلاق الـ Dialog
                                    Navigator.of(context)
                                        .pop(); // العودة إلى صفحة MyEventsPage بعد الحذف
                                  },
                                  child: Text(S
                                      .of(context)
                                      .delete),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        S
                            .of(context)
                            .delete,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
