import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawad_basit_backend/models/task.dart';
import 'package:jawad_basit_backend/models/users.dart';

class UserServices{
  String userCollection  = "UserCollection";
  //createUser

  Future createUser(UserModel model) async{
    return await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(model.docId)
        .set(model.toJson(model.docId.toString()));
  }
  //updateUser
    Future updateUser(UserModel model)async{
    return await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(model.docId)
        .update({
      "name": model.name,
      "phone":model.phone,
      "address":model.address});
    }
  //getUserByID
  Future<UserModel> getUserByID(String userID)async{
    return await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(userID)
        .get()
        .then((val){
          return UserModel.fromJson(val.data()!);
    });
  }
}