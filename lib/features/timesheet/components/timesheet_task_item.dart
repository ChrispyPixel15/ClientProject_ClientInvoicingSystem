import 'package:customer_timesheet_and_invoicing/features/clients/clients_list_page.dart';
import 'package:flutter/material.dart';

class TimeTaskListItem extends StatefulWidget {
  final int id;
  final String task;
  final String pos;
  final String client;
  final String date;
  final String hours;
  final String invoiced;
  final Color rowColor;
  final Function(int id, bool delete) deleteFunc;
  final Function(int id, bool edit, String task, String client, String pos, int hours, String date) editFunc;

  const TimeTaskListItem ({
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
    required this.editFunc,
  });

  State<TimeTaskListItem> createState() => _TimeTaskListItemState();
}

class _TimeTaskListItemState extends State<TimeTaskListItem> {

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
                  left: 8
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
                  left: 8
                ),
                child: Text(
                  widget.client,
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
                  left: 8
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
                  left: 12
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
                  left: 3,
                  right: 10
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
                    IconButton(
                      icon: Icon(
                        Icons.edit_rounded,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        widget.editFunc(widget.id, true, widget.task, widget.client, widget.pos, int.parse(widget.hours), widget.date);
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