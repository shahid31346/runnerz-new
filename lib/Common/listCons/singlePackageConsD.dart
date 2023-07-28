class SinglePackageConsD {
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? packageCategory;
  final String? packageType;
  final String? packageWeight;
  final String? packageSize;
  final String? handleWithCare;
  final String? description;
  final String? comments;
  final String? pickupLocation;
  final String? dropLocation;
  final String? pickdate;
  final String? pickTime;
  final String? amount;
  final String? driverPic;
  final String? driverName;
  final String? vehicleName;
  final String? vehicleNumber;
  final String? driverPhone;
  final String? driverEmail;
  final String? packagePhoto1;
  final String? packagePhoto2;
  final String? packagePhoto3;
  final String? packagePhoto4;
  final String? perKmPrice;

  SinglePackageConsD({
     this.customerName,
     this.customerPhone,
     this.customerEmail,
     this.packageCategory,
     this.packageType,
     this.packageWeight,
     this.packageSize,
     this.handleWithCare,
     this.description,
     this.comments,
     this.pickupLocation,
     this.dropLocation,
     this.pickdate,
     this.pickTime,
     this.amount,
     this.driverPic,
     this.driverName,
     this.vehicleName,
     this.vehicleNumber,
     this.driverPhone,
     this.driverEmail,
     this.packagePhoto1,
     this.packagePhoto2,
     this.packagePhoto3,
     this.packagePhoto4,
     this.perKmPrice,
  });

  factory SinglePackageConsD.fromJson(Map<String, dynamic> json) {
    return SinglePackageConsD(
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      packageCategory: json['category'],
      packageType: json['type_name'],
      packageWeight: json['weight'],
      packageSize: json['size'],
      handleWithCare: json['handle_with_care'],
      description: json['description'],
      comments: json['comment'],
      pickupLocation: json['pickup_location'],
      dropLocation: json['drop_location'],
      pickdate: json['pick_date'],
      pickTime: json['pick_time_new'],
      amount: json['ride_amount'],
      packagePhoto1: json['photo1'],
      packagePhoto2: json['photo2'],
      packagePhoto3: json['photo3'],
      packagePhoto4: json['photo4'],
      perKmPrice: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['customer_email'] = this.customerEmail;
    data['category'] = this.packageCategory;
    data['type_name'] = this.packageType;
    data['weight'] = this.packageWeight;
    data['size'] = this.packageSize;
    data['handle_with_care'] = this.handleWithCare;
    data['description'] = this.description;
    data['comment'] = this.comments;
    data['pickup_location'] = this.pickupLocation;
    data['drop_location'] = this.dropLocation;
    data['pick_date'] = this.pickdate;
    data['pick_time_new'] = this.pickTime;
    data['ride_amount'] = this.amount;
    data['driver_photo'] = this.driverPic;
    data['driver_name'] = this.driverName;
    data['vehicle_name'] = this.vehicleName;
    data['vehicle_number'] = this.vehicleNumber;
    data['driver_phone'] = this.driverPhone;
    //this above
    data['driver_email'] = this.driverEmail;
    data['photo1'] = this.packagePhoto1;
    data['photo2'] = this.packagePhoto2;
    data['photo3'] = this.packagePhoto3;
    data['photo4'] = this.packagePhoto4;
    data['price'] = this.perKmPrice;

    return data;
  }
}
