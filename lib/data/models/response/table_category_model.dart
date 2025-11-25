class TableCategoryModel {
  final int id;
  final String name;
  final String? icon;
  final String? color;
  final String? description;
  final int total;
  final int available;
  final int occupied;

  TableCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.description,
    this.total = 0,
    this.available = 0,
    this.occupied = 0,
  });

  factory TableCategoryModel.fromJson(Map<String, dynamic> json) {
    return TableCategoryModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      description: json['description'],
      total: json['total'] ?? 0,
      available: json['available'] ?? 0,
      occupied: json['occupied'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'description': description,
      'total': total,
      'available': available,
      'occupied': occupied,
    };
  }
}
