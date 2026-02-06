import 'package:flutter/material.dart';
import 'package:localstorageassignment/Note.dart';
import 'package:localstorageassignment/db/DBhelper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ملاحظاتي", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: getNotes(),
      floatingActionButton: _buildButton(context),
    );
  }

  getNotes() {
    return FutureBuilder<List<Notes>>(
      future: _getdata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد ملاحظات"));
        }
        return createListView(context, snapshot);
      },
    );
  }

  Future<List<Notes>> _getdata() async {
    var dbHelper = DatabaseHelper.db;
    return await dbHelper.getNotes();
  }

  _buildButton(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child:FloatingActionButton(
        backgroundColor: Colors.pinkAccent[100],
        child: const Icon(Icons.add, size: 35,color: Colors.white,),
        shape: const CircleBorder(),
        onPressed: () {
          _showAddNoteDialog(context);
        },
      )
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("إضافة ملاحظة"),
          content: SizedBox(
            width: 350, // العرض المطلوب
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "العنوان"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "الملاحظة"),
                  maxLines: 3, // يخلي مربع الملاحظة أكبر
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("إلغاء", style: TextStyle(color: Colors.black87)),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent[100]),
              child: const Text("حفظ", style: TextStyle(color: Colors.white),),
              onPressed: () async {
                var note = Notes(
                  id: 0, // SQLite سيولّد الـ id تلقائياً
                  title: titleController.text,
                  contents: contentController.text,
                );
                await DatabaseHelper.db.insertNote(note);
                Navigator.of(ctx).pop();
                (context as Element).reassemble();
              },
            ),
          ],
        );
      },
    );
  }

  createListView(BuildContext context, AsyncSnapshot<List<Notes>> snapshot) {
    var notes = snapshot.data!;
    return ListView.separated(
      itemCount: notes.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        var note = notes[index];
        return ListTile(
          title: Text(note.title?? ""),
          subtitle: Text(note.contents?? ""),
        );
      },
    );
  }
}