import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/services/task.dart';
import 'package:jawad_basit_backend/views/create_task.dart';
import 'package:jawad_basit_backend/views/get_completed_task.dart';
import 'package:jawad_basit_backend/views/get_in_completed_task.dart';
import 'package:provider/provider.dart';

class GetAllTaskView extends StatelessWidget {
  const GetAllTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetCompletedTask()),
              );
            },
            icon: Icon(Icons.circle),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetInCompletedTask()),
              );
            },
            icon: Icon(Icons.incomplete_circle),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateTaskView()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamProvider.value(
        value: TaskServices().getAllTask(),
        initialData: [TaskModel()],
        builder: (context, child) {
          List<TaskModel> taskList = context.watch<List<TaskModel>>();
          return ListView.builder(
            itemCount: taskList.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskList[i].title.toString()),
                subtitle: Text(taskList[i].description.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
