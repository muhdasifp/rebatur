import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/feature/home/provider/student_list_provider.dart';
import 'package:machine_test/feature/home/repository/home_repo.dart';


final createStudentProvider = StateNotifierProvider<CreateStudentNotifier, CreateStudentState>((ref) {
  final homeRepo = ref.read(homeRepoProvider);
  return CreateStudentNotifier(homeRepo, ref);
});


class CreateStudentNotifier extends StateNotifier<CreateStudentState> {
  final HomeRepo _homeRepo;
  final Ref ref;
  CreateStudentNotifier(this._homeRepo, this.ref) : super(CreateStudentInitial());

  Future<void> createStudent({
    File? file,
    required Map<String, String> body,
  }) async {
    try {
      state = CreateStudentLoading();
      await _homeRepo.createStudent(file: file, body: body);
      ref.read(studentListProvider.notifier).fetchStudents();
      state = CreateStudentSuccess();
    } catch (e) {
      state = CreateStudentError(message: e.toString());
    }
  }
}

abstract class CreateStudentState {}

class CreateStudentInitial extends CreateStudentState {}

class CreateStudentLoading extends CreateStudentState {}

class CreateStudentSuccess extends CreateStudentState {}

class CreateStudentError extends CreateStudentState {
  final String message;

  CreateStudentError({required this.message});
}
