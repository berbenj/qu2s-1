import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firedart/firedart.dart' as fd;
// import 'package:cloud_firestore/cloud_firestore.dart' as fs;

import '../q2_platform.dart';

Q2Platform q2Platform = Q2Platform();

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String id = '';

  void callback(String id) {
    setState(() {
      this.id = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: TasksList(callback, id)),
        const VerticalDivider(width: 1, color: Color.fromARGB(255, 60, 60, 60)),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TaskDetail(callback, id),
                ),
              ),
              const Divider(height: 1, color: Color.fromARGB(255, 60, 60, 60)),
              Expanded(child: eventsList()),
            ],
          ),
        )
      ],
    );
  }

  Widget eventsList() {
    return const Column(
      children: [],
    );
  }
}

class TasksList extends StatefulWidget {
  final Function callback;
  final String id;

  const TasksList(
    this.callback,
    this.id, {
    super.key,
  });

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final auth = fd.FirebaseAuth.instance;
  final taskName = TextEditingController();

  Future<List<fd.Document>> getTasks(fd.CollectionReference ref) {
    return ref.orderBy('title').get();
  }

  @override
  Widget build(BuildContext context) {
    fd.CollectionReference tasksCollection = fd.Firestore.instance.collection('tasks/${auth.userId}/tasks');

    // idea: remove this hack: of having a FutureBuilder in a StreamBbuilder
    return StreamBuilder(
      stream: tasksCollection.stream,
      builder: (c, s) {
        return FutureBuilder(
          future: getTasks(tasksCollection),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            widget.callback('add');
                          });
                        },
                        child: const Text('Add task')),
                  ),
                ),
                for (var i in snapshot.data!)
                  ListTile(
                    title: Text(i['title']),
                    tileColor: i.id == widget.id ? const Color.fromARGB(50, 255, 255, 255) : null,
                    onTap: () {
                      setState(() {
                        widget.callback(i.id);
                      });
                    },
                  )
              ]);
            } else {
              return ListView(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            widget.callback('add');
                          });
                        },
                        child: const Text('Add task')),
                  ),
                )
              ]);
            }
          },
        );
      },
    );
  }
}

class TaskDetail extends StatefulWidget {
  final String id;
  final Function callback;

