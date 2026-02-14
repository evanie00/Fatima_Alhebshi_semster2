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
      theme: ThemeData(
        primaryColor: Colors.pinkAccent[100], // اللون الأساسي
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.pinkAccent[100],
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: const HomeView(),
      ),
    );
  }
}
