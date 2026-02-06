import 'db/consttants.dart';

class Notes {
  int? id;
  String? title, contents;

  Notes({this.id, this.title, this.contents});

  Map<String, dynamic> toJson() {
    return {
      noteTitle: title,
      noteContent: contents,
    };
  }

  Notes.fromJson(Map<String, dynamic> map)
      : id = map[noteId] as int?,
        title = map[noteTitle] as String?,
        contents = map[noteContent] as String?;
}