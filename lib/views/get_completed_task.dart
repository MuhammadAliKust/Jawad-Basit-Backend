import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/services/task.dart';
import 'package:provider/provider.dart';

class GetCompletedTask extends StatelessWidget {
  const GetCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Completed Task"),
        backgroundColor: Colors.blue,
      ),
      body: StreamProvider.value(
          value: TaskServices().getCompletedTask(),
          initialData: [TaskModel()],
        builder: (context, child){
            List<TaskModel> taskList = context.watch<List<TaskModel>>();
            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (BuildContext context, int i) {
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
