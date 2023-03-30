import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedSellersScreen extends StatefulWidget {
  const VerifiedSellersScreen({super.key});

  @override
  State<VerifiedSellersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<VerifiedSellersScreen> {
  QuerySnapshot? allVerifiedSellers;

  getAllVerifiedSellers() async {
    // get all verified users from the database
    FirebaseFirestore.instance
        .collection('sellers')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((validSellers) {
      setState(() {
        allVerifiedSellers = validSellers;
      });
    });
  }

  @override
  void initState() {
    getAllVerifiedSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showDialogBox(userDocumentId) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Block Seller'),
              content:
                  const Text('Are you sure you want to block this seller?'),
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
                          .collection('sellers')
                          .doc(userDocumentId)
                          .update({'status': 'blocked'}).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                        showResuableSnackBar(
                          context,
                          'Seller Blocked Successfully',
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
      if (allVerifiedSellers == null) {
        return const Center(
          child: Text(
            'No records found',
            style: TextStyle(fontSize: 30, color: Colors.black),
          ),
        );
      } else {
        return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: allVerifiedSellers!.docs.length,
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
                              image: NetworkImage(allVerifiedSellers!
                                  .docs[index]
                                  .get('photoUrl')),
                            )),
                      ),
                    ),
                    Text(
                      allVerifiedSellers!.docs[index].get('name'),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      allVerifiedSellers!.docs[index].get('email'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // block now
                        GestureDetector(
                          onTap: () {
                            // block the user
                            showDialogBox(allVerifiedSellers!.docs[index].id);
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
                        ),

                        // earnings
                        GestureDetector(
                          onTap: () {
                            showResuableSnackBar(context, 'Earnings  = '.toUpperCase() +
                                allVerifiedSellers!.docs[index].get('earning').toString());
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/earnings.png',
                                  width: 56,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    '\$ ${allVerifiedSellers!.docs[index].get('earning')}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
      }
    }

    return Scaffold(
        //backgroundColor: Colors.black,
        appBar: NavAppBar(title: 'Verified Sellers Account'),
        body: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: verifiedUsersDesign()),
        ));
  }
}
