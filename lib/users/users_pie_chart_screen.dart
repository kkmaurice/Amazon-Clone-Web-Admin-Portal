import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/nav_appbar.dart';

class UsersPieChartScreen extends StatefulWidget {
  const UsersPieChartScreen({super.key});

  @override
  State<UsersPieChartScreen> createState() => _SellersPieChartScreenState();
}

class _SellersPieChartScreenState extends State<UsersPieChartScreen> {

  int totalNumberOfVerifiedUsers = 0;
  int totalNumberOfBlockedUsers = 0;

  getTotalNumberOfVerifiedUsers() async {
    // get all verified users from the database
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((varifiedUsers) {
      setState(() {
        totalNumberOfVerifiedUsers = varifiedUsers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedUsers() async {
    // get all blocked users from the database
    FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'blocked')
        .get()
        .then((blockedUsers) {
      setState(() {
        totalNumberOfBlockedUsers = blockedUsers.docs.length;
      });
    });
  }

  @override
  void initState() {
    getTotalNumberOfVerifiedUsers();
    getTotalNumberOfBlockedUsers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: 'Users Pie Chart'),
      body: DChartPie(
      data: [
          {'domain': 'Blocked Users', 'measure': totalNumberOfBlockedUsers},
          {'domain': 'Verified Sellers', 'measure': totalNumberOfVerifiedUsers},
         
      ],
      fillColor: (pieData, index) {
          return index == 0 ? Colors.pinkAccent : Colors.deepPurpleAccent;
      },
      labelFontSize: 20,
      labelColor: Colors.white,
      strokeWidth: 6,
      pieLabel: (pieData, index) {
        return '${pieData['domain']}: ${pieData['measure']}';
      },
    ),
    );
  }
}