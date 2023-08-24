import 'package:chat_app/constants/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../verify_code.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController otpController = TextEditingController();
  bool otp = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Login Page"),
        actions: [
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 34, right: 34, bottom: 10),
          child: Column(
            children: [
              Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(height: 20,),
              //Expanded(child: SizedBox()),
              CustomField(label: 'Phone Number', control: phoneController, obs: false, hint: 'Enter Phone Number'),
              SizedBox(height: 20,),
              Visibility(
                visible: otp,
                  child: CustomField(label: "OTP", control: otpController, obs: false, hint: "Enter OTP")),
              ElevatedButton(onPressed: (){
                auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                    verificationCompleted: (PhoneAuthCredential credential) async{
                      await auth.signInWithCredential(credential).then((value) => {
                        print("Successfully")
                      });
                    },
                    verificationFailed: (e){
                    print(e);
                    },
                    codeSent: (String verification, int? token){

                    verificationID =  verification;
                    otp = true;
                    setState(() {

                    });
                    },
                    codeAutoRetrievalTimeout: (String verification){
                    print(verification);
                    });
              }, child: Text(otp ? "Login":"Verify"))
            ],
          ),
        ),
      ),
    );
  }
}
