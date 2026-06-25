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
  final TextEditingController _vatNumberController = TextEditingController();
  final TextEditingController _vatPercentageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _busNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _invoiceController.dispose();
    _vatNumberController.dispose();
    _vatPercentageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                    userName: _nameController.text,
                    busName: _busNameController.text,
                    number: _numberController.text,
                    userEmail: _emailController.text,
                    vatRegistered: widget.vatRegistered.toString(),
                    vatNum: int.parse(_vatNumberController.text),
                    vatPercentage: int.parse(_vatPercentageController.text),
                    recentInvoice: int.parse(_invoiceController.text),
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
    );
  }  
}