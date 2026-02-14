import 'package:flutter/material.dart';
import 'package:localstorageassignment/Note.dart';
import 'package:localstorageassignment/db/DBhelper.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeviewState();
}

class _HomeviewState extends State<HomeView> {
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
    );;
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
          title: const Text("إضافة ملاحظة", textDirection: TextDirection.rtl,),
          content: SizedBox(
            width: 350, // العرض المطلوب
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "العنوان",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // خط رمادي عادي
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    controller: contentController,
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      labelText: "الملاحظة",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // خط رمادي عادي
                      ),
                    ),
                    maxLines: 3,
                  ),
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

  void _updateNoteDialog(BuildContext context, Notes mynote) {
    final titleController = TextEditingController(text: mynote.title);
    final contentController = TextEditingController(text: mynote.contents);

    showDialog(
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("تعديل الملاحظة", textDirection: TextDirection.rtl,),
          content: SizedBox(
            width: 350, // العرض المطلوب
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: titleController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // خط رمادي عادي
                    ),
                  ),
                ),
                TextField(
                  textDirection: TextDirection.rtl,
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // خط رمادي عادي
                    ),
                  ),
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
              child: const Text("حفظ التعديلات", style: TextStyle(color: Colors.white),),
              onPressed: () async {
                var note = Notes(
                  id: mynote.id,
                  title: titleController.text,
                  contents: contentController.text,
                );
                await DatabaseHelper.db.updateNote(note);
                Navigator.of(ctx).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  createListView(BuildContext context, AsyncSnapshot<List<Notes>> snapshot) {
    var notes = snapshot.data!;
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        var note = notes[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow:[
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: Offset(0, 4)
              )
            ]
          ),
          child:
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.pinkAccent[100]?.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.sticky_note_2_outlined, color: Colors.pinkAccent[100],),
            ),
            title: Text(
              note.title?? "",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 4),
              child: Text(
                note.contents?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ) ,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    _updateNoteDialog(context, note);
                  },
                  icon: Icon(Icons.edit, size: 20),
                ),
                IconButton(
                  onPressed: () async {
                    await DatabaseHelper.db.deleteNote(note);
                    setState(() {});
                  },
                  icon: Icon(Icons.delete_outline, size: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


