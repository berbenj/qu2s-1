import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:cloud_firestore/cloud_firestore.dart' as fs;

import '../q2_platform.dart';

Q2Platform q2Platform = Q2Platform();

class TimelinePage extends StatefulWidget {
  const TimelinePage({
    super.key,
  });

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  Widget build(BuildContext context) {
    late CollectionReference eventCollectionWeb;
    late fd.CollectionReference eventCollection;
    if (q2Platform.isWeb) {
      eventCollectionWeb =
          fs.FirebaseFirestore.instance.collection('event_test');
    } else if (q2Platform.isWindows) {
      eventCollection = fd.Firestore.instance.collection('event_test');
    }

    // return const Row(children: [
    //   Expanded(
    //       flex: 1,
    //       child: Column(
    //         children: [
    //           Text('Current event'),
    //           Text('Current event start time'),
    //           Text('Current event end time'),
    //           Text('Current event length'),
    //           Text('Current event deadline end'),
    //           SizedBox(height: 20),
    //           Text('Next event'),
    //           Text('Next event start time'),
    //           Text('Next event end time'),
    //           Text('Next event length'),
    //           Text('Next event deadline end'),
    //         ],
    //       )),
    //   VerticalDivider(
    //     width: 1,
    //   ),
    //   Expanded(
    //       flex: 2,
    //       child: Column(
    //         children: [
    //           Text('current Time'),
    //           Text('Done button'),
    //           Text('Current event title'),
    //           Text('Current event content'),
    //         ],
    //       ))
    // ]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (q2Platform.isWeb) {
                  await eventCollectionWeb
                      .doc('event')
                      .update({'is_event': true});
                } else if (q2Platform.isWindows) {
                  await eventCollection
                      .document('event')
                      .update({'is_event': true});
                }
              },
              child: const Text('Add event'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                if (q2Platform.isWeb) {
                  await eventCollectionWeb
                      .doc('event')
                      .update({'is_event': false});
                } else if (q2Platform.isWindows) {
                  await eventCollection
                      .document('event')
                      .update({'is_event': false});
                }
              },
              child: const Text('Remove event'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          key: const Key('event_container'),
          decoration: BoxDecoration(border: Border.all()),
          height: 200,
          width: 200,
          child: Center(
            child: (q2Platform.isWeb)
                ? StreamBuilder(
                    stream: eventCollectionWeb.doc('event').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (snapshot.data!.data()
                              as Map<String, dynamic>)['is_event']) {
                        return Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(color: Colors.orange),
                        );
                      }
                      return Container();
                    },
                  )
                : (q2Platform.isWindows)
                    ? StreamBuilder(
                        stream: eventCollection.document('event').stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!['is_event']) {
                            return Container(
                              width: 180,
                              height: 180,
                              decoration:
                                  const BoxDecoration(color: Colors.orange),
                            );
                          }
                          return Container();
                        },
                      )
                    // if it is not a supported platform
                    : const Center(
                        child: Text('This platform is\nnot supported!'),
                      ),
          ),
        ),
      ],
    );
  }
}
