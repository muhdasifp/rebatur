import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/feature/home/model/student_response_model.dart';
import 'package:machine_test/feature/home/repository/home_repo.dart';


final studentListProvider = StateNotifierProvider<StudentListNotifier,StudentListState >((ref) {
  return StudentListNotifier(ref.watch(homeRepoProvider));
});


class StudentListNotifier extends StateNotifier<StudentListState> {
  final HomeRepo repo;
  StudentListNotifier(this.repo) : super(StudentListInitial());

  Future<void> fetchStudents({int? page}) async {
    try {
      state = StudentListLoading();
      final res = await repo.fetchStudents(page: page);
      state = StudentListSuccess(data: res);
    } catch (e) {
      state = StudentListError(message: e.toString());
    }
  }

}


abstract class StudentListState {}

class StudentListInitial extends StudentListState {}

class StudentListLoading extends StudentListState {}

class StudentListSuccess extends StudentListState {
  final StudentResponseModel data;
  StudentListSuccess({required this.data});
}

class StudentListError extends StudentListState {
  final String message;
  StudentListError({required this.message});
}