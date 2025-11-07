import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/priority.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/services/priority.dart';
import 'package:jawad_basit_backend/services/task.dart';

class CreatePriorityTask extends StatefulWidget {
  final PriorityModel model;
  final bool isUpdateMode;
  CreatePriorityTask({super.key,
    required this.model, required this.isUpdateMode});

  @override
  State<CreatePriorityTask> createState() => _CreatePriorityTaskState();
}

class _CreatePriorityTaskState extends State<CreatePriorityTask> {
  TextEditingController nameController = TextEditingController();

  bool isLoading = false;
  @override
  void initstate(){
    if(widget.isUpdateMode == true){
      nameController = TextEditingController(
        text: widget.model.name.toString()
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isUpdateMode ?"Update Task" : "Create Task")),
      body: Column(
        children: [
          TextField(controller: nameController),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Title cannot be empty.")),
                );
                return;
              }
              try {
                isLoading = true;
                setState(() {});
                if(widget.isUpdateMode) {
                  await PriorityServices()
                      .updatePriority(
                    PriorityModel(
                      name: nameController.text.toString(),
                      docId: widget.model.docId.toString(),
                      createdAt: DateTime
                          .now()
                          .millisecondsSinceEpoch,
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
                            widget.isUpdateMode ?
                            "Task has been Update successfully" :
                            "Task has been Created Successfully",
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
                }else{
                  await PriorityServices()
                      .createPriority(
                    PriorityModel(
                      name: nameController.text.toString(),
                      createdAt: DateTime.now().millisecondsSinceEpoch,
                    )
                  ).then((val) {
                    isLoading = false;
                    setState(() {});
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Message"),
                          content: Text(
                            widget.isUpdateMode ?
                            "Task has been Update successfully" :
                            "Task has been Created Successfully",
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
                }
              } catch (e) {
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            child: Text(widget.isUpdateMode == true
            ?"Update Task":
                "Create Task"
            ),
          ),
        ],
      ),
    );
  }
}
