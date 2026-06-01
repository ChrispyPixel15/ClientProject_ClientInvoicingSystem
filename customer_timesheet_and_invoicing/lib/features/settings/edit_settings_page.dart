import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:flutter/material.dart';

class EditSettings extends StatefulWidget {
  final Function(int pageNum, String pageName, String id, bool drawerClosed) onEditPressed;

  const EditSettings ({super.key, required this.onEditPressed});

  State<EditSettings> createState() => _EditSettingsState();
}

class _EditSettingsState extends State<EditSettings> {
  Map<String, dynamic>? user;
  final userCreationServices = UserProfileServices();
  bool vatReg = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _recentInvoice = TextEditingController();
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _branchCodeController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final result = await userCreationServices.getUserProfile();
    setState(() {
      user = result;
      _nameController.text = result!['name'] == null ? "" : result['name'];
      _busNameController.text = result['business_name'] ?? result['business_name'];
      _numberController.text = result['number'].toString();
      _emailController.text = result['email'] ?? result['email'];
      _recentInvoice.text = result['recent_invoice'].toString();
      _vatNumberController.text = result['vat_number'].toString();
      _vatPercentageController.text = result['vat_percentage'].toString();
      _streetAddressController.text = result['street_address'] ?? result['street_address'];
      _cityController.text = result['city'] ?? result['city'];
      _suburbController.text = result['suburb'] ?? result['suburb'];
      _postalCodeController.text = result['postal_code'].toString();
      _bankController.text = result['bank'] ?? result['bank'];
      _branchCodeController.text = result['branch_code'].toString();
      _bicController.text = result['bic'].toString();
      _accountNumberController.text = result['account_number'].toString();
      vatReg = result["vat_registered"] == "true" ? true : false;
    });
  }

  Future<void> updateUserProfile() async {
    await userCreationServices.updateUser({
      'name': _nameController.text,
      'business_name': _busNameController.text,
      'number': _numberController.text,
      'email': _emailController.text,
      'recent_invoice': int.parse(_recentInvoice.text),
      'vat_registered': vatReg == true ? "true" : "false",
      'vat_number': int.parse(_vatNumberController.text),
      'vat_percentage': int.parse(_vatPercentageController.text),
      'street_address': _streetAddressController.text,
      'city': _cityController.text,
      'suburb': _suburbController.text,
      'postal_code': int.parse(_postalCodeController.text),
      'bank': _bankController.text,
      'branch_code': int.parse(_branchCodeController.text),
      'bic': int.parse(_bicController.text),
      'account_number': int.parse(_accountNumberController.text),
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _busNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _vatNumberController.dispose();
    _vatPercentageController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _suburbController.dispose();
    _postalCodeController.dispose();
    _bankController.dispose();
    _branchCodeController.dispose();
    _bicController.dispose();
    _accountNumberController.dispose();
    _recentInvoice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(
                left: 50,
                right: 50,
                top: 5
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Business Details",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Name...", password: false, inputController: _nameController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Business Name:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Business Name...", password: false, inputController: _busNameController
                      )
                     ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Phone Number:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Phone Number...", password: false, inputController: _numberController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Email...", password: false, inputController: _emailController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Last Invoice Number:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Invoice Number...", password: false, inputController: _recentInvoice
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT Registered:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          value: vatReg, 
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
                              vatReg = vatReg ? false : true;
                            });
                          }),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT Number:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "VAT Number...", password: false, inputController: _vatNumberController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT Percentage:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "VAT Percentage...", password: false, inputController: _vatPercentageController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Street Address:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Stree Address...", password: false, inputController: _streetAddressController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "City:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "City...", password: false, inputController: _cityController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Suburb:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Suburb...", password: false, inputController: _suburbController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Postal Code:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Postal Code...", password: false, inputController: _postalCodeController
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(
                left: 50,
                right: 50,
                top: 5
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Bank Account",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bank:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Bank...", password: false, inputController: _bankController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Branch Code:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Branch Code...", password: false, inputController: _branchCodeController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "BIC:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "BIC...", password: false, inputController: _bicController
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Number:",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.w400,
                          fontSize: 18
                        ),
                      ),
                      CustomTextInput(
                        labelName: "", hintText: "Account Number...", password: false, inputController: _accountNumberController
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColorLight,
                          foregroundColor: Theme.of(context).primaryColorDark,
                          elevation: 5,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 30
                          )
                        ),
                        onPressed: () {
                          updateUserProfile();
                          widget.onEditPressed(2, "Settings", "", true);
                        }, 
                        child: Text(
                          "Done",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 18
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }
}