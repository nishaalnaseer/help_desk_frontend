class Model {
  /*
   Model of electronic equipment
    Like iphone 11 or iphone 12
    brand: str
    year: int
    description: str  # iphone XL? iphone XXXX? iphone XXXXXXX?
    qty: int  # total currently being used
    */

  final int uId;
  final String brand;
  final String description;
  final int qty;
  final int year;
  final String department;
  final String category;

  Model({
    required this.uId,
    required this.brand,
    required this.description,
    required this.qty,
    required this.year,
    required this.department,
    required this.category,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      uId: json["u_id"],
      brand: json['brand'],
      description: json['description'],
      qty: json['qty'],
      year: json['year'],
      department: json["department"],
      category: json["category"],
    );
  }

}

class Device {
  final int uId;
  final String location;
  final String serialNo;
  final bool staticIp;
  final String ip;
  final String mac;
  final String remarks;
  final String supplies;
  final String obtainedOn;
  final String obtainedFrom;
  final String lastServiced;
  final int totalServiced;
  final Model model;

  Device({
    required this.uId,
    required this.location,
    required this.serialNo,
    required this.staticIp,
    required this.ip,
    required this.mac,
    required this.remarks,
    required this.supplies,
    required this.model,
    required this.obtainedOn,
    required this.obtainedFrom,
    required this.lastServiced,
    required this.totalServiced,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    print(json);
    return Device(
        uId: json["u_id"],
        location: json["location"],
        serialNo: json["serial_no"],
        staticIp: json["static_ip"],
        ip: json["ip"],
        mac: json["mac"],
        remarks: json["remarks"],
        supplies: json["supplies"],
        obtainedOn: json["obtained_on"],
        obtainedFrom: json["obtained_from"],
        lastServiced: json["last_serviced"],
        totalServiced: int.parse(json["total_serviced"]),
        model: Model.fromJson(json["model"]),
    );
  }
}