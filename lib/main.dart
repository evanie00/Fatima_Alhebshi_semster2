import 'package:exclproject/HandleWithExcel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final rowController = TextEditingController();
  final colController = TextEditingController();
  final valueController = TextEditingController();
  String msg = "";

  late HandleWithExcel myexcel;

  @override
  @override
  void initState() {
    super.initState();
    myexcel = HandleWithExcel();
  }

  void _writeCell() {
    int row = int.parse(rowController.text);
    int col = int.parse(colController.text);
    String value = valueController.text;

    myexcel.writeCell(row, col, value);

    setState(() {
      msg = "تم إدخال القيمة '$value' في الصف $row العمود $col";
    });
  }

  void _readCell() {
    int row = int.parse(rowController.text);
    int col = int.parse(colController.text);

    String? value = myexcel.readCell(row, col);

    setState(() {
      msg = "القيمة في الصف $row العمود $col هي: ${value ?? "فارغة"}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('first assignment'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: rowController,
              decoration: InputDecoration(labelText: "أدخل رقم الصف"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: colController,
              decoration: InputDecoration(labelText: "أدخل رقم العمود"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: valueController,
              decoration: InputDecoration(labelText: "القيمة (للإدخال فقط)"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _writeCell, child: Text("إدخال")),
                ElevatedButton(onPressed: _readCell, child: Text("قراءة")),
              ],
            ),
            SizedBox(height: 20),
            Text(msg, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}