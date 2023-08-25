import 'package:chat_app/constants/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController otpController = TextEditingController();
  bool otpCodeVisible = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Login Page"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 34, right: 34, bottom: 10),
          child: Column(
            children: [
              const Text("Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
              const SizedBox(height: 20,),
              //Expanded(child: SizedBox()),
              CustomField(label: 'Phone Number', control: phoneController, obs: false, hint: 'Enter Phone Number'),
              const SizedBox(height: 20,),
              Visibility(
                visible: otpCodeVisible,
                  child: CustomField(label: "OTP", control: otpController, obs: false, hint: "Enter OTP")),
              ElevatedButton(onPressed: (){
                if(otpCodeVisible){
                  verifyCode();
                } else {
                  verifyNumber();
                }
                verifyNumber();
              }, child: Text(otpCodeVisible ? "Login":"Verify"))
            ],
          ),
        ),
      ),
    );
  }
  void verifyNumber(){
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async{
          await auth.signInWithCredential(credential).then((value) {
            debugPrint("Successfully");
          });
        },
        verificationFailed: (FirebaseAuthException exception){
          debugPrint("Hello Failed ${exception.message}");
        },
        codeSent: (String verificationID, int? token){
          //PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);
          verificationIDReceived =  verificationID;
          otpCodeVisible = true;
          setState(() {

          });
        },
        codeAutoRetrievalTimeout: (String verificationID){
          debugPrint("ID Received $verificationID");
        });
  }
  void verifyCode() async{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived,
        smsCode: otpController.text);

    await auth.signInWithCredential(credential).then((value){
      debugPrint("Logged In Successfully");
    });
  }
}
