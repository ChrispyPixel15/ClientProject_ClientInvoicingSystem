import 'package:flutter/material.dart';
import 'package:pdf_maker/pdf_maker.dart';

class InvoiceTemplate extends BlankPage {
  final int invoiceNumber;
  final String clientContactPerson;
  final String clientContactNumber;
  final String clientContactEmail;
  final String clientVatNumber;
  final double quotedPrice;
  final String clientStreet;
  final String clientCity;
  final String clientSuburb;
  final String clientPostal;
  final String userName;
  final String userNumber;
  final String userEmail;
  final String userVatNumber;
  final String userStreet;
  final String userCity;
  final String userSuburb;
  final String userPostal;
  final String userAccountnum;
  final String userBankName;
  final String userAccountName;
  final String userBranchCode;
  final String userBic;
  final List<Map<String, dynamic>> selectedInvoiceData;

  const InvoiceTemplate({
    super.key,
    required this.invoiceNumber,
    required this.clientContactPerson,
    required this.clientContactNumber,
    required this.clientContactEmail,
    required this.clientVatNumber,
    required this.quotedPrice,
    required this.clientStreet,
    required this.clientCity,
    required this.clientSuburb,
    required this.clientPostal,
    required this.userName,
    required this.userNumber,
    required this.userEmail,
    required this.userVatNumber,
    required this.userStreet,
    required this.userCity,
    required this.userSuburb,
    required this.userPostal,
    required this.selectedInvoiceData,
    required this.userAccountnum,
    required this.userBankName,
    required this.userAccountName,
    required this.userBranchCode,
    required this.userBic,
  });

  @override
  Widget createPageContent(BuildContext context) {
    
    final double totalCost = selectedInvoiceData.fold(0, (previous, current) => previous + (current['price_ph']*current['hours']));
    final String currentInvoice = invoiceNumber.toString().padLeft(6, '0');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tax Invoice",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                invoiceNumber.toString().padLeft(6, '0'),
                style: TextStyle(
                  fontSize: 30,
                ),
              )
            ],
          ),
          SizedBox(height: 20,),
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userStreet,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userCity,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userSuburb,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userPostal,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userNumber,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userEmail,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userVatNumber,
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ISSUED TO:'
                  ),
                  Text(
                    clientContactPerson,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientStreet,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientCity,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientSuburb,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientPostal,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientContactNumber,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientContactEmail,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    clientVatNumber,
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date One',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Date Two',
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 20,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 8,
              top: 10,
              right: 8
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2
              )
            ),
            child: Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(70),
                1: FixedColumnWidth(10),
                2: FixedColumnWidth(10),
                3: FixedColumnWidth(10)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2
                      )
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10
                      ),
                      child: Text(
                        "Description",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10
                      ),
                      child: Text(
                        "Price",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10
                      ),
                      child: Text(
                        "Units",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10
                      ),
                      child: Text(
                        "Subtotal",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ]
                ),
                for (var item in selectedInvoiceData)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10
                        ),
                        child: Text(
                          item['task_name'],
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10
                        ),
                        child: Text(
                          item['price_ph'].toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10
                        ),
                        child: Text(
                          item['hours'].toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 10
                        ),
                        child: Text(
                          (item['price_ph']*item['hours']).toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ]
                  ),
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2
                      )
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10
                      ),
                      child: Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10
                      ),
                      child: Text(
                        "",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10
                      ),
                      child: Text(
                        "Total",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10
                      ),
                      child: Text(
                        totalCost.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ]
                ),
              ]
            )
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PAY TO ACCOUNT",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Account Name: $userAccountName",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Bank: $userBankName",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Branch Code: $userBranchCode",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Account Number: $userAccountnum",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "BIC: $userBic",
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "REFERENCE NUMBER: $currentInvoice",
                    textAlign: TextAlign.left,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}