import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:machine_test/core/widget/app_field.dart';
import 'package:machine_test/feature/home/model/student_response_model.dart';
import 'package:machine_test/feature/home/provider/class_list_provider.dart';
import 'package:machine_test/feature/home/provider/create_student_provider.dart';

import '../../../core/theme/app_color.dart';
import '../../../core/widget/button.dart';

class CreateStudentScreen extends ConsumerStatefulWidget {
  final StudentModel? student;
  const CreateStudentScreen({super.key,this.student});

  @override
  ConsumerState<CreateStudentScreen> createState() =>
      _CreateStudentScreenState();
}

class _CreateStudentScreenState extends ConsumerState<CreateStudentScreen> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController subjectCtrl = TextEditingController();

  String? selectedClass;

  final List<String> subjects = [];
  File? uploadedImage;


  @override
  void initState() {
    loadDate();
    super.initState();
  }


  void loadDate(){
    if(widget.student != null){
      nameCtrl.text = widget.student!.name??'';
      phoneCtrl.text = widget.student!.phone??'';
      selectedClass = widget.student!.datumClass??'';
      subjects.addAll((widget.student!.subjects??[]).map((e) => e).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createStudentProvider, (previous, next) {
      if (next is CreateStudentSuccess) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Student created successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        Navigator.pop(context);
      }
      if (next is CreateStudentError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text(
                next.message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 130,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/banner.png"),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                const Text(
                  'Student Personal Details',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name
                  AppField(label: 'Name', controller: nameCtrl),

                  const SizedBox(height: 12),
                  // Phone
                  AppField(label: 'Phone Number', controller: phoneCtrl,keyboardType: TextInputType.number,),

                  const SizedBox(height: 12),
                  // Class Dropdown
                  Consumer(
                    builder: (context, ref, child) {
                      final classProvider = ref.watch(classListProvider);
                      return classProvider.when(
                        data: (data) {
                          return DropdownButtonFormField<String>(
                            initialValue: selectedClass,
                            dropdownColor: Colors.white,
                            items: data
                                .map(
                                  (cls) => DropdownMenuItem<String>(
                                    value: "${cls.section}",
                                    child: Text("${cls.name} ${cls.section}"),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedClass = val;
                              });
                            },
                            style: const TextStyle(color: AppColor.primaryBlue),
                            decoration: _decoration('Class'),
                          );
                        },
                        error: (error, stackTrace) => const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  // Subject Field
                  AppField(label: 'Subject', controller: subjectCtrl),

                  const SizedBox(height: 12),
                  // Add Button
                  Center(
                    child: PrimaryButton(
                      label: 'Add',
                      width: 150,
                      onTap: () {
                        if (subjectCtrl.text.isNotEmpty) {
                          setState(() {
                            subjects.add(subjectCtrl.text);
                            subjectCtrl.clear();
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Subject Table
                  Table(
                    border: TableBorder.all(color: Colors.blue.shade200),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.blue.shade50),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Subject", textAlign: TextAlign.center),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Actions", textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      for (int i = 0; i < subjects.length; i++)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                subjects[i],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    subjects.removeAt(i);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // Upload Photo Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Upload Your Photo",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.upload_file, color: Colors.blue),
                        onPressed: () async {
                          final image = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setState(() {
                              uploadedImage = File(image.path);
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Image Preview Box
                  Center(
                    child: Container(
                      height: 150,
                      width: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: uploadedImage == null
                          ? const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            )
                          : Image.file(uploadedImage!, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, child) {
                            final state = ref.watch(createStudentProvider);
                            return PrimaryButton(
                              label: 'Save',
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                print({
                                  'name': nameCtrl.text.trim(),
                                  'phone': phoneCtrl.text.trim(),
                                  'class': "$selectedClass",
                                  for (int i = 0; i < subjects.length; i++)
                                    'subjects[$i]': subjects[i],
                                });
                                ref.read(createStudentProvider.notifier)
                                    .createStudent(
                                      file: uploadedImage,
                                      body: {
                                        'name': nameCtrl.text.trim(),
                                        'phone': phoneCtrl.text.trim(),
                                        'class': "$selectedClass",
                                        for (int i = 0; i < subjects.length; i++)
                                          'subjects[$i]': subjects[i],
                                      },
                                    );
                              },
                              isLoading: state is CreateStudentLoading,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButton(label: 'Close', onTap: () {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      label: Text(label),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryBlue),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryBlue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryRed),
      ),
    );
  }
}
