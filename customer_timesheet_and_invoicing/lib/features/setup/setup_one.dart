import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:flutter/material.dart';

class SetupOne extends StatefulWidget {
  final VoidCallback onPressed;
  final Function(bool?) onChecked;
  final bool vatRegistered;
  final Function({
    String? userName, 
    String? busName, 
    String? number, 
    String? userEmail,
    String? vatRegistered,
    int? vatNum, 
    int? vatPercentage,
    int? recentInvoice,
    int? resentStatement,
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
  }) updateUser;

  const SetupOne({
    super.key, 
    required this.onPressed, 
    required this.onChecked, 
    required this.vatRegistered,
    required this.updateUser,
  });  

  State<SetupOne> createState() => _SetupOneState();
}

class _SetupOneState extends State<SetupOne> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();

  bool inputerr = false;

  @override
  void dispose() {
    _nameController.dispose();
    _busNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _invoiceController.dispose();
    _statementController.dispose();
    _vatNumberController.dispose();
    _vatPercentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool checkInputs() {
      if (_nameController.text.trim().isEmpty || _busNameController.text.trim().isEmpty || _numberController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
        return false;
      }
      else {
        return true;
      }
    }

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 500,
            child: Text(
              "Business Details",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Name *", hintText: "Name...", password: false, inputController: _nameController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Bussiness Name", hintText: "Business Name...", password: false, inputController: _busNameController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Phone Number *", hintText: "Phone Number...", password: false, inputController: _numberController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Email *", hintText: "Email...", password: false, inputController: _emailController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Most Recent Invoice Number *", hintText: "Invoice Number...", password: false, inputController: _invoiceController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Most Recent Statement Number *", hintText: "Statement Number...", password: false, inputController: _statementController,),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 530,
            child: CheckboxListTile(
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
              checkboxShape: CircleBorder(),
              checkboxScaleFactor: 1.5,
              value: widget.vatRegistered,
              onChanged: (value) => widget.onChecked(value ?? false),
              title: Text(
                "Are you VAT Registered?",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              )
            ),
          ),
          Visibility(
            visible: widget.vatRegistered,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(labelName: "VAT Number *", hintText: "VAT Number...", password: false, inputController: _vatNumberController,),
                SizedBox(
                  height: 20,
                ),
                CustomTextInput(labelName: "VAT Percentage *", hintText: "VAT Percentage...", password: false, inputController: _vatPercentageController,),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: Container(
              alignment: Alignment.topRight,
              child: Row(
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
                      if (checkInputs() == true) {
                        widget.updateUser(
                          userName: _nameController.text,
                          busName: _busNameController.text,
                          number: _numberController.text,
                          userEmail: _emailController.text,
                          vatRegistered: widget.vatRegistered.toString(),
                          vatNum: _vatNumberController.text.trim().isEmpty ? 0 : int.parse(_vatNumberController.text),
                          vatPercentage: _vatPercentageController.text.trim().isEmpty ? 0 : int.parse(_vatPercentageController.text),
                          recentInvoice: _invoiceController.text.trim().isEmpty ? 0 : int.parse( _invoiceController.text),
                          resentStatement: _statementController.text.trim().isEmpty ? 0 : int.parse(_statementController.text),
                        );
                        widget.onPressed();
                      }
                      else {
                        setState(() {
                          inputerr = true;
                        });
                      }
                    }, 
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 18
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text(
                    inputerr ? "Please Complete All Relevant Inputs." : "",
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 18
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }  
}