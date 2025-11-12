import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/models/users.dart';
import 'package:jawad_basit_backend/services/auth.dart';
import 'package:jawad_basit_backend/services/users.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(children: [
        TextField(controller: nameController,),
        TextField(controller: emailController,),
        TextField(controller: passwordController,),
        TextField(controller: cpasswordController,),
        TextField(controller: phoneController,),
        TextField(controller: addressController,),
        isLoading? Center(child: CircularProgressIndicator(),):
        ElevatedButton(onPressed: ()async{
          try{
            isLoading = true;
            setState(() {});
            await AuthServices()
                .registerUser(
                email: emailController.text, password: passwordController.text)
                .then((val)async{
                  await UserServices().createUser(
                    UserModel(
                      docId: val.uid.toString(),
                      name: nameController.text.toString(),
                      email: emailController.text.toString(),
                      phone: phoneController.text.toString(),
                      address: addressController.text.toString(),
                      createdAt: DateTime.now().millisecondsSinceEpoch
                    )
                  );
                  isLoading = false;
                  setState(() {});
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("User Register Successfully"),
                        actions: [
                          TextButton(onPressed: (){}, child: Text("Okay"))
                        ],
                      );
                    }, );

            });
          }catch(e){
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(e.toString())));
          }
        }, child: Text("Register"))
      ],),
    );
  }
}
