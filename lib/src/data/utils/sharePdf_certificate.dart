import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';

Future<void> savePdf(Uint8List pdfBytes, String fileName) async {
  final downloadsDir = Directory('/Download');
  final path = await FileSaver.instance.saveFile(
    name: fileName,
    bytes: pdfBytes,
    fileExtension: "pdf",
    mimeType: MimeType.other, 
    customMimeType: "application/pdf", 
    filePath: "/storage/emulated/0/Download/",
  );

  print("PDF saved at: $path");
}
