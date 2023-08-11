class Event {
  String name;

  String id;

  // inclusive - exclusive
  DateTime availabilityStart, availabilityEnd;

  // inclusive - exclusive
  DateTime? start, end;

  Duration length;

  DateTime? lastTimeDone;
  bool repeating;
  int? repeateEveryXHour;
  int? numOfEvents;

  Event(this.id, this.name, this.availabilityStart, this.availabilityEnd, this.length, this.numOfEvents,
      this.lastTimeDone, this.repeating, this.repeateEveryXHour);
  // assert(length <= (availabilityEnd.difference(availabilityStart)));

  /// duration of witch this event can be shifted at max if it is placed at the start of it's awailability
  /// this value can not be negative
  Duration get flexibilty {
    var dur = (availabilityEnd.difference(availabilityStart)) - length;
    if (dur < Duration.zero) {
      return Duration.zero;
    }
    return dur;
  }
}
