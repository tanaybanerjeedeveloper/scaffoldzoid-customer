class Seller {
  String id;
  String email;
  String ornageType;
  String rate;
  String about;

  Seller({
    this.id = '',
    required this.email,
    required this.ornageType,
    required this.rate,
    required this.about,
  });

  static Seller fromJSON(Map<String, dynamic> json) => Seller(
        id: json['id'],
        email: json['email'],
        ornageType: json['orange'],
        about: json['about'],
        rate: json['rate'],
      );
}
