class DriverinfoCons {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profielPic;
  final String rating;
  final String vehicleName;
  final String vehicleNumber;

  DriverinfoCons({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profielPic,
    required this.rating,
    required this.vehicleName,
    required this.vehicleNumber,
  });

  factory DriverinfoCons.fromJson(Map<String, dynamic> json) {
    return DriverinfoCons(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profielPic: json['photo'],
      rating: json['rating'],
      vehicleName: json['vehicle_name'],
      vehicleNumber: json['vehicle_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['photo'] = this.profielPic;
    data['rating'] = this.rating;
    data['vehicle_name'] = this.vehicleName;
    data['vehicle_number'] = this.vehicleNumber;

    return data;
  }
}
