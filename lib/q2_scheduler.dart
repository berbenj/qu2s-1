import 'package:dart_date/dart_date.dart';
import 'package:firedart/firedart.dart' as fd;
import 'event.dart';

void schedule(List<fd.Document> eventDocs, fd.CollectionReference eventCollection) {
  List<Event> events = [];
  for (var doc in eventDocs) {
    if (doc['done'] == false) {
      events.add(Event(
        doc.id,
        doc['title'],
        doc['minStartDateTime'],
        doc['maxEndDateTime'],
        Duration(minutes: doc['lengthInMinutes']),
        doc['numOfEvents'],
        doc['lastDone'],
        doc['repeating'],
        doc['repeateEveryXHour'],
        doc['priority'],
      ));
    }
  }

  List<Event> calendar = [];
  List<Event> pastEvents = [];
  List<Event> unplacedEvents = [];

  var now = DateTime.now();

  for (var event in events) {
    if (event.repeating) {
      if (event.repeateEveryXHour != null) {
        while ((event.availabilityEnd.subtract(event.length)).isPast ||
            (event.lastTimeDone != null && event.availabilityStart.isBefore(event.lastTimeDone!))) {
          event.availabilityStart = event.availabilityStart.addHours(event.repeateEveryXHour!);
          event.availabilityEnd = event.availabilityEnd.addHours(event.repeateEveryXHour!);
        }
      } else {
        event.availabilityStart = now;
        event.availabilityEnd = now.add(const Duration(days: 365 * 100));
      }
    } else if ((event.availabilityEnd.subtract(event.length)).isPast) {
      pastEvents.add(event);
    }

    if (event.availabilityStart.isPast) {
      event.availabilityStart = now;
    }
  }

  // sort items absed on smallest flexibility
  // events.shuffle(); // unnecessary for now
  events.sort((a, b) {
    if (a.lastTimeDone == null && b.lastTimeDone != null) return -1;
    if (a.lastTimeDone != null && b.lastTimeDone == null) return 1;
    if (a.lastTimeDone == null && b.lastTimeDone == null) return 0;
    return a.lastTimeDone!.compareTo(b.lastTimeDone!);
  });
  events.sort((a, b) {
    if (a.repeating && b.repeating) return 0;
    if (!a.repeating && b.repeating) return -1;
    if (a.repeating && !b.repeating) return 1;
    return a.flexibilty.compareTo(b.flexibilty);
  });
  events.sort((a, b) => b.priority.compareTo(a.priority));

  for (;;) {
    if (events.isEmpty) {
      break;
    }
    var event = events.removeAt(0);

    // if event connot be placed than don't try to
    if (pastEvents.contains(event)) continue;

    bool success = placeEventFirstOpenPosition(event, calendar);
    if (success) {
      continue;
    }

    success = placeEventCheckIfShiftPossible(event, calendar);
    if (success) {
      continue;
    }

    success = placeEventCheckIfSwapPossible(event, calendar);
    if (success) {
      continue;
    }

    unplacedEvents.add(event);
  }

  for (var event in calendar) {
    eventCollection.document(event.id).update({
      'startDateTime': event.start,
      'endDateTime': event.end,
    });
  }

  for (var event in unplacedEvents) {
    eventCollection.document(event.id).update({
      'startDateTime': event.start,
      'endDateTime': event.end,
      // todo: set state as 'Unplaced'
    });
  }

  for (var event in pastEvents) {
    eventCollection.document(event.id).update({
      'startDateTime': event.start,
      'endDateTime': event.end,
      // todo: set state as 'Due date already past'
    });
  }
}

bool placeEventCheckIfSwapPossible(Event event, List<Event> calendar) {
  // todo: implement this
  return false;
}

bool placeEventCheckIfShiftPossible(Event event, List<Event> calendar) {
  // todo: implement this

  /// search for all end and start points from [calendar] that are whitin the [event]'s availability → expansion point (ep)
  ///   after found one only the same type should be search for
  ///   (eg.: if the first ep found is and end point then only search for end points)
  /// search free space before and after ep
  /// search possible free space moving events along, forward and backwards
  ///   check how far the next event can be moved maxed based on the one after that one recoursively
  /// is the space available enough?
  /// if yes than move everything the minimum amount, then place [event]
  /// otherwise do nothing and exit

  return false;
}

/// Tries to place [event] to the first position where it fits
/// without moving other events in the [calendar] around.
/// Returns true if it managed to place event, otherwise returns false.
bool placeEventFirstOpenPosition(Event event, List<Event> calendar) {
  void insertIntoCalendar(Event event) {
    calendar.insert(
        calendar.indexWhere((element) => event.start!.isBefore(element.start!)) == -1
            ? calendar.length
            : calendar.indexWhere((element) => event.start!.isBefore(element.start!)),
        event);
  }

  /// find the first event in calendar that has a placement that touches [event]'s availability
  int otherIndex = -1;
  for (var i = 0; i < calendar.length; i++) {
    if (!calendar[i].end!.isBefore(event.availabilityStart) && calendar[i].end!.isBefore(event.availabilityEnd)) {
      otherIndex = i;
      break;
    }
  }

  /// if there is no event overleaping in calendar than check if there is enough space to place event and place it, or exit
  if (otherIndex == -1) {
    event.start = event.availabilityStart;
    event.end = event.start!.add(event.length);
    if (calendar.isEmpty) {
      calendar.add(event);
    } else {
      insertIntoCalendar(event);
    }
    return true;
  }

  if (calendar[otherIndex].start!.isAfter(event.availabilityStart)) {
    /// check if it fits before it
    var availableSpaceBefore = calendar[otherIndex].start!.difference(event.availabilityStart);
    if (availableSpaceBefore > event.length) {
      event.start = event.availabilityStart;
      event.end = event.start!.add(event.length);
      insertIntoCalendar(event);
      return true;
    }
  }

  for (;;) {
    /// if [other] is the last event in calendar, then check if there is place to place [event],
    /// place it if possible, exit if not
    if (otherIndex == calendar.length - 1) {
      var start = calendar[otherIndex].end!;
      if (event.availabilityStart.isAfter(calendar[otherIndex].end!)) {
        start = event.availabilityStart;
      }
      var end = start.add(event.length);
      if (!end.isAfter(event.availabilityEnd)) {
        event.start = start;
        event.end = end;
        insertIntoCalendar(event);
        return true;
      }
      return false;
    }

    /// 3. if between [other] and the event one after that in the calendar,
    /// there is enough space to place event, then place it
    {
      var start = calendar[otherIndex].end!;
      var end = calendar[otherIndex + 1].start!;
      if (end.isAfter(event.availabilityEnd)) {
        end = event.availabilityEnd;
      }
      var availableSpace = end.difference(start);
      if (availableSpace >= event.length) {
        event.start = start; // todo: check if this is correct, and should not be `max(start, event.availabilityStart)`
        event.end = start.add(event.length);
        insertIntoCalendar(event);
        return true;
      }
    }

    /// 4. if there is not then increment [other]
    otherIndex++;

    /// 5. if [other] is past [event]'s availability then exit
    if (calendar[otherIndex].start!.isAfter(event.availabilityEnd)) {
      return false;
    }
  }
}
