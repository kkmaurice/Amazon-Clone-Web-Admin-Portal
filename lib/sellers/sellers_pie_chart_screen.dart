import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class SellersPieChartScreen extends StatefulWidget {
  const SellersPieChartScreen({super.key});

  @override
  State<SellersPieChartScreen> createState() => _SellersPieChartScreenState();
}

class _SellersPieChartScreenState extends State<SellersPieChartScreen> {
  int totalNumberOfVerifiedSellers = 0;
  int totalNumberOfBlockedSellers = 0;

  getTotalNumberOfVerifiedSellers() async {
    // get all verified users from the database
    FirebaseFirestore.instance
        .collection('sellers')
        .where('status', isEqualTo: 'approved')
        .get()
        .then((varifiedSellers) {
      setState(() {
        totalNumberOfVerifiedSellers = varifiedSellers.docs.length;
      });
    });
  }

  getTotalNumberOfBlockedSellers() async {
    // get all blocked users from the database
    FirebaseFirestore.instance
        .collection('sellers')
        .where('status', isEqualTo: 'blocked')
        .get()
        .then((blockedSellers) {
      setState(() {
        totalNumberOfBlockedSellers = blockedSellers.docs.length;
      });
    });
  }

  @override
  void initState() {
    getTotalNumberOfVerifiedSellers();
    getTotalNumberOfBlockedSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: 'Sellers Pie Chart'),
      body: DChartPie(
        data: [
          {'domain': 'Blocked Sellers', 'measure': totalNumberOfBlockedSellers},
          {
            'domain': 'Verified Sellers',
            'measure': totalNumberOfVerifiedSellers
          },
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
