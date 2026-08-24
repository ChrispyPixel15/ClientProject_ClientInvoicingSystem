import 'dart:ffi';
import 'dart:io';

import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/data/services/client_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/invoice_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/components/client_list_item.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/statements/client_statement_template.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/statements/personal_statement_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_maker/pdf_maker.dart';

class Clients extends StatefulWidget {
  final Function(int pageNum, String pageTitle, String clientID, bool drawerClosed) onClientPressed;

  const Clients ({super.key, required this.onClientPressed});

  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  bool addClient = false;
  bool deleteBool = false;
  bool editClient = false;
  bool statement = false;

  String selectedClientID = '';

  final clientServices = ClientCreationServices();
  final invoiceServices = InvoiceCreationServices();
  final userCreationServices = UserProfileServices();
  Map<String, dynamic>? user;

  String statementStart = "Start Date";
  String statementEnd = "End Date";

  DateTime? dateOne;
  DateTime? dateTwo;

  bool inputerr = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _suburbController= TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _quotePriceController = TextEditingController();
  final TextEditingController _paymentTermsController = TextEditingController();
  List<Map<String, dynamic>> clientList = [];
  List<Map<String, dynamic>> invoiceList = [];
  List<Map<String, dynamic>> invoicesInTerm = [];

  @override
  void initState() {
    super.initState();
    loadClients();
    getInvoices();
    getUserData();
  }

  Future<void> getUserData() async {
    final result = await userCreationServices.getUserProfile();
    setState(() {
      user = result;
    });
  }

  Future<void> loadClients() async {
    final result = await clientServices.getClients();
    setState(() {
      clientList = result;
    });
  }

  Future<void> getInvoices() async {
    final result = await invoiceServices.getInvoices();
    setState(() {
      invoiceList = result;
    });
  }

  Future<void> addNewClient(
    String name, 
    String contactName, 
    String number, 
    String email, 
    int vatNum, 
    String address,
    String suburb,
    String city,
    int postalCode,
    double quotePrice,
    int paymentTerm,
  ) async {
    String newIDLetters = name.substring(0, 2).toUpperCase();
    String newIDNumbers = DateTime.now().hashCode.toString();

    await clientServices.createClient({
      'id': newIDLetters + newIDNumbers,
      'client_bus_name': name,
      'client_contact_person': contactName,
      'client_contact_number': number,
      'client_email': email,
      'client_vatNumber': vatNum,
      'client_street_address': address,
      'client_suburb': suburb,
      'client_city': city,
      'client_postal_code': postalCode,
      'client_price_ph': quotePrice,
      'client_payment_term': paymentTerm,
      'status': "active",
      'unpaid_invoices': 0,
    }, );
    await loadClients();
  }

  Future<void> deleteClient({String? id}) async {
    await clientServices.deleteClient(id, );
    loadClients();
  }

  Future<void> updateClientStatus({String? id, String? status}) async {
    await clientServices.updateClient(id, {
      'status': status,
    }, );
    loadClients();
  }

  Future<void> editClientInfo(
    String? id,
    String name, 
    String contactPerson, 
    String contactNum, 
    String email, 
    int vatNum, 
    String address, 
    String suburb, 
    String city, 
    int postalCode,
    double quotePrice,
    int paymentTerm,) async {
    await clientServices.updateClient(id, {
      'client_bus_name': name,
      'client_contact_person': contactPerson,
      'client_contact_number': contactNum,
      'client_email': email,
      'client_vatNumber': vatNum,
      'client_street_address': address,
      'client_suburb': suburb,
      'client_city': city,
      'client_postal_code': postalCode,
      'client_price_ph': quotePrice,
      'client_payment_term': paymentTerm,
    }, );
    loadClients();
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

    List<Map<String, dynamic>> newInvoices = List<Map<String, dynamic>>.from(invoiceList.where((invoice) {
      return (dateFormat.parse(invoice["date"]).isAfter(dateOne ?? DateTime.now()) || dateFormat.parse(invoice["date"]).isAtSameMomentAs(dateOne ?? DateTime.now())) &&
      (dateFormat.parse(invoice["date"]).isBefore(dateTwo ?? DateTime.now()) || dateFormat.parse(invoice["date"]).isAtSameMomentAs(dateTwo ?? DateTime.now()));
    }));

    for (var invoice in List.from(newInvoices))  {
      if (invoice["paid"] == "true") {
        newInvoices.add({
          'invoice_number': invoice['invoice_number'],
          'item': "paid",
          'date': invoice["date_paid"],
          'total_amount': invoice['total_amount'],
        });
      }
    }

    newInvoices.sort((a, b) => dateFormat.parse(a["date"]).compareTo(dateFormat.parse(b["date"])));

    invoicesInTerm = newInvoices;
  }

