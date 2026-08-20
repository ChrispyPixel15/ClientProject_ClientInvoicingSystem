import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_maker/pdf_maker.dart';

class StatementTemplate extends BlankPage {
  final int statementNumber;
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
  final String vatAmmount;
  final String userStreet;
  final String userCity;
  final String userSuburb;
  final String userPostal;
  final String userAccountnum;
  final String userBankName;
  final String userAccountName;
  final String userBranchCode;
  final String userBic;
  final String vatReg;
  final List<Map<String, dynamic>> invoiceDataBetweenDates;
  final String logo;

  const StatementTemplate({
    super.key,
    required this.statementNumber,
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
    required this.vatAmmount,
    required this.userStreet,
    required this.userCity,
    required this.userSuburb,
    required this.userPostal,
    required this.userAccountnum,
    required this.userBankName,
    required this.userAccountName,
    required this.userBranchCode,
    required this.userBic,
    required this.vatReg,
    required this.invoiceDataBetweenDates,
    required this.logo
  });

  @override
  Widget createPageContent(BuildContext context) {
    final DateTime today = DateTime.now();

    final double totalCost = invoiceDataBetweenDates.fold(0, (previous, current) => previous + (current['item'] == "paid" ? - double.parse(current["total_amount"]) : double.parse(current["total_amount"])));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: (File(logo).existsSync())
                    ? FileImage(File(logo))
                    : const AssetImage('lib/assets/default.png') as ImageProvider,
                width: 150,
                height: 150,
              ),
              Text(
                "Statement",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                statementNumber.toString().padLeft(6, "0"),
                style: TextStyle(
                  fontSize: 30
                ),  
              )
            ],
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
                    userNumber.padLeft(10, "0"),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    userEmail,
                    textAlign: TextAlign.left,
                  ),
                  if (vatReg == "true")
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
                    "ISSUED TO: ",
                    textAlign: TextAlign.left,
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
                  if (clientVatNumber != "0")
                    Text(
                      clientVatNumber,
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date Issued: ${DateFormat('dd-MM-yyyy').format(today)}",
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Due Date: ${DateFormat('dd-MM-yyyy').format(today.add(Duration(days: 14)))}",
                  )
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
              columnWidths: const <int, TableColumnWidth> {
                0: FixedColumnWidth(90),
                1: FixedColumnWidth(10),
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
                    )
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsetsGeometry.only(
                        bottom: 10
                      ),
                      child: Text(
                        "Invoice",
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
                        "Amount",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ]
                ),
                for (var item in invoiceDataBetweenDates)
                  TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            top: 10
                          ),
                          child: Text(
                            item['item'] == 'paid' ? "Payment Received - ${item['date']}" : "Invoice ${item['invoice_number']}"
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            top: 10
                          ),
                          child: Text(
                            item['item'] == 'paid' ? "R (${double.parse(item['total_amount']).toStringAsFixed(2)})" : "R ${double.parse(item['total_amount']).toStringAsFixed(2)}"
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
                        "Total"
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        top: 10
                      ),
                      child: Text(
                        totalCost.toStringAsFixed(2)
                      ),
                    ),
                  ]
                )
              ]
            ),
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
            ]
          )
        ],
      ),
    );
  }
}