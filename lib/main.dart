import 'package:flutter/material.dart';
import 'package:localstorageassignment/homeView.dart';

void main(){
  runApp(const LocalStorageAssignment());
}

class LocalStorageAssignment extends StatefulWidget {
  const LocalStorageAssignment({super.key});

  @override
  State<LocalStorageAssignment> createState() => _LocalStorageAssignmentState();
}

class _LocalStorageAssignmentState extends State<LocalStorageAssignment> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
