import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:flutter/material.dart';

class SetupTwo extends StatefulWidget {
  final VoidCallback onPressed;
  final Function({
    String? userName, 
    String? busName, 
    String? number, 
    String? userEmail,
    String? vatRegistered,
    int? vatNum, 
    int? vatPercentage,
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
  }) updateUser;

  const SetupTwo({
    super.key, 
    required this.onPressed,
    required this.updateUser,
  });

  State<SetupTwo> createState() => _SetupTwoState();
}

class _SetupTwoState extends State<SetupTwo> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _branchCodeController = TextEditingController();
  final TextEditingController _bicController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _suburbController.dispose();
    _postalCodeController.dispose();
    _bankController.dispose();
    _branchCodeController.dispose();
    _bicController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 100,
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 500,
                child: Text(
                  "Address",
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
              CustomTextInput(labelName: "Street Address *", hintText: "Street Adress...", password: false, inputController: _streetController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "City *", hintText: "City...", password: false, inputController: _cityController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "Suburb *", hintText: "Suburb...", password: false, inputController: _suburbController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "Postal Code *", hintText: "Postal Code...", password: false, inputController: _postalCodeController,),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 500,
                child: Text(
                  "Bank Account",
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
              CustomTextInput(labelName: "Bank *", hintText: "Bank...", password: false, inputController: _bankController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "Branch Code *", hintText: "Branch Code...", password: false, inputController: _branchCodeController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "BIC", hintText: "BIC...", password: false, inputController: _bicController,),
              SizedBox(
                height: 20,
              ),
              CustomTextInput(labelName: "Account Number *", hintText: "Account Number...", password: false, inputController: _accountNumberController,),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 500,
                child: Container(
                  alignment: Alignment.topRight,
                  child: ElevatedButton(
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
                      widget.updateUser(
                        streetAddress: _streetController.text,
                        city: _cityController.text,
                        suburb: _suburbController.text,
                        postalCode: int.parse(_postalCodeController.text),
                        bank: _bankController.text,
                        branchCode: int.parse(_branchCodeController.text),
                        bic: int.parse(_bicController.text),
                        accountNumber: int.parse(_accountNumberController.text),
                      );
                      widget.onPressed();                      
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }  
}