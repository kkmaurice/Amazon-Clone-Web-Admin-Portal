import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedUsersScreen extends StatefulWidget {
  const VerifiedUsersScreen({super.key});

  @override
  State<VerifiedUsersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<VerifiedUsersScreen> {
  QuerySnapshot? allVerifiedUsers;

  getAllVerifiedUsers() async {
    // get all verified users from the database
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((validUsers) {
      setState(() {
        allVerifiedUsers = validUsers;
      });
    });
  }

  @override
  void initState() {
    getAllVerifiedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    showDialogBox(userDocumentId) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Block User'),
              content: const Text('Are you sure you want to block this user?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      // block the user
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userDocumentId)
                          .update({'status': 'blocked'}).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                        showResuableSnackBar(
                          context,
                          'User Blocked Successfully',
                        );
                        //getAllVerifiedUsers();
                      });
                    },
                    child: const Text('Yes')),
              ],
            );
          });
    }

    Widget verifiedUsersDesign() {
      if (allVerifiedUsers == null) {
        return const Center(
          child: Text(
            'No records found',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allVerifiedUsers!.docs.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 140,
                        width: 180,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(allVerifiedUsers!.docs[index]
                                  .get('photoUrl')),
                            )),
                      ),
                    ),
                    Text(
                      allVerifiedUsers!.docs[index].get('name'),
                      style: const TextStyle(
                          fontSize: 20,),
                    ),
                    Text(
                      allVerifiedUsers!.docs[index].get('email'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        // block the user
                        showDialogBox(allVerifiedUsers!.docs[index].id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/block.png',
                              width: 56,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('Block Now',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      }
    }

    return Scaffold(
        //backgroundColor: Colors.black,
        appBar: NavAppBar(title: 'Verified Users Account'),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: verifiedUsersDesign()),
        ));
  }
}
