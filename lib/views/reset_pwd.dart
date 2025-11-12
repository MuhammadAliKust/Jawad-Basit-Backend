import 'package:flutter/material.dart';
import 'package:jawad_basit_backend/services/auth.dart';

class ResetPwdScreen extends StatefulWidget {
  const ResetPwdScreen({super.key});

  @override
  State<ResetPwdScreen> createState() => _ResetPwdScreenState();
}

class _ResetPwdScreenState extends State<ResetPwdScreen> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(children: [
        TextField(controller: emailController,),
        isLoading ? Center(child: CircularProgressIndicator(),)
        :
        ElevatedButton(onPressed: ()async{
          try{
            isLoading = true;
            setState(() {});
            await AuthServices().forgotPassword(emailController.text.toString())
                .then((val){
                  isLoading = false;
                  setState(() {});
                  showDialog(
                      context: context,
                    builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Link Send Sccessfully"),
                          actions: [
                            TextButton(onPressed: (){}, child: Text("Okay"))
                          ],
                        );
                    }, );
            });
          }catch(e){
            isLoading = false;
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));

          }
        }, child: Text("Send Code"))
      ],),
    );
  }
}
