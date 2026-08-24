import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf_maker/pdf_maker.dart';

class PersonalStatementTemplate extends BlankPage {
  final List<Map<String, dynamic>> invoiceDataBetweenDates;
  final String logo;

  const PersonalStatementTemplate({
    super.key,
    required this.invoiceDataBetweenDates,
    required this.logo,
  });

  @override
  Widget createPageContent(BuildContext context) {
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
                "Personal Statement",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
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
        ],
      ),
    );
  }
}