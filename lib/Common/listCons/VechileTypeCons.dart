class VechileTypeCons {
  final String id;
  final String vechileType;

  VechileTypeCons({
  required  this.id,
   required this.vechileType,
  });

  factory VechileTypeCons.fromJson(Map<String, dynamic> json) {
    return VechileTypeCons(
      id: json['id'],
      vechileType: json['vehicle_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicle_type'] = this.vechileType;
    return data;
  }
}
