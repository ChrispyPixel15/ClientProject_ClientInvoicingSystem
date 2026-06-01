import 'package:customer_timesheet_and_invoicing/features/clients/clients_list_page.dart';
import 'package:flutter/material.dart';

class ClientTimeTaskListItem extends StatefulWidget {
  final int id;
  final String task;
  final String pos;
  final String client;
  final String date;
  final String hours;
  final String invoiced;
  final Color rowColor;
  final Function(int id, bool delete) deleteFunc;

  const ClientTimeTaskListItem ({
    super.key,
    required this.id,
    required this.task,
    required this.pos,
    required this.client,
    required this.date,
    required this.hours,
    required this.invoiced,
    required this.rowColor,
    required this.deleteFunc,
  });

  State<ClientTimeTaskListItem> createState() => _ClientTimeTaskListItemState();
}

class _ClientTimeTaskListItemState extends State<ClientTimeTaskListItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 1,
          bottom: 1,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).highlightColor
            ),
          ),
          color: widget.rowColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(
                  left: 8
                ),
                child: Text(
                  widget.task,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(
                  left: 10
                ),
                child: Text(
                  widget.pos,
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
                  left: 5
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
                  left: 10
                ),
                child: Text(
                  widget.hours,
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
                  left: 10
                ),
                child: Text(
                  widget.invoiced == "true" ? "YES" : "NO",
                  style: TextStyle(
                    color: widget.invoiced == "true" ? Colors.green : Colors.red
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                  left: 3,
                  right: 3
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Color.fromARGB(255, 201, 3, 3),
                      ),
                      onPressed: () {
                        widget.deleteFunc(widget.id, true);
                      },
                    ),
                  ],
                ),
              )
            ),
                       
          ],
        ),
      );
  }
}