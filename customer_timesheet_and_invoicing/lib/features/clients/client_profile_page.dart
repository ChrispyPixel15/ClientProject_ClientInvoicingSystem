import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/data/services/client_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/invoice_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/timesheet_task_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_list_invoice.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_task_list_items.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/invoice_generator_client_task.dart';
import 'package:customer_timesheet_and_invoicing/features/settings/settings_page.dart';
import 'package:customer_timesheet_and_invoicing/features/timesheet/components/timesheet_task_item.dart';
import 'package:flutter/material.dart';

class ClientProfile extends StatefulWidget {
  final String clientID;

  const ClientProfile({super.key, required this.clientID});

  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final clientServices = ClientCreationServices();
  final timesheetTaskServices = TimesheetTaskCreationServices();
  final invoiceServices = InvoiceCreationServices();
  final userCreationServices = UserProfileServices();
  Map<String, dynamic>? user;

  bool editClient = false;
  bool deleteBool = false;
  bool deleteInv = false;
  bool editTask = false;
  bool genInv = false;

  int taskID = 0;
  int inv = 0;

  Map<String, dynamic>? currentClient;
  List<Map<String, dynamic>> currentClientTaskList = [];
  List<Map<String, dynamic>> currentClientInvoices = [];

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _taskListController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _invoiceNUmberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadClient();
    getClientTaskList();
    getClientInvoices();
    getUserData();
  }

  Future<void> getUserData() async {
    final result = await userCreationServices.getUserProfile();
    setState(() {
      user = result;
      debugPrint(user.toString());
      int tempinv = result!["recent_invoice"];
      inv = tempinv + 1;
      debugPrint(result.toString());
    });
  }


  Future<void> loadClient() async {
    final result = await clientServices.getClient(widget.clientID);
    setState(() {
      currentClient = result;
     _notesController.text = result!['notes'] == null ? "" : result['notes'];
    });  
  }

  Future<void> updateClientNotes(String note) async {
    await clientServices.updateClient(widget.clientID, {
      'notes': note,
    });
    loadClient();
  }

  Future<void> getClientTaskList() async {
    final result = await timesheetTaskServices.getTimesheetTasks();
    setState(() {
      currentClientTaskList = List<Map<String, dynamic>>.from(result.where((item) {
        return item["client_fk"].contains(currentClient!["client_bus_name"]);
      }));
    });
    debugPrint(result.toString());
  }

  Future<void> editTimeTask(int id, String task, String pos, String client, String date, int hours) async {
    await timesheetTaskServices.updateTimesheetTask(id, {
      'task_fk': task,
      'pos_fk': pos,
      'client_fk': client,
      'date': date,
      'hours': hours,
    });
    await getClientTaskList();
  }

  Future<void> deleteTimeTask(int id) async {
    await timesheetTaskServices.deleteTimehseetTask(id);
    getClientTaskList();
  }

  Future<void> getClientInvoices() async {
    final result = await invoiceServices.getInvoices();
    setState(() {
      currentClientInvoices = List<Map<String, dynamic>>.from(result.where((invoice) {
        return invoice["client_fk"].contains(currentClient!["client_bus_name"]);
      }));
    });
  }

  Future<void> generateInvoice() async {
    await invoiceServices.createInvoice({
      'client_fk': currentClient!["client_bus_name"],
      'invoice_number': inv,
      'date': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      'paid': 'false',
      'dir': ""
    });
    await userCreationServices.updateUser({
      'recent_invoice': user!['recent_invoice'] + 1,
    });
    final result = await invoiceServices.getInvoiceData(inv);
    debugPrint(result.toString());
    await getUserData();
    await getClientInvoices();
    getClientTaskList();
  }

  Future<void> generateInvoiceDB(int invoiceNumber) async {
    await invoiceServices.createInvoiceDB(invoiceNumber);
  }

  Future<void> deleteInvoiceDataBase(int invoiceNumber) async {
    final result = await invoiceServices.getInvoiceData(invoiceNumber);
    for (var res in result) {
      updateTimeTaskInvoiced(res['id'], false);
    }
    await invoiceServices.deleteInvoiceDB(invoiceNumber);
    getClientTaskList();
  }

  Future<void> deleteInvoiceItem(int invoiceNum) async {
    await invoiceServices.deleteInvoice(invoiceNum);
    await invoiceServices.deleteInvoiceDB(invoiceNum);
    await userCreationServices.updateUser({
      'recent_invoice': user!['recent_invoice'] - 1,
    });
    await getUserData();
    await getClientInvoices();
    getClientTaskList();
  }

  Future<void> addTasktoInvoice(Map<String, dynamic> values) async {
    await invoiceServices.addInvoiceItem(values, inv);
  }

  Future<void> deleteTaskFromInvoice(String task) async {
    await invoiceServices.deleteInvoiceItem(task, inv);
  }

  Future<void> editInvoiceItem() async {
    
  }

  Future<void> payInvoice(int id, bool paid) async {
    await invoiceServices.updateInvoice(id, {
      'paid': paid.toString(),
    });
    getClientInvoices();
  }

  Future<void> getSelectedInvoice() async {

  }

  Future<void> updateTimeTaskInvoiced(int id, bool invoiced) async {
    await timesheetTaskServices.updateTimesheetTask(id, {
      'invoiced': invoiced.toString(),
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _taskListController.dispose();
    _clientController.dispose();
    _posController.dispose();
    _dateController.dispose();
    _hoursController.dispose();
    _invoiceNUmberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void activateDelete(int id, bool delete) {
      setState(() {
        deleteBool = delete;
        taskID = id;
      });
    }

    void activateDeleteInv(int id, bool delete) {
      setState(() {
        deleteInv = delete;
        inv = id;
      });
    }

    void clearControllers() {
      _invoiceNUmberController.clear();
    }
    
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: 50,
              right: 50
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                          ),
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 20
                          ),
                          width: screenWidth * 0.45,
                          height: screenHeight * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Client ID: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['id'],
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Contact Person: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['client_contact_person'],
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Contact Number: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['client_contact_number'].toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['client_email'],
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "VAT Number: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['client_vatNumber'].toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Quoted Price p/h: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentClient == null ? "" : currentClient!['client_price_ph'].toString(),
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Address: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        currentClient == null ? "" : currentClient!['client_street_address'].toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        currentClient == null ? "" : currentClient!['client_suburb'].toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        currentClient == null ? "" : currentClient!['client_city'].toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        currentClient == null ? "" : currentClient!['client_postal_code'].toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                          ),
                          padding: EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 20
                          ),
                          width: screenWidth * 0.45,
                          height: screenHeight * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Notes: ",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 300,
                                child: TextField(
                                  controller: _notesController,
                                  expands: true,
                                  maxLines: null,
                                  minLines: null,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                  textAlignVertical: TextAlignVertical.top,
                                  cursorColor: Theme.of(context).highlightColor,
                                  decoration: InputDecoration(
                                    fillColor: Theme.of(context).primaryColorLight,
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).highlightColor,
                                        width: 1.0,
                                      )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).highlightColor,
                                        width: 1.0,
                                      )
                                    ),
                                  ),
                                  onChanged: (e) {
                                    updateClientNotes(e);
                                  },                        
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.45,
                      height: screenHeight * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).highlightColor,
                          width: 1
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              top: 5,
                              bottom: 5,
                              right: 10
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).highlightColor
                                )
                              ),
                              color: Theme.of(context).primaryColorDark
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Task",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Purchase Order Number",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Date",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Hours",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Invoiced",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodySmall?.color
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var task in currentClientTaskList)
                                  ClientTimeTaskListItem(
                                    id: task['id'], 
                                    task: task['task_fk'], 
                                    pos: task['pos_fk'], 
                                    client: task['client_fk'], 
                                    date: task['date'], 
                                    hours: task['hours'].toString(), 
                                    invoiced: task['invoiced'], 
                                    rowColor: Theme.of(context).primaryColor, 
                                    deleteFunc: activateDelete,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.45,
                      height: screenHeight * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).highlightColor,
                          width: 1
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              top: 5,
                              bottom: 5,
                              right: 10
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).highlightColor
                                )
                              ),
                              color: Theme.of(context).primaryColorDark
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Invoices",
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
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Date Generated",
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
                                      right: 80,
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Paid",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColorLight,
                                        foregroundColor: Theme.of(context).primaryColorDark,
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          left: 10,
                                          right: 10
                                        )
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          genInv = true;
                                          _invoiceNUmberController.text = (user!["recent_invoice"] + 1).toString();
                                        });
                                        inv = user!["recent_invoice"] + 1;
                                        generateInvoiceDB(user!["recent_invoice"] + 1);
                                      },
                                      child: Text(
                                        "Generate Invoice",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          for(var inv in currentClientInvoices) 
                            ClientListInvoice(invoiceNum: inv['invoice_number'], id: inv['id'], date: inv['date'], paid: inv['paid'], paidFunc: payInvoice, deleteFunc: activateDeleteInv, editFunc: editInvoiceItem)
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: deleteBool,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.35,
                bottom: screenHeight * 0.35,
                left: screenWidth * 0.33,
                right: screenWidth * 0.33,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 216, 19, 5),
                    width: 2
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5) 
                    )
                  ]
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 50
                      ),
                      child: Text(
                        "Are you sure you want to delete this Task?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deleteTimeTask(taskID);
                            deleteBool = false;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 218, 29, 15),
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              deleteBool = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ),
        Visibility(
          visible: deleteInv,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.35,
                bottom: screenHeight * 0.35,
                left: screenWidth * 0.33,
                right: screenWidth * 0.33,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 216, 19, 5),
                    width: 2
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5) 
                    )
                  ]
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 50
                      ),
                      child: Text(
                        "Are you sure you want to delete this Invoice?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deleteInvoiceItem(inv);
                            deleteInvoiceDataBase(inv);
                            deleteInv = false;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 218, 29, 15),
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              deleteInv = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ),
        Visibility(
          visible: genInv,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.18,
                bottom: screenHeight * 0.18,
                left: screenWidth * 0.35,
                right: screenWidth * 0.35,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    )
                  ]
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          onPressed: () {
                            setState(() {
                              genInv = false;
                            });
                            deleteInvoiceDataBase(user!["recent_invoice"] + 1);
                            clearControllers();
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: Text(
                            "Generate Invoice",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextInput(labelName: "Invoice Number", hintText: "Invoice Number...", password: false, inputController: _invoiceNUmberController),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Select Tasks",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                )
                              ),
                              height: screenHeight * 0.3,
                              width: 1000,
                              child: Column(
                                children: [
                                  for (var task in currentClientTaskList)
                                    if (task['invoiced'] == "false") 
                                      ClientInvoiceTask(
                                        id: task['id'], 
                                        task: task['task_fk'], 
                                        pos: task['pos_fk'], 
                                        date: task['date'], 
                                        hours: task['hours'], 
                                        client: currentClient!["client_bus_name"], 
                                        priceph: currentClient!["client_price_ph"],
                                        addTaskToInv: addTasktoInvoice,
                                        deleteTaskFromInv: deleteTaskFromInvoice,
                                        updateInvoiced: updateTimeTaskInvoiced)
                                ],
                              ),
                            ),
                          ),                          
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              generateInvoice();
                              setState(() {
                                genInv = false;
                              });
                              clearControllers();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorLight,
                              foregroundColor: Theme.of(context).primaryColorDark,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30
                              )
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]
    );
  }
}