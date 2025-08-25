import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/widget/button.dart';
import 'package:machine_test/feature/home/provider/delete_student_provider.dart';
import 'package:machine_test/feature/home/provider/student_list_provider.dart';
import 'package:machine_test/feature/home/view/create_student_screen.dart';

class StudentTableScreen extends ConsumerStatefulWidget {
  const StudentTableScreen({super.key});

  @override
  ConsumerState<StudentTableScreen> createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends ConsumerState<StudentTableScreen> {

  @override
  void initState() {
    _fetchStudents();
    super.initState();
  }

  void _fetchStudents() async {
    Future.microtask(() => ref.read(studentListProvider.notifier).fetchStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (Add New button)
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: PrimaryButton(
              label: 'Add New',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateStudentScreen(),
                  ),
                );
              },
              width: 120,
            ),
          ),
          const SizedBox(height: 10),

          // Table
          Consumer(
            builder: (_, ref, __) {
              final state = ref.watch(studentListProvider);
              if(state is StudentListLoading){
                return const Center(child: CircularProgressIndicator());
              }
              if(state is StudentListError){
                print(state.message);
                return Center(child: Text(state.message));
              }
              if(state is StudentListSuccess){
                final students = state.data.data??[];
                return Table(
                  border: TableBorder.all(color: Colors.blue.shade200),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue.shade50),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("SL", textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Name", textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Phone", textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Class", textAlign: TextAlign.center),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Actions", textAlign: TextAlign.center),
                        ),
                      ],
                    ),

                    // Data Rows
                    for (int i = 0; i < students.length; i++)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${i + 1}", textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              students[i].name??'',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              students[i].phone??'',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              students[i].datumClass??'',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.blue),
                            color: Colors.white,
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateStudentScreen(
                                      student: students[i],
                                    ),
                                  ),
                                );
                              } else if (value == 'delete') {
                                // confirm delete dialog
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Delete Student"),
                                    content: Text("Are you sure you want to delete ${students[i].name}?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          ref.read(deleteStudentProvider.notifier).deleteStudent(id: students[i].id??0);
                                        },
                                        child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text("Edit"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text("Delete"),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }
          ),

          const SizedBox(height: 12),

          // Pagination
          Consumer(
              builder: (_, ref, __) {
                final state = ref.watch(studentListProvider);
                if(state is StudentListSuccess){
                  final totalPage = state.data.meta?.lastPage??1;
                  final currentPage = state.data.meta?.currentPage??1;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPage, (index) {
                      final isActive = index + 1 == currentPage;
                      return InkWell(
                        onTap: () {
                          ref.read(studentListProvider.notifier).fetchStudents(page: index + 1);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? Colors.redAccent : Colors.transparent,
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }else{
                  return const SizedBox.shrink();
                }
              }
          ),
        ],
      ),
    );
  }
}
