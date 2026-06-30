import 'package:flutter/material.dart';

class ClientListInvoice extends StatefulWidget {
  final int invoiceNum;
  final int id;
  final String date;
  final String paid;
  final Function(int id, bool paid) paidFunc;
  final Function(int invoiceNum, bool delete) deleteFunc;
  final Function(int invoiceNum) mailFunc;

  const ClientListInvoice ({
    super.key,
    required this.invoiceNum,
    required this.id,
    required this.date,
    required this.paid,
    required this.paidFunc,
    required this.deleteFunc,
    required this.mailFunc,
  });

  State<ClientListInvoice> createState() => _ClientListInvoiceState();
}

class _ClientListInvoiceState extends State<ClientListInvoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          left: 10,
          top: 1,
          bottom: 1,
          right: 10
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).highlightColor
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  'Invoice ${widget.invoiceNum.toString()}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  widget.date,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color
                  ),
                ),
              ),
            ),
             Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                  left: 25
                ),
                child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: widget.paid == "true" ? true : false, 
                    hoverColor: Colors.transparent,
                    activeColor: Colors.transparent,
                    side: WidgetStateBorderSide.resolveWith(
                      (Set<WidgetState> states) {
                        if(states.contains(WidgetState.selected)) {
                          return const BorderSide(
                            color: Color.fromRGBO(103, 103, 103, 1),
                            width: 0.8,
                          );
                        }
                        return const BorderSide(
                          color: Color.fromRGBO(103, 103, 103, 1),
                          width: 0.8,
                        );
                      }
                    ),
                    shape: CircleBorder(),
                    onChanged: (value) {
                      setState(() {
                        bool selected = widget.paid == "true" ? true : false;
                        widget.paidFunc(widget.id, !selected);
                      });
                    }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Color.fromARGB(255, 201, 3, 3),
                    ),
                    onPressed: () {
                      widget.deleteFunc(widget.invoiceNum, true);
                    },
                  ),
                ), 
                Container(
                  padding: EdgeInsets.only(
                    left: 8,
                    right: 8
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.mail_outline_rounded,
                      color: Theme.of(context).highlightColor,
                    ),
                    onPressed: () {
                      widget.mailFunc(widget.invoiceNum);
                    },
                  ),
                ), 
              ],
            ),                       
          ],
        ),
      );
  }
}