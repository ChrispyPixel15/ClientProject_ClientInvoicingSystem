import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';

class SetupThree extends StatefulWidget {
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

  const SetupThree({
    super.key, 
    required this.onPressed,
    required this.updateUser,
  });

  State<SetupThree> createState() => _SetupThreeState();
}

class _SetupThreeState extends State<SetupThree> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String hashPassword(String pass) {
    final hashed = BCrypt.hashpw(pass, BCrypt.gensalt());
    return hashed;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              "Application Password",
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
          CustomTextInput(labelName: "Password *", hintText: "Password...", password: true, inputController: _passwordController,),
          SizedBox(
            height: 20,
          ),
          CustomTextInput(labelName: "Confirm Password *", hintText: "Confirm Password...", password: true, inputController: _confirmPasswordController,),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: 500,
            child: Text(
              "PLEASE NOTE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: Text(
              "This password gives you access to your data that is encrypted locally.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 500,
            child: Text(
              "DO NOT LOSE THIS PASSWORD. NO PASSWORD RECOVERY IS POSSIBLE. A FORGOTTEN PASSWORD WILL LEAD TO LOST DATA.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  if (_passwordController.text == _confirmPasswordController.text) {
                    widget.updateUser(
                      password: hashPassword(_passwordController.text),
                    );
                    widget.onPressed();
                  }                  
                }, 
                child: Text(
                  "Done",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 18
                  ),
                ),
              ),
            )
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }  
}