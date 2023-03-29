import 'dart:async';

import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = "";
  String liveDate = "";
  String formatCurrentLiveTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formatCurrentLiveDate(DateTime time) {
    return DateFormat("dd MMMM, yyyy").format(time);
  }

  getCurrentLiveTimeDate() {
    DateTime now = DateTime.now();
    liveDate = formatCurrentLiveDate(now);
    liveTime = formatCurrentLiveTime(now);
    //return "$formattedDate $formattedTime";
    setState(() {
      liveTime;
      liveDate;
    });
  }

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTimeDate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                '$liveTime\n\n$liveDate',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 GestureDetector(
                  onTap: (){},
                  child: Image.asset('assets/images/verified_users.png',width: 200,)),
              
            const SizedBox(width: 200,),
            GestureDetector(
                  onTap: (){},
                  child: Image.asset('assets/images/blocked_users.png',width: 200,)),
                  
          ],
        ),
        const SizedBox(height: 20,),
        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 GestureDetector(
                  onTap: (){},
                  child: Image.asset('assets/images/verified_seller.png',width: 200,)),
              
            const SizedBox(width: 200,),
            GestureDetector(
                  onTap: (){},
                  child: Image.asset('assets/images/blocked_seller.png',width: 200,)),
                  
          ],
        ),
      ]))
    );
  }
}