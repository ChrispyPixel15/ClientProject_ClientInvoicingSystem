class Invoice {
  final int? id;
  final String clientFK;
  final int invoiceNumber;
  final String date;
  final String paid;
  final String directory;

  Invoice({
    this.id,
    required this.clientFK,
    required this.invoiceNumber,
    required this.date,
    required this.paid,
    required this.directory,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'client_fk': clientFK,
      'invoice_number': invoiceNumber,
      'date': date,
      'paid': paid,
      'dir': directory,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      clientFK: map['client_fk'],
      invoiceNumber: map['invoice_number'],
      date: map['date'],      
      paid: map['paid'],
      directory: map['dir'],
    );
  }
}