  const TaskDetail(
    this.callback,
    this.id, {
    super.key,
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final auth = fd.FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  var title = TextEditingController();
  var description = TextEditingController();
  DateTime startDateTime = DateTime.now();
  var startDate = TextEditingController();
  var startTime = TextEditingController();
  DateTime endDateTime = DateTime.now();
  var endDate = TextEditingController();
  var endTime = TextEditingController();
  var lengthInMinutes = TextEditingController();
  var repeating = false;
  var repeateEveryXHour = TextEditingController();
  var numOfEvents = TextEditingController();
  var priority = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    // idea: plase make the paths better looking, pls
    fd.CollectionReference taskCollection = fd.Firestore.instance.collection('tasks/${auth.userId}/tasks');
    fd.CollectionReference eventCollection = fd.Firestore.instance.collection('events/${auth.userId}/events');
    fd.DocumentReference eventDoc = fd.Firestore.instance.document('events/${auth.userId}');

    List<String> data = widget.id.split(';');
    if (data[0] == 'add') {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: title,
                decoration: const InputDecoration(icon: Icon(Icons.title), labelText: 'Title'),
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Please provide a title';
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                  controller: description,
                  minLines: 1,
                  maxLines: 10,
                  decoration: const InputDecoration(icon: Icon(Icons.description), labelText: 'Description'),
                  validator: (value) {
                    return null;
                  }),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: startDate,
                      decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: 'Start date'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: startDateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        setState(() {
                          if (pickedDate != null) {
                            startDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                                startDateTime.hour, startDateTime.minute, 0, 0, 0);
                            startDate.text = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a date';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: startTime,
                      decoration: const InputDecoration(icon: Icon(Icons.access_time), labelText: 'Start time'),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime =
                            await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(startDateTime));
                        setState(() {
                          if (pickedTime != null) {
                            startDateTime = DateTime(startDateTime.year, startDateTime.month, startDateTime.day,
                                pickedTime.hour, pickedTime.minute, 0, 0, 0);
                            startTime.text = '${pickedTime.hour}:${pickedTime.minute}';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a time';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: endDate,
                      decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: 'End date'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: endDateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101));
                        setState(() {
                          if (pickedDate != null) {
                            endDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, endDateTime.hour,
                                endDateTime.minute, 0, 0, 0);
                            endDate.text = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a date';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: endTime,
                      decoration: const InputDecoration(icon: Icon(Icons.access_time), labelText: 'End time'),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime =
                            await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(endDateTime));
                        setState(() {
                          if (pickedTime != null) {
                            endDateTime = DateTime(endDateTime.year, endDateTime.month, endDateTime.day,
                                pickedTime.hour, pickedTime.minute, 0, 0, 0);
                            endTime.text = '${pickedTime.hour}:${pickedTime.minute}';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a time';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: lengthInMinutes,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(icon: Icon(Icons.timelapse), labelText: 'Length (in minutes)'),
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Please provide a length';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: numOfEvents,
                      decoration: const InputDecoration(icon: Icon(Icons.numbers_sharp), labelText: 'Number of events'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                        value: repeating,
                        title: const Text('Repeateing task'),
                        checkColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            repeating = value!;
                          });
                        }),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: repeateEveryXHour,
                      decoration: const InputDecoration(icon: Icon(Icons.repeat), labelText: 'repeate every (hour)'),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: priority,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.priority_high), labelText: 'priority (bigger number bigger priority)'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(child: Center()),
                ],
              ),
              const SizedBox(height: 30),
              OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var num = int.tryParse(numOfEvents.text);
                      num ??= 1;
                      var eventIds = <String>[];
                      for (var i = 0; i < num; i++) {
                        var event = await eventCollection.add({
                          'title': title.text,
                          'description': description.text,
                          'minStartDateTime': startDateTime,
                          'maxEndDateTime': endDateTime,
                          'startDateTime': null,
                          'endDateTime': null,
                          'lengthInMinutes': int.parse(lengthInMinutes.text),
                          'repeating': repeating,
                          'done': false,
                          'lastDone': null,
                          'repeateEveryXHour':
                              repeateEveryXHour.text.isEmpty ? null : int.parse(repeateEveryXHour.text),
                          'priority': int.parse(priority.text),
                        });
                        eventIds.add(event.id);
                      }
                      await taskCollection.add({
                        'title': title.text,
                        'description': description.text,
                        'startDateTime': startDateTime,
                        'endDateTime': endDateTime,
                        'lengthInMinutes': int.parse(lengthInMinutes.text),
                        'repeating': repeating,
                        'events': eventIds,
                        'priority': int.parse(priority.text),
                      });
                      await eventDoc.update({'needsReschedule': true});
                      setState(() {
                        title.clear();
                        description.clear();
                        startDateTime = DateTime.now();
                        startDate.clear();
                        startTime.clear();
                        endDateTime = DateTime.now();
                        endDate.clear();
                        endTime.clear();
                        lengthInMinutes.clear();
                        numOfEvents.clear();
                        repeating = false;
                        repeateEveryXHour.clear();
                        priority.clear();
                      });
                    }
                  },
                  child: const Text('Add task')),
            ],
          ),
        ),
      );
    } else if (data[0] == 'edit') {
      return FutureBuilder(
        future: taskCollection.document(data[1]).get(),
        builder: (c, s) {
          title.text = s.data!['title'];
          description.text = s.data!['description'];
          startDateTime = s.data!['startDateTime'];
          startDate.text = '${startDateTime.year}-${startDateTime.month}-${startDateTime.day}';
          startTime.text = '${startDateTime.hour}:${startDateTime.minute}';
          endDateTime = s.data!['endDateTime'];
          endDate.text = '${endDateTime.year}-${endDateTime.month}-${endDateTime.day}';
          endTime.text = '${endDateTime.hour}:${endDateTime.minute}';
          lengthInMinutes.text = s.data!['lengthInMinutes'].toString();
          numOfEvents.text = s.data!['events'].length.toString();
          if (numOfEvents.text == 'null') numOfEvents.text = '';
          repeating = s.data!['repeating'];
          repeateEveryXHour.text = s.data!['repeateEveryXHour'].toString();
          if (repeateEveryXHour.text == 'null') repeateEveryXHour.text = '';
          priority.text = s.data!['priority'].toString();
          if (priority.text == 'null') priority.text = '0';

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(icon: Icon(Icons.title), labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value == '') {
                        return 'Please provide a title';
                      } else {
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                      controller: description,
                      minLines: 1,
                      maxLines: 10,
                      decoration: const InputDecoration(icon: Icon(Icons.description), labelText: 'Description'),
                      validator: (value) {
                        return null;
                      }),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: startDate,
                          decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: 'Start date'),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: startDateTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              startDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                                  startDateTime.hour, startDateTime.minute, 0, 0, 0);
                              startDate.text = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                            }
                          },
                          validator: (value) {
                            if ((value == null || value == '') && !repeating) {
                              return 'Please provide a date';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: startTime,
                          decoration: const InputDecoration(icon: Icon(Icons.access_time), labelText: 'Start time'),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.fromDateTime(startDateTime));
                            if (pickedTime != null) {
                              startDateTime = DateTime(startDateTime.year, startDateTime.month, startDateTime.day,
                                  pickedTime.hour, pickedTime.minute, 0, 0, 0);
                              startTime.text = '${pickedTime.hour}:${pickedTime.minute}';
                            }
                          },
                          validator: (value) {
                            if ((value == null || value == '') && !repeating) {
                              return 'Please provide a time';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: endDate,
                          decoration: const InputDecoration(icon: Icon(Icons.calendar_today), labelText: 'End date'),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: endDateTime,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              endDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
                                  endDateTime.hour, endDateTime.minute, 0, 0, 0);
                              endDate.text = '${pickedDate.year}-${pickedDate.month}-${pickedDate.day}';
                            }
                          },
                          validator: (value) {
                            if ((value == null || value == '') && !repeating) {
                              return 'Please provide a date';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: endTime,
                          decoration: const InputDecoration(icon: Icon(Icons.access_time), labelText: 'End time'),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.fromDateTime(endDateTime));
                            if (pickedTime != null) {
                              endDateTime = DateTime(endDateTime.year, endDateTime.month, endDateTime.day,
                                  pickedTime.hour, pickedTime.minute, 0, 0, 0);
                              endTime.text = '${pickedTime.hour}:${pickedTime.minute}';
                            }
                          },
                          validator: (value) {
                            // todo: make sure this is after start datetime
                            if ((value == null || value == '') && !repeating) {
                              return 'Please provide a time';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: lengthInMinutes,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          decoration:
                              const InputDecoration(icon: Icon(Icons.timelapse), labelText: 'Length (in minutes)'),
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please provide a length';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: numOfEvents,
                          decoration:
                              const InputDecoration(icon: Icon(Icons.numbers_sharp), labelText: 'Number of events'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                            value: repeating,
                            title: const Text('Repeateing task'),
                            checkColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                repeating = value!;
                              });
                            }),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: repeateEveryXHour,
                          decoration:
                              const InputDecoration(icon: Icon(Icons.repeat), labelText: 'Repeate every (hour)'),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: priority,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.priority_high), labelText: 'priority (bigger number bigger priority)'),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(child: Center()),
                    ],
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton(
                      onPressed: () async {
                        // todo: edit all connected events
                        if (_formKey.currentState!.validate()) {
                          await taskCollection.document(data[1]).update({
                            'title': title.text,
                            'description': description.text,
                            'startDateTime': startDateTime,
                            'endDateTime': endDateTime,
                            'lengthInMinutes': int.parse(lengthInMinutes.text),
                            'priority': int.parse(priority.text),
                          });
                          var num = int.tryParse(numOfEvents.text);
                          num ??= 1;
                          var task = await taskCollection.document(data[1]).get();
                          List<dynamic> eventIds = task['events'];

                          while (eventIds.length > num) {
                            var id = eventIds.removeLast();
                            eventCollection.document(id).delete();
                          }
                          while (eventIds.length < num) {
                            var event = await eventCollection.add({
                              'title': title.text,
                              'description': description.text,
                              'minStartDateTime': startDateTime,
                              'maxEndDateTime': endDateTime,
                              'startDateTime': null,
                              'endDateTime': null,
                              'lengthInMinutes': int.parse(lengthInMinutes.text),
                              'repeating': repeating,
                              'done': false,
                              'lastDone': null,
                              'repeateEveryXHour':
                                  repeateEveryXHour.text.isEmpty ? null : int.parse(repeateEveryXHour.text),
                              'priority': int.parse(priority.text),
                            });
                            eventIds.add(event.id);
                          }
                          taskCollection.document(data[1]).update({'events': eventIds});

                          for (var i = 0; i < num; i++) {
                            var event = await eventCollection.document(eventIds[i]).get();
                            if (startDateTime != event['minStartDateTime'] ||
                                endDateTime != event['maxEndDateTime'] ||
                                int.parse(lengthInMinutes.text) != event['lengthInMinutes'] ||
                                repeating != event['repeating']) {
                              await eventCollection.document(eventIds[i]).update({
                                'title': title.text,
                                'description': description.text,
                                'minStartDateTime': startDateTime,
                                'maxEndDateTime': endDateTime,
                                'startDateTime': null,
                                'endDateTime': null,
                                'lengthInMinutes': int.parse(lengthInMinutes.text),
                                'repeating': repeating,
                                'repeateEveryXHour':
                                    repeateEveryXHour.text.isEmpty ? null : int.parse(repeateEveryXHour.text),
                                'done': false,
                                'priority': int.parse(priority.text),
                              });

                              await eventDoc.update({'needsReschedule': true});
                            } else {
                              await eventCollection.document(eventIds[i]).update({
                                'title': title.text,
                                'description': description.text,
                                'priority': int.parse(priority.text),
                              });
                            }
                          }

                          setState(() {
                            title.clear();
                            description.clear();
                            startDateTime = DateTime.now();
                            startDate.clear();
                            startTime.clear();
                            endDateTime = DateTime.now();
                            endDate.clear();
                            endTime.clear();
                            lengthInMinutes.clear();
                            numOfEvents.clear();
                            repeating = false;
                            repeateEveryXHour.clear();
                            priority.clear();
                          });
                          widget.callback(data[1]);
                        }
                      },
                      child: const Text('Edit task')),
                ],
              ),
            ),
          );
        },
      );
    }

    if (widget.id == '') {
      return const Center();
    } else {
      fd.DocumentReference taskRef = fd.Firestore.instance.document('tasks/${auth.userId}/tasks/${widget.id}');
      Future<fd.Document> task = taskRef.get();

      return FutureBuilder(
          future: task,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              fd.Document task = snapshot.data!;
              return ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                          onPressed: () async {
                            await eventCollection.document(snapshot.requireData['events'][0]).delete();
                            await taskCollection.document(widget.id).delete();
                            widget.callback('');
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete')),
                      const SizedBox(width: 20),
                      OutlinedButton.icon(
                          onPressed: () {
                            widget.callback('edit;${widget.id}');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    task['title'],
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    task['description'],
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Start time: ${task['startDateTime'].toString().substring(0, 16)}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'End time: ${task['endDateTime'].toString().substring(0, 16)}',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Length: ${task['lengthInMinutes']} minutes',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('Loading...'),
              );
            }
          });
    }
  }
}