  Future<void> createStatementPDF() async {

    PDFMaker maker = PDFMaker();

    maker.createPDF(
      PersonalStatementTemplate(
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
      saveAndOpenStatement(file, 'PersonalStatement');
    });
  }

  Future<void> saveAndOpenStatement(Uint8List file, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final customDir = Directory('${dir.path}/SavedStatements');
    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }
    String base = fileName;
    String path = '${customDir.path}/$base.pdf';
    int counter = 1;

    while (await File(path).exists()) {
      path = '${customDir.path}/$base($counter).pdf';
      counter++;
    }


    final savedFile = File(path);
    await savedFile.writeAsBytes(file);
    await OpenFile.open(path);
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _contactNumberController.dispose();
    _contactPersonController.dispose();
    _vatNumberController.dispose();
    _emailController.dispose();
    _streetAddressController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _searchController.dispose();
    _quotePriceController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void activateDelete(String id, bool delete) {
      setState(() {
        deleteBool = delete;
        selectedClientID = id;
      });
    }

    bool checkInputs() {
      if (
        _clientNameController.text.trim().isEmpty || 
        _contactNumberController.text.trim().isEmpty ||
        _contactPersonController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _streetAddressController.text.trim().isEmpty ||
        _suburbController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty ||
        _postalCodeController.text.trim().isEmpty ||
        _quotePriceController.text.trim().isEmpty ||
        _paymentTermsController.text.trim().isEmpty 
      ) {
        return false;
      }
      else {
        return true;
      }
    }

    void activateEdit(String id, bool edit) async {
      final result = await clientServices.getClient(id, );
      _clientNameController.text = result!["client_bus_name"];
      _contactNumberController.text = result["client_contact_number"].toString();
      _contactPersonController.text = result["client_contact_person"];
      _vatNumberController.text = result["client_vatNumber"].toString();
      _emailController.text = result["client_email"];
      _streetAddressController.text = result["client_street_address"];
      _suburbController.text = result["client_suburb"];
      _cityController.text = result["client_city"];
      _postalCodeController.text = result["client_postal_code"].toString();
      _quotePriceController.text = result["client_price_ph"].toString();
      _paymentTermsController.text = result["client_payment_term"].toString();
      setState(() {
        editClient = edit;
        selectedClientID = id;
      });
    }

    void clearControllers() {
      _clientNameController.clear();
      _contactNumberController.clear();
      _contactPersonController.clear();
      _vatNumberController.clear();
      _emailController.clear();
      _streetAddressController.clear();
      _suburbController.clear();
      _cityController.clear();
      _postalCodeController.clear();
      _quotePriceController.clear();
      _paymentTermsController.clear();
    }

