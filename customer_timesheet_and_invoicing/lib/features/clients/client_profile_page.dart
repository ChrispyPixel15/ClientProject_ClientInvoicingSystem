import 'dart:io';
import 'dart:typed_data';

import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/data/services/client_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/invoice_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/statement_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/timesheet_task_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_list_invoice.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_list_statement.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_task_list_items.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/invoice_generator_client_task.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/invoices/invoice_template.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/statements/client_statement_template.dart';
import 'package:customer_timesheet_and_invoicing/features/settings/settings_page.dart';
import 'package:customer_timesheet_and_invoicing/features/timesheet/components/timesheet_task_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_maker/pdf_maker.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final clientStatementServices = StatementCreationServices();
  Map<String, dynamic>? user;

  bool editClient = false;
  bool deleteBool = false;
  bool deleteInv = false;
  bool deleteState = false;
  bool editTask = false;
  bool genInv = false;
  bool genStatement = false;

  int taskID = 0;
  int inv = 0;
  int state = 0;

  String statementStart = "Start Date";
  String statementEnd = "End Date";

  DateTime? dateOne;
  DateTime? dateTwo;

  DateTime? today = DateTime.now();

  Map<String, dynamic>? currentClient;
  List<Map<String, dynamic>> currentClientTaskList = [];
  List<Map<String, dynamic>> currentClientInvoices = [];
  List<Map<String, dynamic>> selectedInvoiceData = [];
  List<Map<String, dynamic>> uninvoicedTasks = [];
  List<Map<String, dynamic>> currentClientStatementList = [];
  List<Map<String, dynamic>> invoicesInTerm = [];

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _taskListController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _invoiceNUmberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadClient();
    getClientTaskList();
    getClientInvoices();
    getClientStatements();
    getUserData();
  }

  Future<void> _selectDate() async {
    final ThemeData currentTheme = Theme.of(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: currentTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: currentTheme.primaryColor,
              shadowColor: currentTheme.primaryColorDark,
              headerForegroundColor: currentTheme.highlightColor,
              subHeaderForegroundColor: currentTheme.highlightColor,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.highlightColor; // Selected day fill
                return Colors.transparent;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.primaryColorDark; // Selected day text
                if (states.contains(WidgetState.disabled)) return currentTheme.primaryColorLight;  // Disabled dates
                return currentTheme.textTheme.bodySmall?.color;                                         // Standard dates
              }),
              weekdayStyle: TextStyle(
                color: currentTheme.highlightColor
              )
            )
          ),
          child: child!,
        );
      }
    );

    setState(() {
      today = pickedDate;
    });
  }

  Future<void> getUserData() async {
    final result = await userCreationServices.getUserProfile();
    setState(() {
      user = result;
      debugPrint(user.toString());
      int tempinv = result!["recent_invoice"];
      inv = tempinv;
      int tempstate = result["recent_statement"];
      state = tempstate;
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
    debugPrint(result.toString());
  }

  Future<void> getClientStatements() async {
    final result = await clientStatementServices.getClientStatements();
    setState(() {
      currentClientStatementList = List<Map<String, dynamic>>.from(result.where((statement) {
        return statement["client_fk"].contains(currentClient!["client_bus_name"]);
      }));
    });
  }

  Future<void> getUninvoicedTasks() async {
    final result = await timesheetTaskServices.getTimesheetTasks();
    List<Map<String, dynamic>> tempList = List<Map<String, dynamic>>.from(result.where((item) {
      return item["client_fk"].contains(currentClient!["client_bus_name"]);
    }));
    setState(() {
      uninvoicedTasks = List<Map<String, dynamic>>.from(tempList.where((tem) {
        return tem["invoiced"].contains("false");
      }));
    });
  }

  Future<void> addUnpaidAmountInvoices() async {
     await clientServices.updateClient(widget.clientID, {
      'unpaid_invoices': currentClient!['unpaid_invoices'] + 1
    });
    loadClient();
  }

  Future<void> removeUnpaidAmountInvoices() async {
     await clientServices.updateClient(widget.clientID, {
      'unpaid_invoices': currentClient!['unpaid_invoices'] - 1
    });
    loadClient();
  }

  Future<void> generateInvoice(String directory) async {
    double amount = 0;

    for (var item in selectedInvoiceData) {
      amount = amount + (item['price_ph']*item['hours']);
    }

    await invoiceServices.createInvoice({
      'client_fk': currentClient!["client_bus_name"],
      'invoice_number': inv,
      'date': "${today?.day}-${today?.month}-${today?.year}",
      'paid': 'false',
      'total_amount': amount.toString(),
      'dir': directory
    });
    await userCreationServices.updateUser({
      'recent_invoice': user!['recent_invoice'] + 1,
    });
    await getUserData();
    await getClientInvoices();
    addUnpaidAmountInvoices();
  }

  Future<void> generateInvoiceDB(int invoiceNumber) async {
    await invoiceServices.createInvoiceDB(invoiceNumber);
    final result = invoiceServices.getInvoices();
    debugPrint("This is the result: ${result.toString()}");
    final res = invoiceServices.getInvoiceData(invoiceNumber);
    debugPrint(res.toString());
  }

  Future<void> deleteInvoiceDataBase(int invoiceNumber) async {
    final result = await invoiceServices.getInvoiceData(invoiceNumber);
    debugPrint(result.toString());
    for (var res in result) {
      updateTimeTaskInvoiced(res['id'], false);
    }
    await invoiceServices.deleteInvoiceDB(invoiceNumber);
    getClientTaskList();
  }

  Future<void> deleteInvoiceItem(int invoiceNum) async {
    deleteInvoiceDataBase(invoiceNum);
    deleteFile(invoiceNum);
    removeUnpaidAmountInvoices();
    await invoiceServices.deleteInvoice(invoiceNum);
    await invoiceServices.deleteInvoiceDB(invoiceNum);
    await userCreationServices.updateUser({
      'recent_invoice': user!['recent_invoice'] - 1,
    });
    await getUserData();
    await getClientInvoices();
    getClientTaskList();
  }

  Future<void> deleteFile(int invoiceNum) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedInvoices');
    final file = File('${customDir.path}/Invoice $invoiceNum.pdf');
    if (await file.exists()) {
      file.delete();
    }
  }

  Future<void> addTasktoInvoice(Map<String, dynamic> values) async {
    await invoiceServices.addInvoiceItem(values, inv);
    getSelectedInvoice(inv);
  }

  Future<void> deleteTaskFromInvoice(String task) async {
    await invoiceServices.deleteInvoiceItem(task, inv);
  }

  Future<void> payInvoice(int id, bool paid) async {
    DateTime now = DateTime.now();

    if (paid == true) {
      removeUnpaidAmountInvoices();
      await invoiceServices.updateInvoice(id, {
        'paid': paid.toString(),
        'date_paid': '${now.day}-${now.month}-${now.year}',
      });
    }
    else {
      addUnpaidAmountInvoices();
      await invoiceServices.updateInvoice(id, {
        'paid': paid.toString(),
        'date_paid': "",
      });
    }
    final res = invoiceServices.getInvoices();
    debugPrint(res.toString());
    getClientInvoices();
  }

  Future<void> getSelectedInvoice(int invoiceNum) async {
    final result = await invoiceServices.getInvoiceData(invoiceNum);
    setState(() {
      selectedInvoiceData = result;
      debugPrint(selectedInvoiceData.toString());
    });
  }

  Future<void> updateTimeTaskInvoiced(int id, bool invoiced) async {
    await timesheetTaskServices.updateTimesheetTask(id, {
      'invoiced': invoiced.toString(),
    });
    getClientTaskList();
  }

  Future<void> saveAndOpen(Uint8List file, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedInvoices');
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    final savedFile = File('${customDir.path}/$fileName.pdf');
    await savedFile.writeAsBytes(file);
    generateInvoice('${customDir.path}/$fileName.pdf');
    await OpenFile.open('${customDir.path}/$fileName.pdf');
  }

  Future<void> openFile(int invoiceNum) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedInvoices');
    await OpenFile.open('${customDir.path}/Invoice $invoiceNum.pdf');
  }

  Future<void> createPDF() async {
      getSelectedInvoice(inv);

      PDFMaker maker = PDFMaker();

      maker.createPDF(
        InvoiceTemplate(
          invoiceNumber: inv,
          clientContactPerson: currentClient!['client_contact_person'],
          clientContactNumber: currentClient!['client_contact_number'].toString(),
          clientContactEmail: currentClient!['client_email'],
          clientVatNumber: currentClient!['client_vatNumber'].toString(),
          termDays: currentClient!['client_payment_term'],
          quotedPrice: currentClient!['client_price_ph'],
          clientStreet: currentClient!['client_street_address'],
          clientCity: currentClient!['client_city'],
          clientSuburb: currentClient!['client_suburb'],
          clientPostal: currentClient!['client_postal_code'].toString(),
          userName: user!['name'],
          userNumber: user!['number'].toString(),
          vatAmmount: user!['vat_percentage'].toString(),
          userEmail: user!['email'],
          userVatNumber: user!['vat_number'].toString(),
          userStreet: user!['street_address'],
          userCity: user!['city'],
          userSuburb: user!['suburb'],
          userPostal: user!['postal_code'].toString(),
          selectedInvoiceData: selectedInvoiceData,
          userAccountnum: user!['account_number'].toString(),
          userBankName: user!['bank'],
          userAccountName: user!['account_number'].toString(),
          userBranchCode: user!['branch_code'].toString(),
          userBic: user!['bic'].toString(),
          vatReg: user!['vat_registered'],
          logo: user!['logo_dir'], 
          invoiceDate: today,
        ),
        setup: PageSetup(
          context: context,
          quality: 4.0,
          scale: 1.0,
          pageFormat: PageFormat.a4,
          margins: 40
        )
      ).then((file) {
        saveAndOpen(file, 'Invoice $inv');
      });
    }

  Future<void> mailInvoice(int invoiceNum) async {
     final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: currentClient!['client_email'],
      queryParameters: {
        'subject': 'Invoice $invoiceNum',
        'body': user!["default_email"]
      }
    );
    await launchUrl(emailLaunchUri);
  }

  Future<void> _selectDateOne() async {
    final ThemeData currentTheme = Theme.of(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: currentTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: currentTheme.primaryColor,
              shadowColor: currentTheme.primaryColorDark,
              headerForegroundColor: currentTheme.highlightColor,
              subHeaderForegroundColor: currentTheme.highlightColor,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.highlightColor; // Selected day fill
                return Colors.transparent;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.primaryColorDark; // Selected day text
                if (states.contains(WidgetState.disabled)) return currentTheme.primaryColorLight;  // Disabled dates
                return currentTheme.textTheme.bodySmall?.color;                                         // Standard dates
              }),
              weekdayStyle: TextStyle(
                color: currentTheme.highlightColor
              )
            )
          ),
          child: child!,
        );
      }
    );

    setState(() {
      dateOne = pickedDate;
      statementStart = "${pickedDate?.day}-${pickedDate?.month}-${pickedDate?.year}";
    });
  }

  Future<void> _selectDateTwo() async {
    final ThemeData currentTheme = Theme.of(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: currentTheme.copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: currentTheme.primaryColor,
              shadowColor: currentTheme.primaryColorDark,
              headerForegroundColor: currentTheme.highlightColor,
              subHeaderForegroundColor: currentTheme.highlightColor,
              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.highlightColor; // Selected day fill
                return Colors.transparent;
              }),
              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) return currentTheme.primaryColorDark; // Selected day text
                if (states.contains(WidgetState.disabled)) return currentTheme.primaryColorLight;  // Disabled dates
                return currentTheme.textTheme.bodySmall?.color;                                         // Standard dates
              }),
              weekdayStyle: TextStyle(
                color: currentTheme.highlightColor
              )
            )
          ),
          child: child!,
        );
      }
    );

    setState(() {
      dateTwo = pickedDate;
      statementEnd = "${pickedDate?.day}-${pickedDate?.month}-${pickedDate?.year}";
    });
  }

  Future<void> getTermInvoices() async {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");    

    List<Map<String, dynamic>> invoices = List<Map<String, dynamic>>.from(currentClientInvoices.where((invoice) {
      return (dateFormat.parse(invoice["date"]).isAfter(dateOne ?? DateTime.now()) || dateFormat.parse(invoice["date"]).isAtSameMomentAs(dateOne ?? DateTime.now())) &&
      (dateFormat.parse(invoice["date"]).isBefore(dateTwo ?? DateTime.now()) || dateFormat.parse(invoice["date"]).isAtSameMomentAs(dateTwo ?? DateTime.now()));
    }));

    for (var invoice in List.from(invoices))  {
      if (invoice["paid"] == "true") {
        invoices.add({
          'invoice_number': invoice['invoice_number'],
          'item': "paid",
          'date': invoice["date_paid"],
          'total_amount': invoice['total_amount'],
        });
      }
    }

    invoices.sort((a, b) => dateFormat.parse(a["date"]).compareTo(dateFormat.parse(b["date"])));

    invoicesInTerm = invoices;
  }

  Future<void> generateStatement(String directory) async {

    await clientStatementServices.createClientStatement({
      'client_fk': currentClient!["client_bus_name"],
      'statement_number': state,
      'date': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      'dir': directory
    });
    await userCreationServices.updateUser({
      'recent_statement': user!['recent_statement'] + 1,
    });
    await getUserData();
    getClientStatements();
  }

  Future<void> createStatementPDF() async {

      PDFMaker maker = PDFMaker();

      maker.createPDF(
        StatementTemplate(
          statementNumber: state,
          clientContactPerson: currentClient!['client_contact_person'],
          clientContactNumber: currentClient!['client_contact_number'].toString(),
          clientContactEmail: currentClient!['client_email'],
          clientVatNumber: currentClient!['client_vatNumber'].toString(),
          quotedPrice: currentClient!['client_price_ph'],
          clientStreet: currentClient!['client_street_address'],
          clientCity: currentClient!['client_city'],
          clientSuburb: currentClient!['client_suburb'],
          clientPostal: currentClient!['client_postal_code'].toString(),
          userName: user!['name'],
          userNumber: user!['number'].toString(),
          vatAmmount: user!['vat_percentage'].toString(),
          userEmail: user!['email'],
          userVatNumber: user!['vat_number'].toString(),
          userStreet: user!['street_address'],
          userCity: user!['city'],
          userSuburb: user!['suburb'],
          userPostal: user!['postal_code'].toString(),
          userAccountnum: user!['account_number'].toString(),
          userBankName: user!['bank'],
          userAccountName: user!['account_number'].toString(),
          userBranchCode: user!['branch_code'].toString(),
          userBic: user!['bic'].toString(),
          vatReg: user!['vat_registered'],
          invoiceDataBetweenDates: invoicesInTerm,
          logo: user!['logo_dir']
        ),
        setup: PageSetup(
          context: context,
          quality: 4.0,
          scale: 1.0,
          pageFormat: PageFormat.a4,
          margins: 40
        )
      ).then((file) {
        saveAndOpenStatement(file, 'Statement $state');
      });
    }

    Future<void> saveAndOpenStatement(Uint8List file, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedStatements');
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    final savedFile = File('${customDir.path}/$fileName.pdf');
    await savedFile.writeAsBytes(file);
    generateStatement('${customDir.path}/$fileName.pdf');
    await OpenFile.open('${customDir.path}/$fileName.pdf');
  }

  Future<void> openStatement(int statementNum) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedStatements');
    await OpenFile.open('${customDir.path}/Statement $statementNum.pdf');
  }

  Future<void> deleteSattementItem(int statementNum) async {
    deleteStatement(statementNum);
    await clientStatementServices.deleteClientStatement(statementNum);
    await userCreationServices.updateUser({
      'recent_statement': user!['recent_statement'] - 1,
    });
    await getUserData();
    getClientStatements();
  }

  Future<void> deleteStatement(int statementNum) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedStatements');
    final file = File('${customDir.path}/Statement $statementNum.pdf');
    if (await file.exists()) {
      file.delete();
    }
  }

   Future<void> mailStatement(int statementNum) async {
     final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: currentClient!['client_email'],
      queryParameters: {
        'subject': 'Statement $statementNum',
        'body': user!["default_email"]
      }
    );
    await launchUrl(emailLaunchUri);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _taskListController.dispose();
    _clientController.dispose();
    _posController.dispose();
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

    void activateDeleteState(int id, bool delete) {
      setState(() {
        deleteState = delete;
        state = id;
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
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                                )
                              ),
                              padding: EdgeInsets.only(
                                left: 50,
                                right: 50,
                                top: 20
                              ),
                              width: screenWidth * 0.25,
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
                                        currentClient == null ? "" : currentClient!['client_contact_number'].toString().padLeft(10, '0'),
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
                                    children: [
                                      Text(
                                        "Payment Term (days): ",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        currentClient == null ? "" : currentClient!['client_payment_term'].toString(),
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
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                                )
                              ),
                              padding: EdgeInsets.only(
                                left: 50,
                                right: 50,
                                top: 20
                              ),
                              width: screenWidth * 0.2,
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
                        )
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColor
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
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
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
                                        "Units",
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentClientTaskList.length,
                                itemBuilder: (context, index) {
                                  final task = currentClientTaskList[index];
                                  return ClientTimeTaskListItem(
                                    id: task['id'], 
                                    task: task['task_fk'], 
                                    pos: task['pos_fk'], 
                                    client: task['client_fk'], 
                                    date: task['date'], 
                                    hours: task['hours'].toString(), 
                                    invoiced: task['invoiced'], 
                                    rowColor: Theme.of(context).primaryColor, 
                                    deleteFunc: activateDelete,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                      child: Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColor
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
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
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
                                          getUninvoicedTasks();
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentClientInvoices.length,
                                itemBuilder: (context, index) {
                                  final inv = currentClientInvoices[index];
                                  return InkWell(
                                    onTap: () {
                                      openFile(inv['invoice_number']);
                                    },
                                    child: ClientListInvoice(invoiceNum: inv['invoice_number'], id: inv['id'], date: inv['date'], paid: inv['paid'], paidFunc: payInvoice, deleteFunc: activateDeleteInv, mailFunc: mailInvoice,),
                                  );
                                },
                              ),
                            )                           
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      ),
                      child: Container(
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColor,
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
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
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
                                        "Statements",
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
                                            genStatement = true;
                                            state = user!["recent_statement"] + 1;
                                          });
                                        },
                                        child: Text(
                                          "Generate Statement",
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: currentClientStatementList.length,
                                itemBuilder: (context, index) {
                                  final state = currentClientStatementList[index];
                                  return InkWell(
                                    onTap: () {
                                      openStatement(state['statement_number']);
                                    },
                                    child: ClientListStatement(statementNum: state['statement_number'], id: state['id'], date: state['date'], deleteFunc: activateDeleteState, mailFunc: mailStatement,),
                                  );
                                },
                              ),
                            ) 
                          ],
                        ),
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
                top: screenHeight * 0.15,
                bottom: screenHeight * 0.15,
                left: screenWidth * 0.35,
                right: screenWidth * 0.35,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    Column(
                      children: [
                        Text(
                          "Invoice Number:",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        Text(
                          inv.toString(),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 18
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 520,
                      child: ElevatedButton(
                        onPressed: () {
                          _selectDate();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          foregroundColor: Theme.of(context).highlightColor,
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 30
                          )
                        ),
                        child: Text(
                          today.toString().split(' ')[0],
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                                width: 1
                              )
                            ),
                            height: screenHeight * 0.3,
                            width: 1000,
                            child: Expanded(
                              child: ListView.builder(
                                itemCount: uninvoicedTasks.length,
                                itemBuilder: (context, index) {
                                  final task = uninvoicedTasks[index];
                                  return ClientInvoiceTask(
                                    id: task['id'], 
                                    task: task['task_fk'], 
                                    pos: task['pos_fk'], 
                                    date: task['date'], 
                                    hours: task['hours'], 
                                    client: currentClient!["client_bus_name"], 
                                    priceph: currentClient!["client_price_ph"],
                                    addTaskToInv: addTasktoInvoice,
                                    deleteTaskFromInv: deleteTaskFromInvoice,
                                    updateInvoiced: updateTimeTaskInvoiced,
                                  );
                                },
                              ),
                            )
                          ),                          
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                genInv = false;
                              });
                              clearControllers();
                              createPDF();
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
        ),
        Visibility(
          visible: deleteState,
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
                        "Are you sure you want to delete this Statement?",
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
                            deleteSattementItem(state); 
                            setState(() {
                              deleteState = false;
                            });                          
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
                              deleteState = false;
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
          visible: genStatement,
          child: Positioned(
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ),
                padding: EdgeInsets.only(
                  top: screenHeight * 0.33,
                  bottom: screenHeight * 0.33,
                  left: screenWidth * 0.33,
                  right: screenWidth * 0.33,
                ),
                child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8), // Shadow color
                      spreadRadius: 3, // How much the shadow expands
                      blurRadius: 5, // Softness of the shadow
                      offset: Offset(0, 5), // Position changes (x, y)
                    ),
                  ],
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
                              genStatement = false;
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: Text(
                            "Generate Statement",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 30,),
                        Text(
                          "Statement Number: ${state.toString()}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              _selectDateOne();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorLight,
                              foregroundColor: Theme.of(context).highlightColor,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30
                              )
                            ),
                            child: Text(
                              statementStart,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "-",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                            fontSize: 18
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              _selectDateTwo();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorLight,
                              foregroundColor: Theme.of(context).highlightColor,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30
                              ),
                            ),
                            child: Text(
                              statementEnd,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              genStatement = false;
                            });
                            getTermInvoices();
                            createStatementPDF();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            foregroundColor: Theme.of(context).highlightColor,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Generate",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ),
            )
          ),
        ),
      ]
    );
  }
}