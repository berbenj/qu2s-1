// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;
// import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'dart:async';
import 'package:ntp/ntp.dart';
import 'package:dart_date/dart_date.dart';

import '../q2_date.dart';
import '../q2_platform.dart';
import '../q2_scheduler.dart';

Q2Platform q2Platform = Q2Platform();

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    super.key,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final auth = fd.FirebaseAuth.instance;
  String eventTitle = '';
  String eventDesc = '';
  fd.Document? currentEvent;

  Future<List<fd.Document>> getFutureEvents(fd.CollectionReference eventCollection) async {
    var docs = eventCollection.get();
    return docs;
  }

  @override
  Widget build(BuildContext context) {
    fd.CollectionReference eventCollection = fd.Firestore.instance.collection('events/${auth.userId}/events');
    fd.DocumentReference eventDoc = fd.Firestore.instance.document('events/${auth.userId}');

    return Row(children: [
      Expanded(
          flex: 1,
          child: StreamBuilder(
              stream: eventCollection.orderBy('startDateTime').get().asStream(),
              builder: (c, s) {
                if (!s.hasData) {
                  return const Center(
                    child: Text('no data'),
                  );
                }

                List<Widget> events = [];
                for (var doc in s.requireData) {
                  if (doc['startDateTime'] == null) continue;

                  events.add(Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 56, 56, 56),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        doc['title'],
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                          '${doc['startDateTime'].toString().substring(11, 16)} - ${doc['endDateTime'].toString().substring(11, 16)}'),
                                      Text('${doc['lengthInMinutes'].toString()} m'),
                                      Text(doc['repeating'] ? '↻' : doc['maxEndDateTime'].toString().substring(0, 16)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: OutlinedButton(
                                        onPressed: () async {
                                          if (doc['repeating']) {
                                            await eventCollection.document(doc.id).update({
                                              'lastDone': DateTime.now(),
                                              'startDateTime': null,
                                              'endDateTime': null,
                                            });
                                          } else {
                                            await eventCollection.document(doc.id).update({
                                              'lastDone': DateTime.now(),
                                              'done': true,
                                              'startDateTime': null,
                                              'endDateTime': null,
                                            });
                                          }
                                          await eventDoc.update({'needsReschedule': true});
                                          setState(() {});
                                        },
                                        child: const Text('Done')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
                }

                return ListView(
                  children: events,
                );
              })),
      const VerticalDivider(width: 1, color: Color.fromARGB(255, 60, 60, 60)),
      Expanded(
        flex: 2,
        child: FutureBuilder(
          future: eventCollection.orderBy('startDateTime').get(),
          builder: (c, s) {
            if (s.hasData) {
              for (var doc in s.requireData) {
                if (doc['startDateTime'] == null) {
                  continue;
                } else {
                  eventTitle = doc['title'];
                  eventDesc = doc['description'];
                  currentEvent = doc;
                  break;
                }
              }
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: StreamBuilder(
                      stream: eventDoc.stream,
                      builder: (c, s) {
                        if (s.hasData && s.data!['needsReschedule']) {
                          return ElevatedButton.icon(
                            onPressed: () async {
                              List<fd.Document> docs = await eventCollection.get();
                              schedule(docs, eventCollection);
                              await eventDoc.update({'needsReschedule': false});
                              setState(() {});
                            },
                            icon: const Icon(Icons.warning),
                            label: const Text('Reschedule events!'),
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                                overlayColor: MaterialStatePropertyAll(Colors.redAccent),
                                foregroundColor: MaterialStatePropertyAll(Colors.black)),
                          );
                        } else {
                          return OutlinedButton(
                              onPressed: () async {
                                List<fd.Document> docs = await eventCollection.get();
                                schedule(docs, eventCollection);
                                await eventDoc.update({'needsReschedule': false});
                                setState(() {});
                              },
                              child: const Text('Reschedule events'));
                        }
                      }),
                ),
                Clock(currentEvent == null ? null : currentEvent!['startDateTime'],
                    currentEvent == null ? null : currentEvent!['endDateTime']),
                OutlinedButton(
                    onPressed: () async {
                      if (currentEvent != null) {
                        if (currentEvent!['repeating']) {
                          await eventCollection.document(currentEvent!.id).update({
                            'lastDone': DateTime.now(),
                            'startDateTime': null,
                            'endDateTime': null,
                          });
                        } else {
                          await eventCollection.document(currentEvent!.id).update({
                            'lastDone': DateTime.now(),
                            'done': true,
                            'startDateTime': null,
                            'endDateTime': null,
                          });
                        }
                        await eventDoc.update({'needsReschedule': true});
                        setState(() {});
                      }
                    },
                    child: const Text('Done')),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(eventTitle, style: const TextStyle(fontSize: 25)),
                            const Divider(color: Color.fromARGB(255, 60, 60, 60)),
                            // idea: editable title, description
                            Text(eventDesc, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      )
    ]);
  }
}

class Clock extends StatefulWidget {
  final DateTime? startOfEvent;
  final DateTime? endOfEvent;

  const Clock(this.startOfEvent, this.endOfEvent, {super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  String _b36Date = '';
  String _qdArton = '';
  String _qdJitt = '';
  String _gregorianDate = '';
  String _gregorianHour = '';
  String _gregorianMinute = '';
  String _gregorianSecond = '';
  String _amp = '';
  String _12h = '';
  String _weekday = '';
  String _weeknum = '';
  Timer? _clockTimer;
  Timer? _aNTPTimer;
  int offset = 0;
  String counter = '';
  Color counterColor = const Color(0xFFFFFFFF);

  void _setCurrentDate([DateTime? date_]) {
    setState(() {
      // if no date is provided use the current time
      date_ ??= DateTime.now().toLocalTime;
      DateTime date = date_!;
      date = date.addMilliseconds(offset);

      var qdt = Q2Date(date);

      _b36Date = '${qdt.b36Year}/${qdt.b36Pernor}${qdt.b36Scrop}-${qdt.b36Day}';
      _qdArton = "${qdt.qdArton}'";
      _qdJitt = '${qdt.qdJitt}"';

      _gregorianDate = '${qdt.grYear}-${qdt.grMonth}-${qdt.grDay}';
      _gregorianHour = qdt.sdHour;
      _gregorianMinute = ':${qdt.sdMinute}';
      _gregorianSecond = ':${qdt.sdSecond}';
      _amp = (int.parse(qdt.sdHour) < 12) ? 'AM' : 'PM';
      _12h = (((int.parse(qdt.sdHour) + 11) % 12) + 1).toString().padLeft(2, '0');
      var wd = date.weekday;
      switch (wd) {
        case DateTime.monday:
          _weekday = 'mon';
          break;
        case DateTime.tuesday:
          _weekday = 'tue';
          break;
        case DateTime.wednesday:
          _weekday = 'wed';
          break;
        case DateTime.thursday:
          _weekday = 'thu';
          break;
        case DateTime.friday:
          _weekday = 'fri';
          break;
        case DateTime.saturday:
          _weekday = 'sat';
          break;
        case DateTime.sunday:
          _weekday = 'sun';
          break;
        default:
          _weekday = '';
      }
      _weeknum = date.getWeek.toString().padLeft(2, '0');

      if (widget.startOfEvent != null && widget.startOfEvent!.isAfter(date)) {
        var diff = widget.startOfEvent!.diff(date);
        if (diff.inHours < 1) {
          counter = '-${diff.toString().substring(2, 7)}';
        } else {
          counter = '-${diff.toString().substring(0, 7)}';
        }
        counterColor = Colors.deepPurpleAccent;
      } else if (widget.endOfEvent != null) {
        var diff = date.diff(widget.endOfEvent!);
        if (diff.isNegative) {
          diff = date.sub(const Duration(seconds: 1)).diff(widget.endOfEvent!);
          if (diff.inHours > -1) {
            counter = diff.toString().substring(3, 8);
          } else {
            counter = diff.toString().substring(1, 8);
          }
        } else {
          if (diff.inHours < 1) {
            counter = '+${diff.toString().substring(2, 7)}';
          } else {
            counter = '+${diff.toString().substring(0, 7)}';
          }
        }

        if (diff.isNegative) {
          if (diff.inMinutes > -2) {
            counterColor = Colors.yellow;
          } else {
            counterColor = Colors.greenAccent;
          }
        } else {
          if (diff.inMinutes < 5) {
            counterColor = Colors.orangeAccent;
          } else {
            counterColor = Colors.redAccent;
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getTime(DateTime.now());
    _clockTimer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => _setCurrentDate());
    _aNTPTimer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _getTime(DateTime.now()));
  }

  @override
  void dispose() {
    _clockTimer!.cancel();
    _aNTPTimer!.cancel();
    super.dispose();
  }

  Future _getTime(DateTime time) async {
    // question: how much does this cost?
    offset = await NTP.getNtpOffset(localTime: time);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gregorianClock(),
            const SizedBox(width: 100),
            b36Clock(),
          ],
        ),
        Text(
          counter,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: counterColor),
        ),
      ],
    );
  }

  Column b36Clock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _b36Date,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _qdArton,
              style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900),
            ),
            Text(
              _qdJitt,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 1.4),
            ),
          ],
        ),
      ],
    );
  }

  Column gregorianClock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              _gregorianDate,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  '($_weeknum)',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                Text(
                  _weekday,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  _amp,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
                Text(
                  _12h,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Text(
              _gregorianHour,
              style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w900),
            ),
            Text(
              _gregorianMinute,
              style: const TextStyle(fontSize: 68, fontWeight: FontWeight.w300),
            ),
            Text(
              _gregorianSecond,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w300, height: 1.4),
            ),
          ],
        ),
      ],
    );
  }
}
