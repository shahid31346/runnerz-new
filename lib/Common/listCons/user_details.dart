class UserDetail {
  final String? profilePic;
  final String? mobileNo;
  final String? email;
  final String? fullname;

  UserDetail({ this.profilePic,  this.mobileNo,  this.email,
       this.fullname});

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      profilePic: json['photo'],
      mobileNo: json['phone'],
      email: json['email'],
      fullname: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.profilePic;
    data['phone'] = this.mobileNo;
    data['email'] = this.email;
    data['name'] = this.fullname;

    return data;
  }
}
