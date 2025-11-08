import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawad_basit_backend/models/task.dart';

class TaskServices {
  String kTaskCollection = 'taskCollection';

  ///Create Task
  Future createTask(TaskModel model) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc();
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(docRef.id)
        .set(model.toJson(docRef.id));
  }

  ///Get All Task
  Stream<List<TaskModel>> getAllTask() {
    return FirebaseFirestore.instance
        .collection(kTaskCollection)
        .snapshots()
        .map(
          (taskList) => taskList.docs
              .map((taskJson) => TaskModel.fromJson(taskJson.data()))
              .toList(),
        );
  }

  ///Get Completed Task
  Stream<List<TaskModel>> getCompletedTask() {
    return FirebaseFirestore.instance
        .collection(kTaskCollection)
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map(
          (taskList) => taskList.docs
              .map((taskJson) => TaskModel.fromJson(taskJson.data()))
              .toList(),
        );
  }

  ///Get InCompleted Task
  Stream<List<TaskModel>> getInCompletedTask() {
    return FirebaseFirestore.instance
        .collection(kTaskCollection)
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map(
          (taskList) => taskList.docs
              .map((taskJson) => TaskModel.fromJson(taskJson.data()))
              .toList(),
        );
  }

  ///Update Task
  Future updateTask(TaskModel model) async {
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(model.docId)
        .update({"title": model.title, "description": model.description});
  }

  ///Delete Task
  Future deleteTask(TaskModel model) async {
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(model.docId)
        .delete();
  }

  ///Mark Task As Complete
  Future markTaskAsComplete(TaskModel model, bool isCompleted) async {
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(model.docId)
        .update({"isCompleted": isCompleted});
  }

  ///Bookmark/Favorite a Task
  ///Get Priority Task
  Stream<List<TaskModel>> getPriorityTask(String priorityID) {
    return FirebaseFirestore.instance
        .collection(kTaskCollection)
        .where('priorityID', isEqualTo: priorityID)
        .snapshots()
        .map(
          (taskList) => taskList.docs
              .map((taskJson) => TaskModel.fromJson(taskJson.data()))
              .toList(),
        );
  }

  ///Add to Favorite
  Future addToFavorite({required String taskID, required String userID}) async {
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(taskID)
        .update({
          'favorite': FieldValue.arrayUnion([userID]),
        });
  }

  ///Remove to Favorite
  Future removeFromFavorite({required String taskID, required String userID}) async {
    return await FirebaseFirestore.instance
        .collection(kTaskCollection)
        .doc(taskID)
        .update({
          'favorite': FieldValue.arrayRemove([userID]),
        });
  }
}
