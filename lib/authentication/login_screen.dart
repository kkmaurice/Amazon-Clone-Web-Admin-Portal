// ignore_for_file: unused_local_variable

import 'package:admin_web_portal/functions/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homeScreen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  void allowAdminToLogin() async {
    if (email.isEmpty || password.isEmpty) {
      showResuableSnackBar(context, 'Please fill all the fields');
    } else {
      User? currentAdmin;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        currentAdmin = value.user;
      }).catchError((error) {
        showResuableSnackBar(context, error.message);
      });

      // check if record exists in the database
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentAdmin!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          showResuableSnackBar(context, 'Welcome Admin');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          showResuableSnackBar(context, 'You are not an Admin');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/admin.png'),
                        TextField(
                          onChanged: (value) {
                            email = value;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2),
                              //
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white54, width: 2),
                              //
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2),
                              //
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white54, width: 2),
                              //
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showResuableSnackBar(context,
                                'Checking Credentials, Please Wait...');
                            allowAdminToLogin();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Login'),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
