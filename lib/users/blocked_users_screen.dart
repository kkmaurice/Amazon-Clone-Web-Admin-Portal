import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<BlockedUsersScreen> {
  QuerySnapshot? allBlockedUsers;

  getAllBlockedUsers() async {
    // get all verified users from the database
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'blocked')
        .get()
        .then((blockedUsers) {
      setState(() {
        allBlockedUsers = blockedUsers;
      });
    });
  }

  @override
  void initState() {
    getAllBlockedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDialogBox(userDocumentId) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Activate User'),
              content:
                  const Text('Are you sure you want to activate this user?'),
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
                          .update({'status': 'approved'}).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                        showResuableSnackBar(
                          context,
                          'User Activated Successfully',
                        );
                        //getAllVerifiedUsers();
                      });
                    },
                    child: const Text('Yes')),
              ],
            );
          });
    }

    Widget blockedUsersDesign() {
      if (allBlockedUsers == null) {
        return const Center(
          child: Text(
            'No records found',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allBlockedUsers!.docs.length,
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
                              image: NetworkImage(
                                  allBlockedUsers!.docs[index].get('photoUrl')),
                            )),
                      ),
                    ),
                    Text(
                      allBlockedUsers!.docs[index].get('name'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      allBlockedUsers!.docs[index].get('email'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        // block the user
                        showDialogBox(allBlockedUsers!.docs[index].id);
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
                            const Text('Activate Now',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
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
        appBar: NavAppBar(title: 'Blocked Users Account'),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: blockedUsersDesign()),
        ));
  }
}
