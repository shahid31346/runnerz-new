class DriverDetail {
  final String? name;
  final String? profilePic;
  final String? vechileNo;
  final String? vechilename;
  final String? vechiletype;
  final double? driverAverageRating;

  DriverDetail(
      {this.name,
      this.profilePic,
      this.vechileNo,
      this.vechilename,
      this.vechiletype,
      this.driverAverageRating});

  factory DriverDetail.fromJson(Map<String, dynamic> json) {
    return DriverDetail(
      name: json['name'],
      profilePic: json['photo'],
      vechileNo: json['vehicle_number'],
      vechilename: json['vehicle_name'],
      vechiletype: json['vehicle_type'],
      driverAverageRating: json['average_rating'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['photo'] = this.profilePic;
    data['vehicle_number'] = this.vechileNo;
    data['vehicle_name'] = this.vechilename;
    data['vehicle_type'] = this.vechiletype;
    data['average_rating'] = this.driverAverageRating;

    return data;
  }
}
