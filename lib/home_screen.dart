import 'package:flutter/material.dart';
import 'add_data_page.dart';
import 'custom_widget/task_card_view.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> pendingTaskData = [];
  List<Map<String, dynamic>> completeTaskData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final pendinglRows = await dbHelper.queryPendingRows();
    final completeRows = await dbHelper.queryCompleteRows();
    setState(() {
      pendingTaskData = pendinglRows;
      completeTaskData = completeRows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.blueGrey,
            title: const Text(
              'Todo List',
              style: TextStyle(color: Colors.white),
            ),
            bottom: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black38,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(icon: Text('Pending')),
                Tab(icon: Text('Complete')),
              ],
            ),
          ),
          floatingActionButton: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddDataPage()));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              )),
          body: TabBarView(
            children: [
              Container(color: Colors.blueGrey.shade100, child: pendingList()),
              completeList()
            ],
          )),
    );
  }

  Widget pendingList() {
    return ListView.builder(
        itemCount: pendingTaskData.length,
        itemBuilder: (BuildContext context, int index) {
          return pendingCardView(
            taskData: pendingTaskData[index],
            onPressed: () async {
              int id = pendingTaskData[index]['id'];
              // Call the method to update status to 'complete' for the specified ID
              await dbHelper.updateStatusComplete(id);
              await fetchData();
            },
          );
        });
  }

  Widget completeList() {
    return ListView.builder(
        itemCount: completeTaskData.length,
        itemBuilder: (BuildContext context, int index) {
          return pendingCardView(
            taskData: completeTaskData[index],
            onPressed: () {},
          );
        });
    return Text('hi');
  }
}
