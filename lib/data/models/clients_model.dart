import 'dart:ffi';

class Client {
  final String id;
  final String clientBusName;
  final String clientContactPerson;
  final String clientContactNumber;
  final String clientEmail;
  final int clientVatNumber;
  final String clientStreetAddress;
  final String clientSuburb;
  final String clientCity;
  final int clientPostalCode;
  final Float clientPricePH;
  final String notes;
  final String status;
  final int unpaidInvoices;

  Client({
    required this.id,
    required this.clientBusName,
    required this.clientContactPerson,
    required this.clientContactNumber,
    required this.clientEmail,
    required this.clientVatNumber,
    required this.clientStreetAddress,
    required this.clientSuburb,
    required this.clientCity,
    required this.clientPostalCode,
    required this.clientPricePH,
    required this.notes,
    required this.status,
    required this.unpaidInvoices,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_bus_name': clientBusName,
      'client_contact_person': clientContactPerson,
      'client_contact_number': clientContactNumber,
      'client_email': clientEmail,
      'client_vatNumber': clientVatNumber,
      'client_street_address': clientStreetAddress,
      'client_suburb': clientSuburb,
      'client_city': clientCity,
      'client_postal_code': clientPostalCode,
      'client_price_ph': clientPricePH,
      'notes': notes,
      'status': status,
      'unpaid_invoices': unpaidInvoices,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      clientBusName: map['client_bus_name'],
      clientContactPerson: map['client_contact_person'],
      clientContactNumber: map['client_contact_number'],
      clientEmail: map['client_email'],
      clientVatNumber: map['client_vatNumber'],
      clientStreetAddress: map['client_street_address'],
      clientSuburb: map['client_suburb'],
      clientCity: map['client_city'],
      clientPostalCode: map['client_postal_code'],
      clientPricePH: map['client_price_ph'],
      notes: map['notes'],
      status: map['status'],
      unpaidInvoices: map['unpaid_invoices']
    );
  }
}