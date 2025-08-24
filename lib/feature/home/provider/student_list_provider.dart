import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/feature/home/repository/home_repo.dart';

final studentListProvider = FutureProvider.family<List, int>((ref, page) async {
  final repo = ref.watch(homeRepoProvider);
  try {
    final res = await repo.fetchStudents(page: page);
    return res;
  } catch (e) {
    throw e.toString();
  }
});
