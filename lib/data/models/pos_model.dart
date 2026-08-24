class PurchaseOrderNumber {
  final String pos;

  PurchaseOrderNumber({
    required this.pos
  });

  Map<String, dynamic> toMap() {
    return {
      'pos': pos
    };
  }

  factory PurchaseOrderNumber.fromMap(Map<String, dynamic> map) {
    return PurchaseOrderNumber(
      pos: map['pos']
    );
  }
}