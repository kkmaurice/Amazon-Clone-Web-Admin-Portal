import 'package:admin_web_portal/widgets/nav_appbar.dart';
import 'package:flutter/material.dart';

class VerifiedUsersScreen extends StatefulWidget {
  const VerifiedUsersScreen({super.key});

  @override
  State<VerifiedUsersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<VerifiedUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: NavAppBar(title: 'Verified Users Account'),
        body: const Placeholder());
  }
}