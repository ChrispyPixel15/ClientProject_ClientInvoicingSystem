import 'package:bcrypt/bcrypt.dart';
import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/homepage/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final ThemeController themeController;

  const LoginPage({
    super.key,
    required this.themeController
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  bool checkPassword(String hashed, String enteredPassword) {
    return BCrypt.checkpw(enteredPassword, hashed);
  }

 Future<void> login() async {
  final userService = UserProfileServices();
  final user = await userService.getUserProfile();
  if (checkPassword(user?['password'], _passwordController.text)){
    loginNav();
  }
 }

  void loginNav() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(themeController: widget.themeController),
        ),
      );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 250,
              ),
              SizedBox(
                child: Text(
                  "Log In",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextInput(labelName: "Password", hintText: "Password...", password: true, inputController: _passwordController,),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    foregroundColor: Theme.of(context).primaryColorDark,
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 30
                    ),
                  ),
                  onPressed: login, 
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontSize: 18
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}