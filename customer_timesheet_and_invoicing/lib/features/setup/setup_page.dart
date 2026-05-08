import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/data/models/user_model.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/auth/login_page.dart';
import 'package:customer_timesheet_and_invoicing/features/setup/setup_one.dart';
import 'package:customer_timesheet_and_invoicing/features/setup/setup_three.dart';
import 'package:customer_timesheet_and_invoicing/features/setup/setup_two.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  final ThemeController themeController;
  const SetupPage({super.key, required this.themeController});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  int setupIndex = 0;
  bool vatRegistered = false;

  final UserDraft _draft = UserDraft();

  void updateUserDraft({
    String? userName, 
    String? busName, 
    String? number, 
    String? userEmail,
    String? vatRegistered,
    int? vatNum, 
    int? vatPercent,
    int? recentInvoice,
    String? streetAddress, 
    String? city, 
    String? suburb, 
    int? postalCode,
    String? bank, 
    int? branchCode, 
    int? bic,
    int? accountNumber, 
    String? theme, 
    String? password, 
  }) {
    setState(() {
      _draft.id = 1;
      if (userName != null) _draft.name = userName;
      if (busName != null) _draft.businessName = busName;
      if (number != null) _draft.number = number;
      if (userEmail != null) _draft.email = userEmail;
      if (vatRegistered != null) _draft.vatRegistered = vatRegistered;
      if (vatNum != null) _draft.vatNumber = vatNum;
      if (recentInvoice != null) _draft.recentInvoice = recentInvoice;
      if (streetAddress != null) _draft.streetAddress = streetAddress;
      if (city != null) _draft.city = city;
      if (suburb != null) _draft.suburb = suburb;
      if (postalCode != null) _draft.postalCode = postalCode;
      if (bank != null) _draft.bank = bank;
      if (branchCode != null) _draft.branchCode = branchCode;
      if (bic != null) _draft.bic = bic;
      if (accountNumber != null) _draft.accountNumber = accountNumber;
      if (theme != null) _draft.theme = theme;
      if (password != null) _draft.password = password;
    });
    debugPrint(_draft.name);
  }

  void updateIndex() {
    checkIndex();
    setState(() {
      setupIndex ++;
    });
  }

  void finalUserSetup() async {
    final userService = UserProfileServices();

    await userService.saveUserProfile({
      'id': 1,
      'name': _draft.name,
      'business_name': _draft.businessName,
      'number': _draft.number,
      'email': _draft.email,
      'vat_registered': _draft.vatRegistered,
      'vat_number': _draft.vatNumber,
      'vat_percentage': _draft.vatPercentage,
      'street_address': _draft.streetAddress,
      'city': _draft.city,
      'suburb': _draft.suburb,
      'postal_code': _draft.postalCode,
      'bank': _draft.bank,
      'branch_code': _draft.branchCode,
      'bic': _draft.bic,
      'account_number': _draft.accountNumber,
      'theme': 'dark',
      'password': _draft.password,
    });

    var user = userService.getUserProfile();
    debugPrint(user.toString());
  }

  void isVatRegistered(bool? value) {
    setState(() {
      vatRegistered = value ?? false;
    });
  }

  void checkIndex() {
    if (setupIndex >= 2) {
      finalUserSetup();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(themeController: widget.themeController),
        ),
      );
    }
  }  

  @override
  Widget build(BuildContext context) {
    Widget setuppage;
    switch (setupIndex) {
      case 0:
        setuppage = SetupOne( 
          onPressed: updateIndex, 
          onChecked: isVatRegistered, 
          vatRegistered: vatRegistered,
          updateUser: updateUserDraft,
        );
        break;
      case 1:
        setuppage = SetupTwo( 
          onPressed: updateIndex,
          updateUser: updateUserDraft,
        );
        break;
      case 2: 
        setuppage = SetupThree( 
          onPressed: checkIndex,
          updateUser: updateUserDraft,
        );
        break;
      default:
        throw UnimplementedError('No page for selected index.');
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Setup")
        ),
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 500,
              child: Text(
                "All information collected for the sole purpose of generating invoices and statements. Information is only saved locally.",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 16,
                ),
                softWrap: true,
              ),
            ),
            SizedBox(
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Fields marked with * are required",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            setuppage,
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}

class UserDraft {
  int? id;
  String? name;
  String? businessName;
  String? number;
  String? email;
  String? vatRegistered;
  int? vatNumber;
  int? vatPercentage;
  int? recentInvoice;
  String? streetAddress;
  String? city;
  String? suburb;
  int? postalCode;
  String? bank;
  int? branchCode;
  int? bic;
  int? accountNumber;
  String? theme;
  String? password;
}