import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String labelName;
  final String hintText;
  final bool password;
  final TextEditingController inputController;

  CustomTextInput({
    super.key, 
    required this.labelName, 
    required this.hintText,
    required this.password,
    required this.inputController
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 500,
            child: Text(
              labelName,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            width: 530,
            child: Container(
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
                controller: inputController,
                style: TextStyle(
                  height: 1.0,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                decoration: InputDecoration(
                  fillColor: Theme.of(context).primaryColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                      width: 1.0,
                    )
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Theme.of(context).highlightColor,
                      width: 1.0,
                    )
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 104, 104, 104),
                  )
                ),
                obscureText: password,
              ),
            ),
          ),
      ],
    );
  }
}