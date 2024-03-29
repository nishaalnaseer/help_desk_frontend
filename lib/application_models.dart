List<String> generateList(json, String key) {
  List<String> list = json[key] != null
      ? List.generate(json[key].length, (index) => json[key][index])
      : [];
  list.sort();

  return list;
}

class Department {
  final int dId;
  final String name;
  final String defaultView;
  final bool ticketable;
  final String submittedBy;
  final List<String> modules;
  final List<String> accessibleTickets;
  final List<String> ticketsRaisedFrom;
  final List<String> nonTicketableReports;
  final List<String> ticketableReports;
  final Map<String, String> ticketCategories;

  Department({
    required this.dId,
    required this.name,
    required this.defaultView,
    required this.ticketable,
    required this.submittedBy,
    required this.modules,
    required this.accessibleTickets,
    required this.ticketsRaisedFrom,
    required this.nonTicketableReports,
    required this.ticketableReports,
    required this.ticketCategories,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      dId: json["d_id"],
      name: json["name"],
      defaultView: json["default_view"],
      ticketable: json["ticketable"],
      submittedBy: json["submitted_by"],

      modules: List.generate(
          json["modules"].length,
              (index) => json["modules"][index]
      ),

      accessibleTickets: List.generate(
          json["accessible_tickets"].length,
              (index) => json["accessible_tickets"][index]
      ),

      nonTicketableReports: List.generate(
          json["non_ticketable_reports"].length,
              (index) => json["non_ticketable_reports"][index]
      ),

      ticketsRaisedFrom: List.generate(
          json["tickets_raised_from"].length,
              (index) => json["tickets_raised_from"][index]
      ),

      ticketableReports: List.generate(
          json["ticketable_reports"].length,
              (index) => json["ticketable_reports"][index]
      ),
      ticketCategories: Map<String, String>.from(json["ticket_categories"]).map(
            (key, value) => MapEntry(key, value.toString()),
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "d_id": dId,
      "name": name,
      "default_view": defaultView,
      "submitted_by": submittedBy,
      "ticketable": ticketable,
      "modules": modules,
      "accessible_tickets": accessibleTickets,
      "tickets_raised_from": ticketsRaisedFrom,
      "non_ticketable_reports": nonTicketableReports,
      "ticketable_reports": ticketableReports,
      "ticket_categories": ticketCategories
    };
  }
}

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
  Department department;
  String defaultView;
  String status;
  String? socialMedia;
  List<Device> devices = [];

  Map<String, String> _auth = {};

  User(
      {
        required this.id,
        required this.name,
        required this.department,
        required this.email,
        required this.number,
        required this.location,
        required this.defaultView,
        required this.status,
        required this.socialMedia,
        List<Device>? devices
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["u_id"],
      name: json["name"],
      department: Department.fromJson(json["department"]),
      email: json["username"],
      number: json["number"],
      location: json["location"],
      defaultView: json["default_view"],
      status: json["status"],
      socialMedia: json["social_media"],
      devices: json["devices"] != null
          ? List.generate(json["devices"].length,
              (index) => Device.fromJson(json["devices"][index]))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "u_id": id,
      "name": name,
      "department": department.toJson(),
      "username": email,
      "number": number,
      "location": location,
      "default_view": defaultView,
      "social_media": socialMedia,
      "status": status
    };
  }

  void setAuth(Map<String, String> newHeader) {
    _auth = newHeader;
  }

  Map<String, String> getAuth() {
    return _auth;
  }
}

class Message {
  final int time;
  final String personFrom;
  final String message;

  Message({
    required this.time,
    required this.personFrom,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      time: json["time"],
      message: json["message"],
      personFrom: json["person_from"],
    );
  }

  Map<String, dynamic> toJson() {
    return {"time": time, "person_from": personFrom, "message": message};
  }
}

class TicketUpdate {
  final String newStatus;
  final double time;
  final String updatedBy;

  TicketUpdate({
    required this.newStatus,
    required this.time,
    required this.updatedBy,
  });

  factory TicketUpdate.fromJson(Map<String, dynamic> json) {
    return TicketUpdate(
      newStatus: json["new_status"],
      time: json["time"],
      updatedBy: json["user"],
    );
  }
}

class Ticket {
  final int tId;
  final String submittedBy;
  final String ticketTo;
  final String nameTicket;
  final String emailTicket;
  final String numberTicket;
  final String deptTicket;
  final String location;
  final String subject;
  final String message;
  String status;
  final String ip;
  final String host;
  final String username;
  final bool hostIssue;
  final String platform;
  List<Message> messages = [];
  List<TicketUpdate> updates = [];
  String category;

  final int submittedOn;
  List<dynamic>? devices = [];

  Ticket(
      {required this.tId,
      required this.submittedBy,
      required this.submittedOn,
      required this.ticketTo,
      required this.nameTicket,
      required this.emailTicket,
      required this.numberTicket,
      required this.deptTicket,
      required this.location,
      required this.subject,
      required this.message,
      required this.devices,
      required this.messages,
      required this.status,
      required this.username,
      required this.ip,
      required this.host,
      required this.hostIssue,
      required this.updates,
      required this.platform,
      required this.category,
      });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      tId: json["t_id"],
      submittedOn: json["submitted_on"],
      submittedBy: json["submitted_by"],
      ticketTo: json["ticket_to"],
      nameTicket: json["name"],
      emailTicket: json["email"],
      numberTicket: json["contact_num"],
      deptTicket: json["department"],
      location: json["location"],
      subject: json["subject"],
      message: json["message"],
      status: json["status"],
      ip: json["ip"],
      host: json["host"],
      username: json["username"] ?? "",
      hostIssue: json["host_issue"],
      platform: json["platform"],
      category: json["category"],
      devices: json["devices"] ?? [],
      messages: List.generate(json["messages"].length,
          (index) => Message.fromJson(json["messages"][index])),
      updates: List.generate(json["updates"].length,
          (index) => TicketUpdate.fromJson(json["updates"][index])),
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
      "host": host,
      "username": username,
      "host_issue": hostIssue,
      "message": message,
      "platform": platform,
      "category": category
    };
  }
}

class UpdateBox {
  final String type;
  final String time;
  final String from;
  final String message;

  late final String displayTime;
  late final String displayFrom;
  late final String displayMessage;

  UpdateBox(
    this.type,
    this.time,
    this.from,
    this.message,
  ) {
    displayTime = "Time: $time";
    if (type == "message") {
      displayFrom = "From: $from";
      displayMessage = "Message: $message";
    } else {
      displayFrom = "Updated By: $from";
      displayMessage = "Changed Status To: $message";
    }
  }
}
