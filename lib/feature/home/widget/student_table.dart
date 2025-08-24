import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machine_test/core/widget/button.dart';
import 'package:machine_test/feature/home/view/create_student_screen.dart';

class StudentTableScreen extends ConsumerWidget {
  const StudentTableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Row (Add New button)
          Align(
            alignment: AlignmentGeometry.centerRight,
            child: PrimaryButton(label: 'Add New', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateStudentScreen(),));
            }, width: 120),
          ),
          const SizedBox(height: 10),

          // Table
          Table(
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
              // for (int i = 0; i < students.length; i++)
              //   TableRow(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text("${i + 1}", textAlign: TextAlign.center),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           students[i]["name"]!,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           students[i]["phone"]!,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Text(
              //           students[i]["class"]!,
              //           textAlign: TextAlign.center,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(4.0),
              //         child: GestureDetector(
              //           child: const Icon(Icons.more_vert, color: Colors.blue),
              //           onTap: () {},
              //         ),
              //       ),
              //     ],
              //   ),
            ],
          ),

          const SizedBox(height: 12),

          // Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final isActive = true;
              return InkWell(
                onTap: () {},
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
          ),
        ],
      ),
    );
  }
}
