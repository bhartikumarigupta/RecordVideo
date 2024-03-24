import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:my_app/otp.dart';
import 'otp.dart';

class phone extends StatefulWidget {
  const phone({Key? key}) : super(key: key);

  @override
  State<phone> createState() => _phoneState();
}

class _phoneState extends State<phone> {
  TextEditingController countrycode = TextEditingController();
  var phoneno = '';
  bool loading = false;
  @override
  void initState() {
    countrycode.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "If Verification Fails Then it Might be Due to firebase limitation reached this can only be solved by uploading it to playstore and then it will work fine. For Now Use ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text('This number: 1234567890 and OTP: 123456',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: size.height * 0.35,
                width: size.height * 0.35,
                child: Image.asset('assets/logo2.png'),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countrycode,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.grey,
                          fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          phoneno = value;
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "enter mobile number"),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // print("tapped");
                    setState(() {
                      loading = true;
                    });
                    if (phoneno.isEmpty || phoneno.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please enter phone number"),
                        ),
                      );
                      setState(() {
                        loading = false;
                      });
                      return;
                    }
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '${countrycode.text + phoneno}',
                      verificationCompleted: (PhoneAuthCredential credential) {
                        print("verification completed");
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("verification failed ${e.toString()}"),
                          ),
                        );

                        setState(() {
                          loading = false;
                        });
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => otp(
                                      verifyid: verificationId,
                                      Number: phoneno,
                                    )));

                        loading = false;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Time out Try again!"),
                          ),
                        );
                        setState(() {
                          loading = false;
                        });
                      },
                    );
                  },
                  child: loading == false
                      ? Text("next",
                          style: TextStyle(fontSize: 18, color: Colors.white))
                      : CircularProgressIndicator(
                          color: Colors.white,
                        ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 18, 94, 106),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
