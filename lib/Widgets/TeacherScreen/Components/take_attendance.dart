// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, prefer_const_constructors_in_immutables, must_be_immutable, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/loading_screen.dart';
import 'package:hilcoe_attendance_app/Widgets/CommonWidgets/custom_wigets.dart';
import 'package:hilcoe_attendance_app/Widgets/TeacherScreen/Components/results_attendance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../../Models/CommonModels.dart';
import '../../../Services/teacher_api_repo.dart';
import '../../CommonWidgets/screen_colors.dart';
import '../../CommonWidgets/snack_bar_msg.dart';

File? _imageFile1;
File? _imageFile2;
File? _imageFile3;
File? _imageFile4;

class TakeAttendanceScreen extends StatelessWidget {
  double scrH = 0, scrW = 0;
  TextEditingController courseCodeTxtCtr = TextEditingController();
  TextEditingController sectionTxtCtr = TextEditingController();

  List<File> prepareImageFiles() {
    List<File> imageFiles = [];

    if (_imageFile1 != null) {
      imageFiles.add(_imageFile1!);
    }
    if (_imageFile2 != null) {
      imageFiles.add(_imageFile2!);
    }
    if (_imageFile3 != null) {
      imageFiles.add(_imageFile3!);
    }
    if (_imageFile4 != null) {
      imageFiles.add(_imageFile4!);
    }

    return imageFiles;
  }

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);

    scrH = MediaQuery.of(context).size.height;
    scrW = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: MyColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  MyCustomAppBar(
                    barHeight: scrH * 0.12,
                    leadingIcon: Icons.arrow_left_sharp,
                    leadingIconOnTap: () {
                      Navigator.pop(context);
                    },
                    centerText: "",
                  ),
                  SizedBox(
                    height: scrH * 0.4,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: scrH * 0.02, // Adjust the gap between rows
                        crossAxisSpacing: scrW * 0.04, // Adjust the gap between columns
                        childAspectRatio: 4 / 3, // Aspect ratio of 4:3
                      ),
                      children: [
                        AddSessionPhotoCardUpload(imageFile: _imageFile1, cardNo: "1"),
                        AddSessionPhotoCardUpload(imageFile: _imageFile2, cardNo: "2"),
                        AddSessionPhotoCardUpload(imageFile: _imageFile3, cardNo: "3"),
                        AddSessionPhotoCardUpload(imageFile: _imageFile4, cardNo: "4"),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  MyCustomTextField(
                    hintText: 'Course Code',
                    leadingIcon: Icons.book_outlined,
                    txtController: courseCodeTxtCtr,
                  ),
                  SizedBox(height: 10),
                  MyCustomTextField(
                    hintText: 'Section',
                    leadingIcon: Icons.edit_square,
                    txtController: sectionTxtCtr,
                  ),
                  SizedBox(height: scrH * 0.15),
                  MyCustomButton(
                    btnText: "Upload Data",
                    btnHeight: scrH * 0.07,
                    btnOnTap: () async {
                      FocusScope.of(context).unfocus();

                      List<File> imagesList = prepareImageFiles();

                      if (imagesList.isEmpty) {
                        MyCustomSnackBar(context: context, message: "Upload Atleast One Image", leadingIcon: Icons.error_outline).show();
                        return;
                      }

                      String courseId = courseCodeTxtCtr.text.trim().toUpperCase();
                      String section = sectionTxtCtr.text.trim().toUpperCase();
                      if (courseId.isEmpty) {
                        MyCustomSnackBar(context: context, message: "Course Code is Empty", leadingIcon: Icons.error_outline).show();
                        return;
                      }
                      if (section.isEmpty || (section != "A" && section != "B")) {
                        MyCustomSnackBar(
                          context: context,
                          message: "Invalid Section",
                          leadingIcon: Icons.error_outline,
                        ).show();
                        return;
                      }

                      try {
                        await teacherApiRepo.isCourseIdValid(courseId);
                      } catch (err) {
                        MyCustomSnackBar(context: context, message: err.toString(), leadingIcon: Icons.error_outline).show();
                        return;
                      }

                      var uploadAttendanceModel = UploadAttendanceModel(courseCode: courseId, section: section, imageFiles: imagesList);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UploadAttenadanceDataScreen(uploadAttendanceModel: uploadAttendanceModel);
                          },
                        ),
                      );
                      // .then((_) {
                      //   _imageFile1 = null;
                      //   _imageFile2 = null;
                      //   _imageFile3 = null;
                      //   _imageFile4 = null;
                      // });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UploadAttenadanceDataScreen extends StatelessWidget {
  UploadAttendanceModel uploadAttendanceModel;
  UploadAttenadanceDataScreen({required this.uploadAttendanceModel});

  @override
  Widget build(BuildContext context) {
    final teacherApiRepo = Provider.of<TeacherApiRepo>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Map<String, dynamic>>(
          future: teacherApiRepo.uploadAttendanceImages(uploadAttendanceModel.courseCode, uploadAttendanceModel.section, uploadAttendanceModel.imageFiles),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
              // return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // print(snapshot.error);
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              // print(snapshot.data);
              // Schedule state update after frame build
              Future.delayed(Duration(milliseconds: 200), () {
                teacherApiRepo.setPresentStudentList(snapshot.data!['studentsPresent']);
                teacherApiRepo.recentAttendanceModel = RecentAttendanceModel.fromJson(snapshot.data!['attendanceModel']);
                teacherApiRepo.setAbsentStudentList(snapshot.data!['studentsNotPresent']);
              });
              return ResultsAttendance();
              // return Center(child: Text("Done"));
            }
          },
        ),
      ),
    );
  }
}

class AddSessionPhotoCardUpload extends StatefulWidget {
  File? imageFile;
  String cardNo;
  AddSessionPhotoCardUpload({required this.imageFile, required this.cardNo});
  @override
  _AddSessionPhotoCardUploadState createState() => _AddSessionPhotoCardUploadState();
}

class _AddSessionPhotoCardUploadState extends State<AddSessionPhotoCardUpload> {
  Future<void> _pickImage(ImageSource imageSource, String cardNo) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      if (cardNo == "1") {
        _imageFile1 = File(pickedFile!.path);
      } else if (cardNo == "2") {
        _imageFile2 = File(pickedFile!.path);
      } else if (cardNo == "3") {
        _imageFile3 = File(pickedFile!.path);
      } else if (cardNo == "4") {
        _imageFile4 = File(pickedFile!.path);
      }
      widget.imageFile = File(pickedFile!.path);
    });
  }

  @override
  void dispose() {
    widget.imageFile = null;
    _imageFile1 = null;
    _imageFile2 = null;
    _imageFile3 = null;
    _imageFile4 = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(15),
      strokeWidth: 1,
      dashPattern: [5, 5], // Adjust these values for the pattern
      color: Color.fromARGB(255, 68, 63, 63),
      child: SizedBox(
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _pickImage(ImageSource.gallery, widget.cardNo); // Pass ImageSource.gallery as parameter
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo_library, size: 40),
                                Text("Gallary"),
                              ],
                            ),
                          ),
                        ),
                        Container(width: 1, height: 100, color: Colors.black),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _pickImage(ImageSource.camera, widget.cardNo); // Pass ImageSource.gallery as parameter
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                                Text("Camera"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: widget.imageFile != null
              ? SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.file(
                    widget.imageFile!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(7),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_size_select_actual_rounded,
                          color: Color.fromARGB(255, 139, 133, 133),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add Session Photo",
                          style: TextStyle(
                            color: Color.fromARGB(255, 139, 133, 133),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
