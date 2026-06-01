import 'package:flutter/material.dart';

class ClientInvoiceTask extends StatefulWidget {
  final int id;
  final String task;
  final String pos;
  final String date;
  final int hours;
  final String client;
  final double priceph;
  final Function(Map<String, dynamic> values) addTaskToInv;
  final Function(String task) deleteTaskFromInv;
  final Function(int id, bool invoiced) updateInvoiced;

  const ClientInvoiceTask ({
    super.key,
    required this.id,
    required this.task,
    required this.pos,
    required this.date,
    required this.hours,
    required this.client,
    required this.priceph,
    required this.addTaskToInv,
    required this.deleteTaskFromInv,
    required this.updateInvoiced,
  });

  State<ClientInvoiceTask> createState() => _ClientInvoiceTaskState();
}

class _ClientInvoiceTaskState extends State<ClientInvoiceTask> {
  bool selected = false;

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
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(
                  left: 8
                ),
                child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    value: selected, 
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
                        if (selected == false) {
                          selected = true;
                          widget.addTaskToInv({
                            'client_fk': widget.client,
                            'pos_fk': widget.pos,
                            'task_name': widget.task,
                            'hours': widget.hours,
                            'price_ph': widget.priceph,
                          });
                          widget.updateInvoiced(widget.id, true);
                        }
                        else {
                          selected = false;
                          widget.deleteTaskFromInv(
                            widget.task
                          );
                          widget.updateInvoiced(widget.id, false);
                        }
                      });
                    }),
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
                  widget.task,
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
                  widget.hours.toString(),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color
                  ),
                ),
              ),
            ),                       
          ],
        ),
      );
  }
}