    return Stack(
      children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Container(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(80, 0, 0, 0),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 5),
                                )
                              ]
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                height: 1.0,
                                color: Theme.of(context).textTheme.bodySmall?.color
                              ),
                              decoration: InputDecoration(
                                fillColor: Theme.of(context).primaryColor,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(103, 103, 103, 1),
                                    width: 4.0,
                                  )
                                ),
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: const Color.fromARGB(255, 104, 104, 104),
                                ),
                              // prefixIcon: Icon(
                              //     Icons.search,
                              //     color: Theme.of(context).highlightColor,
                              //   ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  addClient = true;
                                });
                                clearControllers();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColorLight,
                                foregroundColor: Theme.of(context).primaryColorDark
                              ),
                              child: Text(
                                "New Client",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  statement = true;
                                });
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColorLight,
                                foregroundColor: Theme.of(context).primaryColorDark,
                              ),
                              child: Text(
                                "Generate Invoice Statement",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(
                      left: 30,
                      right: 30
                    ),
                    child: Container(
                      height: screenHeight * 0.8,
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
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 8,
                                      top: 3,
                                      bottom: 3
                                    ),
                                    child: Text(
                                      "Client Name",
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
                                      "Client ID",
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
                                      "Status",
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
                                      "Unpaid Invoices",
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
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                                child: ListView.builder(
                                  itemCount: clientList.length,
                                  itemBuilder: (context, index) {
                                    final client = clientList[index];
                                      return InkWell(
                                      onTap: () {
                                        if (client['status'] == "active") {
                                          widget.onClientPressed(3, client['client_bus_name'], client['id'], true);
                                        }                                    
                                      },
                                      child: ClientListItem(clientName: client['client_bus_name'], clientID: client['id'], clientStatus: client['status'], unpaidInvoices: client['unpaid_invoices'], rowColor: Theme.of(context).primaryColor, deletFunc: activateDelete, statusFunc: updateClientStatus, editFunc: activateEdit,),
                                    );
                                  },
                                ),
                              )
                        ],
                      ),
                    )
                  ),
                ],
              ),
            ),
          ),
        Visibility(
          visible: addClient,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.11,
                bottom: screenHeight * 0.11,
                left: screenWidth * 0.20,
                right: screenWidth * 0.20,
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
                              addClient = false;
                            });
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
                            "New Client",
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
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Client Name*", hintText: "Client Name...", password: false, inputController: _clientNameController),
                          CustomTextInput(labelName: "Street Address*", hintText: "Street Address...", password: false, inputController: _streetAddressController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Contact Person*", hintText: "Contact Person...", password: false, inputController: _contactPersonController),
                          CustomTextInput(labelName: "Suburb*", hintText: "Suburb...", password: false, inputController: _suburbController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Contact Number*", hintText: "Contact Number...", password: false, inputController: _contactNumberController),
                          CustomTextInput(labelName: "City*", hintText: "City...", password: false, inputController: _cityController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Email*", hintText: "Email...", password: false, inputController: _emailController),
                          CustomTextInput(labelName: "Postal Code*", hintText: "Postal Code...", password: false, inputController: _postalCodeController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "VAT Number", hintText: "VAT Number...", password: false, inputController: _vatNumberController),
                          CustomTextInput(labelName: "Quoted Price Per Unit*", hintText: "Quoted Price...", password: false, inputController: _quotePriceController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Payment Term in Days*", hintText: "Payment Term...", password: false, inputController: _paymentTermsController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: Row(
                            children: [
                              Text(
                                inputerr ? "Please Complete All Inputs Marked With *." : "",
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 18
                                ),
                              ),
                              SizedBox(width: 20,),
                              ElevatedButton(
                                onPressed: () {
                                  if (checkInputs() == true) {
                                    addNewClient(
                                      _clientNameController.text, 
                                      _contactPersonController.text, 
                                      _contactNumberController.text,
                                      _emailController.text, 
                                      _vatNumberController.text.trim().isEmpty ? 0 : int.parse(_vatNumberController.text), 
                                      _streetAddressController.text, 
                                      _suburbController.text, 
                                      _cityController.text, 
                                      int.parse(_postalCodeController.text),
                                      double.parse(_quotePriceController.text),
                                      int.parse(_paymentTermsController.text),
                                    );
                                    setState(() {
                                      addClient = false;
                                      inputerr = false;
                                    });
                                  }
                                  else {
                                    setState(() {
                                      inputerr = true;
                                    });
                                  }
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
          visible: deleteBool,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.35,
                bottom: screenHeight * 0.35,
                left: screenWidth * 0.35,
                right: screenWidth * 0.35,
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
                        "Are you sure you want to delete this Client?",
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
                            deleteClient(id: selectedClientID);
                            deleteBool = false;
                            selectedClientID = '';
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
                              selectedClientID = '';
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
          visible: editClient,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.15,
                bottom: screenHeight * 0.15,
                left: screenWidth * 0.20,
                right: screenWidth * 0.20,
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
                              editClient = false;
                            });
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
                            "Edit Client",
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
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Client Name", hintText: "Client Name...", password: false, inputController: _clientNameController),
                          CustomTextInput(labelName: "Street Address", hintText: "Street Address...", password: false, inputController: _streetAddressController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Contact Person", hintText: "Contact Person...", password: false, inputController: _contactPersonController),
                          CustomTextInput(labelName: "Suburb", hintText: "Suburb...", password: false, inputController: _suburbController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Contact Number", hintText: "Contact Number...", password: false, inputController: _contactNumberController),
                          CustomTextInput(labelName: "City", hintText: "City...", password: false, inputController: _cityController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Email", hintText: "Email...", password: false, inputController: _emailController),
                          CustomTextInput(labelName: "Postal Code", hintText: "Postal Code...", password: false, inputController: _postalCodeController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "VAT Number", hintText: "VAT Number...", password: false, inputController: _vatNumberController),
                          CustomTextInput(labelName: "Quoted Price p/h", hintText: "Quoted Price...", password: false, inputController: _quotePriceController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextInput(labelName: "Payment Term in Days", hintText: "Payment Term...", password: false, inputController: _paymentTermsController),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              editClientInfo(
                                selectedClientID,
                                _clientNameController.text, 
                                _contactPersonController.text, 
                                _contactNumberController.text,
                                _emailController.text, 
                                _vatNumberController.text.trim().isEmpty ? 0 : int.parse(_vatNumberController.text), 
                                _streetAddressController.text, 
                                _suburbController.text, 
                                _cityController.text, 
                                int.parse(_postalCodeController.text),
                                double.parse(_quotePriceController.text),
                                int.parse(_paymentTermsController.text),
                              );
                              setState(() {
                                editClient = false;
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
                              "Done",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
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
          visible: statement,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8),
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
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark,
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5),
                    ),
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
                              statement = false;
                            });
                          },
                        ),                      
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
                              fontWeight: FontWeight.w400
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 20,),
                        
                      ],
                    ),
                    SizedBox(height: 30,),
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
                                      statement = false;
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
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}