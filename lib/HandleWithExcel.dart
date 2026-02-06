import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class HandleWithExcel {
  late String filePath;
  late Excel excel;
  late Sheet sheet;

  HandleWithExcel() {
    _initExcel();
  }

  Future<void> _initExcel() async {
    // نحصل على مجلد التطبيق
    Directory dir = await getApplicationDocumentsDirectory();
    filePath = "${dir.path}/myexcelfile.xlsx";

    File file = File(filePath);

    if (file.existsSync()) {
      var bytes = file.readAsBytesSync();
      excel = Excel.decodeBytes(bytes);
      sheet = excel['Sheet1'];
    } else {
      excel = Excel.createExcel();
      sheet = excel['Sheet1'];
      _saveFile();
    }
  }

  void writeCell(int row, int col, String value) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: col - 1,
      rowIndex: row - 1,
    ));
    cell.value = TextCellValue(value);
    _saveFile();
  }

  String? readCell(int row, int col) {
    var cell = sheet.cell(CellIndex.indexByColumnRow(
      columnIndex: col - 1,
      rowIndex: row - 1,
    ));
    return cell.value?.toString();
  }

  void _saveFile() {
    var fileBytes = excel.save();
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }
}