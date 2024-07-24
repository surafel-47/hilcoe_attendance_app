class StudentModel {
  String objectId;
  String studentId;
  String studentName;
  String email;
  String password;
  String profileUrl;
  String batch;

  StudentModel({
    this.objectId = '',
    this.studentId = '',
    this.studentName = '',
    this.email = '',
    this.password = '',
    this.profileUrl = '',
    this.batch = '',
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      objectId: json['_id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profileUrl: json['profile_url'] ?? '',
      batch: json['batch'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': objectId,
      'student_id': studentId,
      'student_name': studentName,
      'email': email,
      'password': password,
      'profile_url': profileUrl,
      'batch': batch,
    };
  }

  void printStudentDetails() {
    print('Object ID: $objectId');
    print('Student ID: $studentId');
    print('Student Name: $studentName');
    print('Email: $email');
    print('Password: $password');
    print('Profile URL: $profileUrl');
    print('Batch: $batch');
  }
}
