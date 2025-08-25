import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/feature/home/provider/student_list_provider.dart';
import 'package:machine_test/feature/home/repository/home_repo.dart';

final deleteStudentProvider =
    StateNotifierProvider<DeleteStudentNotifier, DeleteStudentState>((ref) {
      final homeRepo = ref.read(homeRepoProvider);
      return DeleteStudentNotifier(homeRepo, ref);
    });

class DeleteStudentNotifier extends StateNotifier<DeleteStudentState> {
  final HomeRepo _homeRepo;
  final Ref ref;
  DeleteStudentNotifier(this._homeRepo, this.ref)
    : super(DeleteStudentInitial());

  Future<void> deleteStudent({required int id}) async {
    try {
      state = DeleteStudentLoading();
      await _homeRepo.deleteStudent(id: id);
      ref.read(studentListProvider.notifier).fetchStudents();
      state = DeleteStudentSuccess();
    } catch (e) {
      state = DeleteStudentError(message: e.toString());
    }
  }
}

abstract class DeleteStudentState {}

class DeleteStudentInitial extends DeleteStudentState {}

class DeleteStudentLoading extends DeleteStudentState {}

class DeleteStudentSuccess extends DeleteStudentState {}

class DeleteStudentError extends DeleteStudentState {
  final String message;

  DeleteStudentError({required this.message});
}
