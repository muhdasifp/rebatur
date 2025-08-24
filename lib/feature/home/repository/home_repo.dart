import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/http/http_helper.dart';
import 'package:machine_test/feature/home/model/class_model.dart';

import '../../../data/constant/api.dart';

final homeRepoProvider = Provider<HomeRepo>((ref) {
  final http = ref.watch(httpHelperProvider);
  return HomeRepo(http);
});

class HomeRepo {
  final HttpHelper _httpHelper;

  HomeRepo(this._httpHelper);

  Future<List> fetchStudents({int? page}) async {
    try {
      final res = await _httpHelper.get(Api.students);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        res['data'],
      );
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<ClassModel>> fetchClasses() async {
    try {
      final res = await _httpHelper.get(Api.classes);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        res['data'],
      );
      return data.map((e) => ClassModel.fromJson(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> createStudent({
    File? file,
    required Map<String, String> body,
  }) async {
    try {
      await _httpHelper.postWithFile(Api.students, file: file, fields: body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateStudent({
    required int id,
    File? file,
    required Map<String, String> body,
  }) async {
    try {
      await _httpHelper.postWithFile(
        '${Api.updateStudent}/$id',
        file: file,
        fields: body,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteStudent({required int id}) async {
    try {
      await _httpHelper.delete('${Api.deleteStudent}/$id');
    } catch (e) {
      throw e.toString();
    }
  }
}
