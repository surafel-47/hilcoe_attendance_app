// ignore_for_file: non_constant_identifier_names

class TeacherModel {
  String objectId;
  String teacherId;
  String teacherName;
  String email;
  String password;

  TeacherModel({
    this.objectId = '',
    this.teacherId = '',
    this.teacherName = '',
    this.email = '',
    this.password = '',
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      objectId: json['_id'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  void printTeacherDetails() {
    print('Object ID: $objectId');
    print('Teacher ID: $teacherId');
    print('Teacher Name: $teacherName');
    print('Email: $email');
    print('Password: $password');
  }
}
