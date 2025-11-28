import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:ipaconnect/src/data/utils/globals.dart';
import 'package:path_provider/path_provider.dart';

Future<String> imageUpload(String imagePath) async {
  File imageFile = File(imagePath);
  Uint8List imageBytes = await imageFile.readAsBytes();
  print("Original image size: ${imageBytes.lengthInBytes / 1024} KB");

  // Check if the image is larger than 2 MB
  if (imageBytes.lengthInBytes > 2 * 1024 * 1024) {
    img.Image? image = img.decodeImage(imageBytes);
    if (image != null) {
      img.Image resizedImage =
          img.copyResize(image, width: (image.width * 0.5).toInt());
      imageBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80));
      print("Compressed image size: ${imageBytes.lengthInBytes / 1024} KB");

      // Save compressed image
      imageFile = await File(imagePath).writeAsBytes(imageBytes);
    }
  }

  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/upload'),
  );

  request.headers['x-api-key'] = apiKey;

  request.headers['Authorization'] = 'Bearer $token';

  request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = await response.stream.bytesToString();
    return extractImageUrl(responseBody);
  } else {
    var responseBody = await response.stream.bytesToString();
    log(responseBody.toString());
    throw Exception('Failed to upload image');
  }
}

String extractImageUrl(String responseBody) {
  final responseJson = jsonDecode(responseBody);
  log(name: "image upload response", responseJson.toString());
  return responseJson['data'];
}

Future<String> saveUint8ListToFile(Uint8List bytes, String fileName) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<String> documentUpload(String documentPath) async {
  File documentFile = File(documentPath);

  // Log document details for debugging
  log('=== DOCUMENT UPLOAD DEBUG INFO ===', name: 'DOCUMENT_UPLOAD_LOG');
  log('Document Path: $documentPath', name: 'DOCUMENT_UPLOAD_LOG');
  log('File exists: ${documentFile.existsSync()}', name: 'DOCUMENT_UPLOAD_LOG');
  log('File size: ${documentFile.lengthSync()} bytes',
      name: 'DOCUMENT_UPLOAD_LOG');

  if (documentFile.existsSync()) {
    final fileName = documentPath.split('/').last;
    log('File name: $fileName', name: 'DOCUMENT_UPLOAD_LOG');

    // Check if it's a PDF
    if (fileName.toLowerCase().endsWith('.pdf')) {
      log('File type: PDF', name: 'DOCUMENT_UPLOAD_LOG');
    } else {
      log('Warning: File is not a PDF', name: 'DOCUMENT_UPLOAD_LOG');
    }
  }

  final String baseUrl = dotenv.env['BASE_URL'] ?? '';
  final String apiKey = dotenv.env['API_KEY'] ?? '';

  final uploadUrl = '$baseUrl/upload';
  log('Upload URL: $uploadUrl', name: 'DOCUMENT_UPLOAD_LOG');
  log('API Key present: ${apiKey.isNotEmpty}', name: 'DOCUMENT_UPLOAD_LOG');
  log('Token present: ${token.isNotEmpty}', name: 'DOCUMENT_UPLOAD_LOG');

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(uploadUrl),
  );

  request.headers['x-api-key'] = apiKey;
  request.headers['Authorization'] = 'Bearer $token';

  log('Headers set: x-api-key, Authorization', name: 'DOCUMENT_UPLOAD_LOG');

  try {
    final multipartFile =
        await http.MultipartFile.fromPath('image', documentFile.path);
    request.files.add(multipartFile);
    log('Multipart file added: ${multipartFile.filename}',
        name: 'DOCUMENT_UPLOAD_LOG');

    var response = await request.send();
    log('Response status code: ${response.statusCode}',
        name: 'DOCUMENT_UPLOAD_LOG');
    log('Response headers: ${response.headers}', name: 'DOCUMENT_UPLOAD_LOG');

    var responseBody = await response.stream.bytesToString();
    log('Response body type: ${responseBody.runtimeType}',
        name: 'DOCUMENT_UPLOAD_LOG');
    log('Response body preview: ${responseBody.substring(0, responseBody.length < 200 ? responseBody.length : 200)}',
        name: 'DOCUMENT_UPLOAD_LOG');

    if (response.statusCode == 200) {
      // Check if response is HTML or JSON
      if (responseBody.trim().startsWith('<!DOCTYPE') ||
          responseBody.trim().startsWith('<html')) {
        log('ERROR: Received HTML response instead of JSON',
            name: 'DOCUMENT_UPLOAD_LOG');
        log('Full HTML response: $responseBody', name: 'DOCUMENT_UPLOAD_LOG');
        throw Exception(
            'Server returned HTML error page instead of JSON response');
      }

      try {
        return extractDocumentUrl(responseBody);
      } catch (e) {
        log('ERROR: Failed to parse JSON response: ${e.toString()}',
            name: 'DOCUMENT_UPLOAD_LOG');
        log('Raw response that failed to parse: $responseBody',
            name: 'DOCUMENT_UPLOAD_LOG');
        throw Exception('Invalid JSON response from server: ${e.toString()}');
      }
    } else {
      log('ERROR: Upload failed with status code ${response.statusCode}',
          name: 'DOCUMENT_UPLOAD_LOG');

      // Check if error response is HTML or JSON
      if (responseBody.trim().startsWith('<!DOCTYPE') ||
          responseBody.trim().startsWith('<html')) {
        log('Server returned HTML error page', name: 'DOCUMENT_UPLOAD_LOG');
        throw Exception(
            'Server error (${response.statusCode}): Internal Server Error. Please check server logs.');
      }

      try {
        final errorJson = jsonDecode(responseBody);
        log('Error response JSON: $errorJson', name: 'DOCUMENT_UPLOAD_LOG');
        throw Exception('Upload failed: ${errorJson.toString()}');
      } catch (e) {
        log('Failed to parse error response as JSON: $e',
            name: 'DOCUMENT_UPLOAD_LOG');
        throw Exception(
            'Upload failed (${response.statusCode}): $responseBody');
      }
    }
  } catch (e) {
    log('EXCEPTION during document upload: ${e.toString()}',
        name: 'DOCUMENT_UPLOAD_LOG');
    rethrow;
  } finally {
    log('=== DOCUMENT UPLOAD DEBUG END ===', name: 'DOCUMENT_UPLOAD_LOG');
  }
}

String extractDocumentUrl(String responseBody) {
  final responseJson = jsonDecode(responseBody);
  log(name: "document upload response", responseJson.toString());
  return responseJson['data'];
}
