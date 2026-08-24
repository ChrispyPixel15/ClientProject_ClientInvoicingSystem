import 'package:flutter/material.dart';

class ClientListStatement extends StatefulWidget {
  final int statementNum;
  final int id;
  final String date;
  final Function(int statementNum, bool delete) deleteFunc;
  final Function(int statementNum) mailFunc;
  final bool isFirst;

  const ClientListStatement ({
    super.key,
    required this.statementNum,
    required this.id,
    required this.date,
    required this.deleteFunc,
    required this.mailFunc,
    required this.isFirst,
  });

  State<ClientListStatement> createState() => _ClientListInvoiceState();
}

class _ClientListInvoiceState extends State<ClientListStatement> {
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
        height: 43,
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
                  'Statement ${widget.statementNum.toString()}',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: widget.isFirst ? 1 : 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: widget.isFirst ? 8 : 92,
                ),
                child: Text(
                  widget.date,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: widget.isFirst,
                  child: Container(
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
                        widget.deleteFunc(widget.statementNum, true);
                      },
                    ),
                  ),
                ), 
                Visibility(
                  visible: widget.isFirst,
                  child: Container(
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
                        widget.mailFunc(widget.statementNum);
                      },
                    ),
                  ),
                ), 
              ],
            ),    
          ],
        ),
    );
  }
}