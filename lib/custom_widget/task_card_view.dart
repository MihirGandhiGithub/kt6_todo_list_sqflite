import 'package:flutter/material.dart';

import '../DBHelper.dart';

class pendingCardView extends StatelessWidget {
  final Function() onPressed;
  final Map<String, dynamic> taskData;

  const pendingCardView(
      {super.key, required this.taskData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    DateTime dateTimes = DateTime.parse(taskData['date_time']);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
          color: Colors.blueGrey.shade200,
          child: ListTile(
            trailing: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.done,
                size: 30,
                color: Colors.white,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: ClipRRect(
                // borderRadius:  BorderRadius.circular(50.0),
                child: Text(
                  "${taskData['id']}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            title: Text(
              taskData['name'],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text("${taskData['task_name']}"),
          )),
    );
  }
}
