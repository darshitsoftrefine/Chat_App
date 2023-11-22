import 'package:chat_app/constants/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TextEditingController phoneController = TextEditingController();
  //PhoneNumber number = PhoneNumber(isoCode: 'IN');
  TextEditingController otpController = TextEditingController();
  final TextEditingController controller = TextEditingController();
  String? vari;
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  bool otpCodeVisible = false;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
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
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                   vari = number.phoneNumber!;
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: const SelectorConfig(
                  leadingPadding: 19,
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: false,
                keyboardType:
                TextInputType.phone,
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
              //Expanded(child: SizedBox()),
              // InternationalPhoneNumberInput(
              //   onInputChanged: (number) {
              //     print("Hello ${number.phoneNumber}");
              //   },
              //   onInputValidated: (bool value) {
              //     print(value);
              //   },
              //   selectorConfig: const SelectorConfig(
              //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              //     setSelectorButtonAsPrefixIcon: true,
              //     leadingPadding: 20,
              //     useEmoji: true,
              //   ),
              //   ignoreBlank: false,
              //   autoValidateMode: AutovalidateMode.disabled,
              //   selectorTextStyle: TextStyle(color: Colors.black),
              //   initialValue: number,
              //   textFieldController: phoneController,
              //   formatInput: false,
              //   keyboardType:
              //   TextInputType.numberWithOptions(signed: true, decimal: true),
              //   inputBorder: OutlineInputBorder(),
              //   onSaved: (PhoneNumber number) {
              //     print('On Saved: $number');
              //   },
              // ),
          // IntlPhoneField(
          //   controller: phoneController,
          //   decoration: InputDecoration(
          //     labelText: 'Phone Number',
          //     border: OutlineInputBorder(
          //       borderSide: BorderSide(),
          //     ),
          //   ),
          //   languageCode: "en",
          //   onChanged: (phone) {
          //     phoneController = phone.completeNumber as TextEditingController;
          //     print(phone.completeNumber);
          //   },
          //   onCountryChanged: (country) {
          //     print('Country changed to: ' + country.name);
          //   },
          // ),
          // TextFormField(
          //   keyboardType: TextInputType.phone,
          //   style: const TextStyle(color: Colors.black),
          //   controller: ,
          //   decoration: InputDecoration(
          //     labelText: "Enter Phone Number",
          //     prefixIcon: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          //       margin: EdgeInsets.symmetric(horizontal: 6),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           GestureDetector(
          //             onTap: ()async{
          //               final code = await countryPicker.showPicker(context: context);
          //               setState(() {
          //                 countryCode = code;
          //               });
          //             },
          //             child: Row(
          //               children: [
          //                 Container(
          //                     child: countryCode!= null ?
          //                     countryCode?.flagImage : null),
          //                 SizedBox(width: 10,),
          //                 Container(
          //                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          //                   decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
          //                     child: Text(countryCode?.dialCode ?? "+1", style: TextStyle(color: Colors.white),)),
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //     hintText: 'Enter Phone Number',
          //     hintStyle: const TextStyle(color: Colors.grey),
          //     border: OutlineInputBorder(
          //       borderSide: BorderSide(
          //           color: Color(0xFF979797),
          //           style: BorderStyle.solid
          //       ),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: Color(0xFF979797),
          //         width: 1.0,
          //       ),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: BorderSide(
          //         color: Colors.black,
          //         width: 1.0,
          //       ),
          //     ),
          //   ),
          // ),
              const SizedBox(height: 20,),
              Visibility(
                visible: otpCodeVisible,
                  child: CustomField(label: "OTP", control: otpController, obs: false, hint: "Enter OTP")),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (BuildContext context, loading, Widget? child) {
                  return loading? const Center(child: CircularProgressIndicator()):
                  ElevatedButton(onPressed: (){
                    if(otpCodeVisible){
                      verifyCode();
                    } else {
                      verifyNumber();
                    }
                  }, child: Text(otpCodeVisible ? "Login":"Verify"));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  void verifyNumber(){
      var phoneUser = auth.verifyPhoneNumber(
          phoneNumber: vari,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential).then((value) {
              debugPrint("Successfully");
            });
          },
          verificationFailed: (FirebaseAuthException exception) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(exception.message.toString()), backgroundColor: Colors.red,));
          },
          codeSent: (String verificationID, int? token) {
            //PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text);
            verificationIDReceived = verificationID;
            otpCodeVisible = true;
            setState(() {

            });
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            debugPrint("ID Received $verificationID");
          });
  }
  Future<String?> verifyCode() async{
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationIDReceived,
          smsCode: otpController.text);

      await auth.signInWithCredential(credential).then((value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) =>
                HomeScreen()), (route) => false);
        otpCodeVisible = false;
      });
      return credential.verificationId;
    } on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()), backgroundColor: Colors.red,));
    }
    return null;
  }
}
