import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:ipaconnect/src/data/models/folder_model.dart';
import 'package:ipaconnect/src/data/services/api_service.dart';
import 'package:ipaconnect/src/data/services/snackbar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_api.g.dart';

@riverpod
FolderApiService folderApiService(Ref ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FolderApiService(apiService);
}

class FolderApiService {
  final ApiService _apiService;
  FolderApiService(this._apiService);

  Future<List<Folder>> getFolders({
    required String eventId,
    int? pageNo,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (pageNo != null) queryParams['pageNo'] = pageNo.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    String endpoint = '/folders/event/$eventId';
    if (queryParams.isNotEmpty) {
      endpoint += '?';
      endpoint +=
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    final response = await _apiService.get(endpoint);
    if (response.success && response.data != null) {
      final List data = response.data!['data'];
      return data.map((item) => Folder.fromJson(item)).toList();
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch folders',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch folders');
    }
  }

  Future<Folder> getFiles({
    required String folderId,
    String? type,
  }) async {
    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    String endpoint = '/folders/files/$folderId';
    if (queryParams.isNotEmpty) {
      endpoint += '?';
      endpoint +=
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    final response = await _apiService.get(endpoint);
    if (response.success && response.data != null) {
      return Folder.fromJson(response.data!['data']);
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to fetch files',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to fetch files');
    }
  }

  Future<Folder> addFilesToPublicFolder({
    required String eventId,
    required List<Map<String, dynamic>> files,
  }) async {
    final response = await _apiService.post('/folders/add-to-public-folder', {
      'event_id': eventId,
      'files': files,
    });
    if (response.success && response.data != null) {
      return Folder.fromJson(response.data!['data']);
    } else {
      SnackbarService().showSnackBar(response.message ?? 'Failed to add files',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to add files');
    }
  }

  Future<Folder> deleteFilesFromPublicFolder({
    required String eventId,
    required List<String> fileIds,
  }) async {
    final response =
        await _apiService.post('/folders/remove-from-public-folder', {
      'event_id': eventId,
      'file_ids': fileIds,
    });
    if (response.success && response.data != null) {
      return Folder.fromJson(response.data!['data']);
    } else {
      SnackbarService().showSnackBar(
          response.message ?? 'Failed to delete files',
          type: SnackbarType.error);
      throw Exception(response.message ?? 'Failed to delete files');
    }
  }
}

@riverpod
Future<List<Folder>> getFolders(Ref ref,
    {required String eventId, int? pageNo, int? limit}) async {
  final folderApiService = ref.watch(folderApiServiceProvider);
  return folderApiService.getFolders(
      eventId: eventId, pageNo: pageNo, limit: limit);
}

@riverpod
Future<Folder> getFiles(Ref ref,
    {required String folderId, String? type}) async {
  final folderApiService = ref.watch(folderApiServiceProvider);
  return folderApiService.getFiles(folderId: folderId, type: type);
}
