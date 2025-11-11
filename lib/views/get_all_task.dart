import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/services/task.dart';
import 'package:jawad_basit_backend/views/create_task.dart';
import 'package:jawad_basit_backend/views/get_completed_task.dart';
import 'package:jawad_basit_backend/views/get_in_completed_task.dart';
import 'package:jawad_basit_backend/views/priority/get_priority.dart';
import 'package:jawad_basit_backend/views/update_task.dart';
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
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GetPriorityView()),
              );
            },
            icon: Icon(Icons.category),
          ),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (taskList[i].favorite!.contains('1')) {
                          await TaskServices().removeFromFavorite(
                            taskID: taskList[i].docId.toString(),
                            userID: '1',
                          );
                        } else {
                          await TaskServices().addToFavorite(
                            taskID: taskList[i].docId.toString(),
                            userID: '1',
                          );
                        }
                      },
                      icon: Icon(
                        taskList[i].favorite!.contains('1')
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateTaskView(model: taskList[i]),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        try {
                          await TaskServices().deleteTask(taskList[i]).then((
                            val,
                          ) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Delete successfully")),
                            );
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                    Checkbox(
                      value: taskList[i].isCompleted,
                      onChanged: (val) async {
                        try {
                          await TaskServices()
                              .markTaskAsComplete(taskList[i], val!)
                              .then((val) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Task has been completed successfully",
                                    ),
                                  ),
                                );
                              });
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
