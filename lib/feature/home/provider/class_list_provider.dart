import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/feature/home/model/class_model.dart';

import '../repository/home_repo.dart';

final classListProvider = FutureProvider.autoDispose<List<ClassModel>>((ref) async {
  final repo = ref.watch(homeRepoProvider);
  try {
    final res = await repo.fetchClasses();
    return res;
  } catch (e) {
    throw e.toString();
  }
});
