import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/priority.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/services/priority.dart';
import 'package:jawad_basit_backend/services/task.dart';

class CreateTaskView extends StatefulWidget {
  CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  List<PriorityModel> prioritList = [];
  PriorityModel? _selectedPriority;

  @override
  void initState() {
    PriorityServices().getAllPriorities().then((val) {
      prioritList = val;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Task")),
      body: Column(
        children: [
          TextField(controller: titleController),
          TextField(controller: descriptionController),
          DropdownButton(
            items: prioritList.map((e) {
              return DropdownMenuItem(child: Text(e.name.toString()), value: e);
            }).toList(),
            isExpanded: true,
            hint: Text("Select Priority"),
            value: _selectedPriority,
            onChanged: (val) {
              _selectedPriority = val;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Title cannot be empty.")),
                      );
                      return;
                    }
                    if (descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Description cannot be empty.")),
                      );
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await TaskServices()
                          .createTask(
                            TaskModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              isCompleted: false,
                              priorityID: _selectedPriority!.docId.toString(),
                              createdAt: DateTime.now().millisecondsSinceEpoch,
                            ),
                          )
                          .then((val) {
                            isLoading = false;
                            setState(() {});
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Message"),
                                  content: Text(
                                    "Task has been created successfully",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Okay"),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Create Task"),
                ),
        ],
      ),
    );
  }
}
