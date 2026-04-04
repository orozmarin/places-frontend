class ConsumedItem {
  String? id;
  String? name;
  String? category; // 'FOOD' | 'DRINK' | 'DESSERT' | 'OTHER'
  String? notes;
  List<String>? photoUrls;

  ConsumedItem({this.id, this.name, this.category, this.notes, this.photoUrls});

  factory ConsumedItem.fromJson(Map<String, dynamic> json) => ConsumedItem(
        id: json['id'] as String?,
        name: json['name'] as String?,
        category: json['category'] as String?,
        notes: json['notes'] as String?,
        photoUrls: (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (category != null) 'category': category,
        if (notes != null) 'notes': notes,
        if (photoUrls != null) 'photoUrls': photoUrls,
      };

  ConsumedItem copyWith({
    String? id,
    String? name,
    String? category,
    String? notes,
    List<String>? photoUrls,
  }) =>
      ConsumedItem(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        notes: notes ?? this.notes,
        photoUrls: photoUrls ?? this.photoUrls,
      );
}
