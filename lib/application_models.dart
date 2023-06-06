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

class User {
  final int id;
  String name;
  String email;
  String number;
  String location;
  String department;
  List<Device> devices = [];

  User({
    required this.id,
    required this.name,
    required this.department,
    required this.email,
    required this.number,
    required this.location,
    List<Device>? devices
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["u_id"],
      name: json["submitted_by"],
      department: json["name_ticket"],
      email: json["email"],
      number: json["number"],
      location: json["location"],
      devices: json["devices"] != null ?
        List.generate(json["devices"].lenght,
                (index) => Device.fromJson(json["devices"][index])
        ) :
        [],
    );
  }
}

class Ticket {
  final int tId;
  final int submittedBy;
  final String ticketTo;
  final String nameTicket;
  final String emailTicket;
  final String numberTicket;
  final String deptTicket;
  final String location;
  final String subject;
  final String message;
  List<int>? devices = [];

  Ticket({
    required this.tId,
    required this.submittedBy,
    required this.ticketTo,
    required this.nameTicket,
    required this.emailTicket,
    required this.numberTicket,
    required this.deptTicket,
    required this.location,
    required this.subject,
    required this.message,
    this.devices
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      tId: json["t_id"],
      submittedBy: json["submitted_by"],
      ticketTo: json["ticket_to"],
      nameTicket: json["name"],
      emailTicket: json["email"],
      numberTicket: json["contact_num"],
      deptTicket: json["department"],
      location: json["location"],
      subject: json["subject"],
      message: json["message"],
      devices: json["devices"] ?? [],
      // devices?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "t_id": tId,
      "submitted_by": submittedBy,
      "ticket_to": ticketTo,
      "name": nameTicket,
      "email": emailTicket,
      "contact_num": numberTicket,
      "department": deptTicket,
      "location": location,
      "subject": subject,
      "message": message,
      "devices": devices
    };
  }
}
