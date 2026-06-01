import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/data/services/pos_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/task_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/data/services/user_creation_service.dart';
import 'package:flutter/material.dart';

const List<Widget> themes = <Widget> [
  Text("Light"),
  Text("Dark")
];

class Settings extends StatefulWidget {
  final Function(int pageNum, String pageName, String id, bool drawerClosed) onEditPressed;
  final ThemeController themeController;

  const Settings ({super.key, required this.onEditPressed, required this.themeController});

  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic>? user;
  final List<bool> _selectedTheme = [false, true];
  final userCreationServices = UserProfileServices();
  final taskServices = TaskCreationService();
  final posService = PosCreationServices();
  bool editTasks = false;
  bool editPOS = false;

  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> posList = [];

  @override
  void initState() {
    super.initState();
    getUserData();
    loadTasks();
    getPoss();
  }

  Future<void> getUserData() async {
    final result = await userCreationServices.getUserProfile();
    setState(() {
      user = result;
      debugPrint(result.toString());
    });
  }

  Future<void> loadTasks() async {
    final result = await taskServices.getTaskItems();
    setState(() {
      taskList = result;
    });
  }

  Future<void> getPoss() async {
    final result = await posService.getPosItems();
    setState(() {
      posList = result;
    });
  }

  Future<void> deleteTask(String task) async {
    await taskServices.deleteTask(task);
    loadTasks();
  }
   Future<void> deletePOS(String task) async {
    await posService.deletePos(task);
    getPoss();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(
                  right: 50
                ),
                child: IconButton(
                  onPressed: () {
                    widget.onEditPressed(4, "Settings", "", true);
                  }, 
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Theme.of(context).highlightColor,
                  )
                )
              ),
            ],
          ),
        Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(
                left: 50,
                right: 50,
                top: 50
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
                  SizedBox(height: 25,),
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
                      Text(
                        user?["name"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["business_name"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                     ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["number"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["email"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["recent_invoice"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
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
                      Text(
                        user?["vat_registered"] == "true" ? "Yes" : "No",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["vat_number"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["vat_percentage"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40,),
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
                  SizedBox(height: 25,),
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
                      Text(
                        user?["street_address"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["city"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["suburb"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["postal_code"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
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
                top: 50
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
                  SizedBox(height: 25,),
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
                      Text(
                        user?["bank"] ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["branch_code"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["bic"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
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
                      Text(
                        user?["account_number"].toString() ?? "",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Theme",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ToggleButtons(
                        direction: Axis.horizontal,
                        isSelected: _selectedTheme,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedTheme.length; i ++) {
                              _selectedTheme[i] = i == index;
                            }
                            widget.themeController.toggleTheme();
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        borderColor: Theme.of(context).highlightColor,
                        selectedBorderColor: Theme.of(context).highlightColor,
                        selectedColor: Theme.of(context).textTheme.bodySmall?.color,
                        fillColor: Theme.of(context).primaryColorLight,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        disabledBorderColor: Theme.of(context).highlightColor,
                        hoverColor: Theme.of(context).primaryColorDark,
                        children: themes,                   
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Other Settings",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          setState(() {
                            editTasks = true;
                          });
                        }, 
                        child: Text(
                          "Edit Task List",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            fontSize: 18
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          setState(() {
                            editPOS = true;
                          });                          
                        }, 
                        child: Text(
                          "Edit POS List",
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
      ),
      Visibility(
        visible: editTasks,
        child: Positioned(
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ),
            padding: EdgeInsets.only(
              top: screenHeight * 0.18,
              bottom: screenHeight * 0.18,
              left: screenWidth * 0.35,
              right: screenWidth * 0.35,
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20
              ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8), // Shadow color
                      spreadRadius: 3, // How much the shadow expands
                      blurRadius: 5, // Softness of the shadow
                      offset: Offset(0, 5), // Position changes (x, y)
                    ),
                  ],
                ),
                width: double.infinity,
                child: SingleChildScrollView(
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
                                editTasks = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Edit Task List",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (var task in taskList)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            left: 10,
                            top: 10,
                            bottom: 10,
                            right: 10
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).highlightColor
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                task['task'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Color.fromARGB(255, 201, 3, 3),
                                    ),
                                    onPressed: () {
                                      deleteTask(task['task']);
                                    },
                                  ),
                                ],
                              )
                              
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
      Visibility(
        visible: editPOS,
        child: Positioned(
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
            ),
            padding: EdgeInsets.only(
              top: screenHeight * 0.18,
              bottom: screenHeight * 0.18,
              left: screenWidth * 0.35,
              right: screenWidth * 0.35,
            ),
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20
              ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8), // Shadow color
                      spreadRadius: 3, // How much the shadow expands
                      blurRadius: 5, // Softness of the shadow
                      offset: Offset(0, 5), // Position changes (x, y)
                    ),
                  ],
                ),
                width: double.infinity,
                child: SingleChildScrollView(
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
                                editPOS = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Edit POS List",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.left,
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      for (var pos in posList)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            left: 10,
                            top: 10,
                            bottom: 10,
                            right: 10
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).highlightColor
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pos['pos'],
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Color.fromARGB(255, 201, 3, 3),
                                    ),
                                    onPressed: () {
                                      deletePOS(pos['pos']);
                                    },
                                  ),
                                ],
                              )
                              
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
      ]
    );
  }
}

