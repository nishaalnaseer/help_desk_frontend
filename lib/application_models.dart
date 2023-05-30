class Model {
  /*
   Model of electronic equipment
    Like iphone 11 or iphone 12
    brand: str
    year: int
    description: str  # iphone XL? iphone XXXX? iphone XXXXXXX?
    qty: int  # total currently being used
    */

  final String brand;
  final String description;
  final int qty;
  final int year;
  final String department;
  final String category;

  Model({
    required this.brand,
    required this.description,
    required this.qty,
    required this.year,
    required this.department,
    required this.category,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      brand: json['brand'],
      description: json['description'],
      qty: json['qty'],
      year: json['year'],
      department: json["department"],
      category: json["category"],
    );
  }

}