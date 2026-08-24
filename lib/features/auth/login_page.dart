import 'package:bcrypt/bcrypt.dart';
import 'package:customer_timesheet_and_invoicing/core/storage.dart';
import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/data/app_database.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/features/homepage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  bool inputerr = false;

  bool checkPassword(String hashed, String enteredPassword) {
    return BCrypt.checkpw(enteredPassword, hashed);
  }

 Future<void> login() async {
  final savedPassword = await SecureStorageService.storage.read(key: 'app_password');
  if (checkPassword(savedPassword!, _passwordController.text)){
    setState(() {
      inputerr = false;
    });
    await AppDatabase.instance.getDatabase();
    loginNav();
  }
  else {
    setState(() {
      inputerr = true;
    });
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
      backgroundColor: Theme.of(context).primaryColorDark,
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
                width: inputerr ? 300 : 150,
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
                    SizedBox(width: 20,),
                    Text(
                      inputerr ? "Password Incorrect." : "",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 18
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColorDark,
        height: 48,
        child: Text(
          "\u00a9 ${DateTime.now().year} Chris Designed. All Rights Reserved.",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}