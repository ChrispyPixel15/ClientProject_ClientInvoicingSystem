import 'package:customer_timesheet_and_invoicing/features/clients/clients_list_page.dart';
import 'package:flutter/material.dart';

class ClientListItem extends StatefulWidget {
  final String clientName;
  final String clientID;
  final String clientStatus;
  final int unpaidInvoices;
  final Color rowColor;
  final Function(String id, bool delete) deletFunc;
  final Function({String id, String status}) statusFunc;
  final Function(String id, bool edit) editFunc;

  const ClientListItem ({
    super.key,
    required this.clientName,
    required this.clientID,
    required this.clientStatus,
    required this.unpaidInvoices,
    required this.rowColor,
    required this.deletFunc,
    required this.statusFunc,
    required this.editFunc
  });

  State<ClientListItem> createState() => _ClientListItemState();
}

class _ClientListItemState extends State<ClientListItem> {

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
          color: widget.rowColor,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  widget.clientName,
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
                  left: 8,
                ),
                child: Text(
                  widget.clientID,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  widget.clientStatus.toUpperCase(),
                  style: TextStyle(
                    color: widget.clientStatus == "active" ? Color.fromARGB(255, 107, 235, 75) : Color.fromARGB(255, 255, 36, 36)
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Text(
                  widget.unpaidInvoices.toString(),
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
                  left: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    widget.statusFunc(id: widget.clientID, status: widget.clientStatus == "active" ? "inactive" : "active");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.clientStatus == "active" ? Color.fromARGB(255, 245, 144, 49) : Color.fromARGB(255, 107, 235, 75),
                    foregroundColor: widget.clientStatus == "active" ? Color.fromARGB(255, 77, 52, 29) : Color.fromARGB(255, 37, 61, 31),
                    elevation: 5,
                  ),
                  child: Text(
                    widget.clientStatus == "active" ? "Deactivate" : "Activate",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
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
                        widget.deletFunc(widget.clientID, true);
                      },
                    ),
                  ), 
                  Container(
                    padding: EdgeInsets.only(
                      left: 8,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.edit_rounded,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        widget.editFunc(widget.clientID, true);
                      },
                    ),
                  ),
                ],
              ),
            )                        
          ],
        ),
      );
  }
}