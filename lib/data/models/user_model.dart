class User {
  final int? id;
  final String name;
  final String businessName;
  final String number;
  final String email;
  final String vatRegistered;
  final String vatNumber;
  final int vatPercentage;
  final int recentInvoice;
  final String streetAddress;
  final String city;
  final String suburb;
  final int postalCode;
  final String bank;
  final int branchCode;
  final int bic;
  final int accountNumber;
  final String theme;
  final String password;

  User({
    this.id,
    required this.name,
    required this.businessName,
    required this.number,
    required this.email,
    required this.vatRegistered,
    required this.vatNumber,
    required this.vatPercentage,
    required this.recentInvoice,
    required this.streetAddress,
    required this.city,
    required this.suburb,
    required this.postalCode,
    required this.bank,
    required this.branchCode,
    required this.bic,
    required this.accountNumber,
    required this.theme,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'business_name': businessName,
      'number': number,
      'email': email,
      'vat_registered': vatRegistered,
      'vat_number': vatNumber,
      'vat_percentage': vatPercentage,
      'recent_invoice': recentInvoice,
      'street_address': streetAddress,
      'city': city,
      'suburb': suburb,
      'postal_code': postalCode,
      'bank': bank,
      'branch_code': branchCode,
      'bic': bic,
      'account_number': accountNumber,
      'theme': theme,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      businessName: map['business_name'],
      number: map['number'],
      email: map['email'],
      vatRegistered: map['vat_registered'],
      vatNumber: map['vat_number'],
      vatPercentage: map['vat_percentage'],
      recentInvoice: map['recent_invoice'],
      streetAddress: map['street_address'],
      city: map['city'],
      suburb: map['suburb'],
      postalCode: map['postal_code'],
      bank: map['bank'],
      branchCode: map['branch_code'],
      bic: map['bic'],
      accountNumber: map['account_number'],
      theme: map['theme'],
      password: map['password'],
    );
  }
}