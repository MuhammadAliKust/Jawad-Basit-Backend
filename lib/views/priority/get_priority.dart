import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/priority.dart';
import 'package:jawad_basit_backend/services/priority.dart';
import 'package:jawad_basit_backend/views/priority/create_priority.dart';
import 'package:provider/provider.dart';

class GetPriorityView extends StatefulWidget {
  const GetPriorityView({super.key});

  @override
  State<GetPriorityView> createState() => _GetPriorityViewState();
}

class _GetPriorityViewState extends State<GetPriorityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Get All Priorities")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePriorityView(
                model: PriorityModel(),
                isUpdateMode: false,
              ),
            ),
          ).then((val) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureProvider.value(
        value: PriorityServices().getAllPriorities(),
        initialData: [PriorityModel()],
        builder: (context, child) {
          List<PriorityModel> priorityList = context
              .watch<List<PriorityModel>>();
          return ListView.builder(
            itemCount: priorityList.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(Icons.category),
                title: Text(priorityList[i].name.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        try {
                          await PriorityServices()
                              .deletePriority(priorityList[i])
                              .then((val) {
                                setState(() {});
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Priority has been deleted."),
                                  ),
                                );
                              });
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatePriorityView(
                              model: priorityList[i],
                              isUpdateMode: true,
                            ),
                          ),
                        ).then((val) {
                          setState(() {});
                        });
                      },
                      icon: Icon(Icons.edit),
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
