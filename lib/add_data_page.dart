import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DBHelper.dart';
import 'home_screen.dart';
import 'main.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDateTime = DateTime.now();
  TextEditingController name = TextEditingController();
  TextEditingController task_name = TextEditingController();
  TextEditingController disc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
          icon: const Icon(Icons.arrow_back_sharp),
        ),
        title: const Text('Add Details'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  name.clear();
                  task_name.clear();
                  disc.clear();
                  selectedDateTime = DateTime.now();
                },
                icon: const Text(
                  'cancel',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter Name',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                //Task Name
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: task_name,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter Task Name',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter text';
                      }
                      return null;
                    },
                  ),
                ),
                //Discription
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: disc,
                    maxLines: 5,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(),
                      ),
                      labelText: 'Enter Task Name',
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter text';
                      }
                      return null;
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Date'),
                    Text(
                      '${selectedDateTime.day}-${selectedDateTime.month}-${selectedDateTime.year}\n At \n${selectedDateTime.hour}:${selectedDateTime.minute}:${selectedDateTime.second}',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDateTime = DateTime.now();
                        });
                      },
                      child: const Text('Today'),
                    ),
                    ElevatedButton(
                      onPressed: _selectDateTime,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // row to insert
                        Map<String, dynamic> row = {
                          DatabaseHelper.name: name.text,
                          DatabaseHelper.taskName: task_name.text,
                          DatabaseHelper.taskDisc: disc.text,
                          DatabaseHelper.dateTime: selectedDateTime.toString(),
                          DatabaseHelper.status: 'pending'
                        };
                        final id = await dbHelper.insert(row);
                        debugPrint('inserted row id: $id');
                        name.clear();
                        task_name.clear();
                        disc.clear();
                        selectedDateTime = DateTime.now();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('data Inserted sucssfully')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (selectedTime == null) return;

    setState(() {
      selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }
}
