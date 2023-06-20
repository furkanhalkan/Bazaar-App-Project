class Market {
  final String id;
  final String pazar_adi;
  final String description;
  final String gunler;
  final String il;
  final String ilce;

  Market({
    required this.id,
    required this.pazar_adi,
    required this.description,
    required this.gunler,
    required this.il,
    required this.ilce,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['pazar_id'],
      pazar_adi: json['pazar_adi'],
      description: json['Description'],
      gunler: json['Gunler'],
      il: json['il'],
      ilce: json['ilce'],
    );
  }
}
