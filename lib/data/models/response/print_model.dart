class PrintModel {
  int? id;
  final String code;
  final String name;
  final String address;
  final String paper;
  final String type;

  PrintModel({
    this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.paper,
    required this.type,
  });

  // from map
  factory PrintModel.fromMap(Map<String, dynamic> map) {
    return PrintModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      address: map['address'],
      paper: map['paper'],
      type: map['type'],
    );
  }

  // to map
  Map<String, dynamic> toMap() => {
        "code": code,
        "name": name,
        "address": address,
        "paper": paper,
        "type": type,
      };
}
