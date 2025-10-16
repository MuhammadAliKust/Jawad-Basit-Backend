import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/priority.dart';
import 'package:jawad_basit_backend/services/priority.dart';

class CreatePriorityView extends StatefulWidget {
  final PriorityModel model;
  final bool isUpdateMode;

  const CreatePriorityView({
    super.key,
    required this.model,
    required this.isUpdateMode,
  });

  @override
  State<CreatePriorityView> createState() => _CreatePriorityViewState();
}

class _CreatePriorityViewState extends State<CreatePriorityView> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isUpdateMode == true) {
      nameController = TextEditingController(
        text: widget.model.name.toString(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdateMode ? "Update Task" : "Create Priority"),
      ),
      body: Column(
        children: [
          TextField(controller: nameController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Name cannot be empty.")),
                );
                return;
              }
              try {
                isLoading = true;
                setState(() {});
                if (widget.isUpdateMode) {
                  await PriorityServices()
                      .updatePriority(
                        PriorityModel(
                          name: nameController.text,
                          docId: widget.model.docId,
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      )
                      .then((val) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Message"),
                              content: Text(
                                widget.isUpdateMode
                                    ? "Priority has been updated successfully"
                                    : "Priority has been created successfully",
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
                } else {
                  await PriorityServices()
                      .createPriority(
                        PriorityModel(
                          name: nameController.text,
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      )
                      .then((val) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Message"),
                              content: Text(
                                widget.isUpdateMode
                                    ? "Priority has been updated successfully"
                                    : "Priority has been created successfully",
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
            child: Text(
              widget.isUpdateMode == true
                  ? "Update Priority"
                  : "Create Priority",
            ),
          ),
        ],
      ),
    );
  }
}
