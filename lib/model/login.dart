class Login {
  int? code;
  bool? status;
  String? data;

  Login({this.code, this.status, this.data});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code: obj['code'],
      status: obj['status'],
      data: obj['data']
    );
  }
}