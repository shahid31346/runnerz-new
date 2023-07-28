class FareDetail {
  final String? vechileTypeId;
  final String? rateType;
  final String? price;
  final String? size;
  final String? hr;
  final String? hrPrice;
  final String? weight;
  final String? status;
  final String? createdAt;

  FareDetail(
      {
        this.vechileTypeId,
      this.rateType,
      this.price,
      this.size,
      this.hr,
      this.hrPrice,
      this.weight,
      this.status,
      this.createdAt});

  factory FareDetail.fromJson(Map<String, dynamic> json) {
    return FareDetail(
      vechileTypeId: json['vehicle_type_id'],
      rateType: json['rate_type'],
      price: json['price'],
      size: json['size'],
      hr: json['hr'],
      hrPrice: json['hr_price'],
      weight: json['weight'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_type_id'] = this.vechileTypeId;
    data['rate_type'] = this.rateType;
    data['price'] = this.price;
    data['size'] = this.size;
    data['hr'] = this.hr;
    data['hr_price'] = this.hrPrice;
    data['weight'] = this.weight;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;

    return data;
  }
}
