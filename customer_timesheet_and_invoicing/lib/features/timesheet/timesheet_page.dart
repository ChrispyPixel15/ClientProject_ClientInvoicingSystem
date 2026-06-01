import 'package:customer_timesheet_and_invoicing/core/text_input.dart';
import 'package:customer_timesheet_and_invoicing/data/services/client_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/pos_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/data/services/task_creation_service.dart';
import 'package:customer_timesheet_and_invoicing/data/services/timesheet_task_creation_services.dart';
import 'package:customer_timesheet_and_invoicing/features/timesheet/components/timesheet_task_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Timesheet extends StatefulWidget {
  const Timesheet ({super.key});

  State<Timesheet> createState() => _TimesheetState();
}

class _TimesheetState extends State<Timesheet> {
  bool addTask = false;
  bool deleteBool = false;
  bool editTask = false;

  int selectedClientID = 0;

  final taskServices = TaskCreationService();
  final clientServices = ClientCreationServices();
  final posServices = PosCreationServices();
  final timesheetTaskServices = TimesheetTaskCreationServices();
  final TextEditingController _taskListController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _posController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();

  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> clientList = [];
  List<Map<String, dynamic>> posList = [];
  List<Map<String, dynamic>> timesheetTaskList = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
    getClients();
    getPoss();
    loadTimesheetTasks();
  }

  Future<void> loadTasks() async {
    final result = await taskServices.getTaskItems();
    setState(() {
      taskList = result;
    });
  }

  Future<void> addTasks(String task) async {
    await taskServices.createTaskItems({
      'task': task
    });
    await loadTasks();
  }

  Future<void> getClients() async {
    final result = await clientServices.getClients();
    setState(() {
      clientList = result;
    });
  }

  Future<void> getPoss() async {
    final result = await posServices.getPosItems();
    setState(() {
      posList = result;
    });
  }

  Future<void> addPos(String pos) async {
    await posServices.createPosItem({
      'pos': pos
    });
    await getPoss();
  }

  Future<void> loadTimesheetTasks() async {
    final result = await timesheetTaskServices.getTimesheetTasks();
    setState(() {
      timesheetTaskList = result;
    });
  }

  Future<void> addNewTimeTask(
    String task,
    String pos,
    String client,
    String date,
    int hours,
  ) async {
    await timesheetTaskServices.createTimesheetTask({
      'task_fk': task,
      'pos_fk': pos,
      'client_fk': client,
      'date': date,
      'hours': hours,
      'invoiced': "false",
    });
    await loadTimesheetTasks();
  }

  Future<void> deleteTimeTask(int id) async {
    await timesheetTaskServices.deleteTimehseetTask(id);
    loadTimesheetTasks();
  }

  Future<void> editTimeTask(int id, String task, String pos, String client, String date, int hours) async {
    await timesheetTaskServices.updateTimesheetTask(id, {
      'task_fk': task,
      'pos_fk': pos,
      'client_fk': client,
      'date': date,
      'hours': hours,
    });
    await loadTimesheetTasks();
  }

  @override
  void dispose() {
    _taskListController.dispose();
    _clientController.dispose();
    _posController.dispose();
    _dateController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    void activateDelete(int id, bool delete) {
      setState(() {
        deleteBool = delete;
        selectedClientID = id;
      });
    }

    void activateEdit(int id, bool edit, String task, String client, String pos, int hours, String date) {
      setState(() {
        editTask = edit;
        selectedClientID = id;
        _taskListController.text = task;
        _clientController.text = client;
        _posController.text = pos;
        _hoursController.text = hours.toString();
        _dateController.text = date;
      });
    }

    void clearControllers() {
      _taskListController.clear();
      _clientController.clear();
      _posController.clear();
      _dateController.clear();
      _hoursController.clear();
    }

    void sortByDate() {
      var changeableList = List<Map<String, dynamic>>.from(timesheetTaskList);
      final formatting = DateFormat("dd-MM-yyyy");
      changeableList.sort((a, b) {
        final dateA = formatting.parse(a["date"]);
        final dateB = formatting.parse(b["date"]);
        return dateB.compareTo(dateA);
      });

      setState(() {
        timesheetTaskList = changeableList;
      });      
    }

    void sortByTask() {
      var changeableList = List<Map<String, dynamic>>.from(timesheetTaskList);
      changeableList.sort((a, b) {
        final taskA = a["task_fk"];
        final taskB = b["task_fk"];
        return taskA.compareTo(taskB);
      });

      setState(() {
        timesheetTaskList = changeableList;
      });      
    }

    void sortByInvoiced() async {
      await loadTimesheetTasks();
      var changeableList = List<Map<String, dynamic>>.from(timesheetTaskList);
      var newList = List<Map<String, dynamic>>.from(changeableList.where((item) {
        return item["invoiced"].contains("false");
      }));

      setState(() {
        timesheetTaskList = newList;
      });         
    }

    void sortByPos() {
      var changeableList = List<Map<String, dynamic>>.from(timesheetTaskList);
      changeableList.sort((a, b) {
        final posA = a["pos_fk"];
        final posB = b["pos_fk"];
        return posA.compareTo(posB);
      });

      setState(() {
        timesheetTaskList = changeableList;
      });      
    }

    void sortByClient(name) async {
      await loadTimesheetTasks();
      var changeableList = List<Map<String, dynamic>>.from(timesheetTaskList);
      var newList = List<Map<String, dynamic>>.from(changeableList.where((item) {
        return item["client_fk"].contains(name);
      }));

      setState(() {
        timesheetTaskList = newList;
      });      
    }

    void clearFilters() {
      loadTimesheetTasks();
    }

    return Stack(
      children: [
      SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addTask = true;
                      });
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      foregroundColor: Theme.of(context).primaryColorDark,
                    ),
                    child: Text(
                      "New Task",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: () {
        
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      foregroundColor: Theme.of(context).primaryColorDark,
                    ),
                    child: Text(
                      "Generate Statement",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                      ),
                    ),
                  ),
                  SizedBox(width: 30,),
                ],
              ), 
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: screenHeight * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                top: 5,
                                bottom: 5,
                                right: 10
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).highlightColor,
                                  )
                                ),
                                color: Theme.of(context).primaryColorDark
                              ),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filters",
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      clearFilters();
                                    }, 
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColorLight,
                                      foregroundColor: Theme.of(context).primaryColorDark,
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.only(
                                        top: 2,
                                        bottom: 2,
                                        left: 10,
                                        right: 10
                                      )
                                    ),
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodySmall?.color,
                                        fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 5,
                                  bottom: 5
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context).highlightColor,
                                    )
                                  )
                                ),
                                child: Text(
                                  "General",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                left: 30,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Colors.black.withValues(alpha: 1),
                                  overlayColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  "Date",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  sortByDate();
                                },
                              )
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                left: 30,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Colors.black.withValues(alpha: 1),
                                  overlayColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  "Task",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  sortByTask();
                                },
                              )
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                left: 30,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Colors.black.withValues(alpha: 1),
                                  overlayColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  "Purchase Order Numbers",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  sortByPos();
                                },
                              )
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                left: 30,
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: Colors.black.withValues(alpha: 1),
                                  overlayColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: Text(
                                  "Invoiced",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                onPressed: () {
                                  sortByInvoiced();
                                },
                              )
                            ),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 30,
                                  bottom: 5
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                      color: Theme.of(context).highlightColor,
                                    )
                                  )
                                ),
                                child: Text(
                                  "Clients",
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  for(var client in clientList) 
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.only(
                                        left: 30,
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          alignment: Alignment.centerLeft,
                                          foregroundColor: Colors.black.withValues(alpha: 1),
                                          overlayColor: Colors.black,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        child: Text(
                                          client['client_bus_name'],
                                          style: TextStyle(
                                            color: Theme.of(context).textTheme.bodySmall?.color,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        onPressed: () {
                                          sortByClient(client["client_bus_name"]);
                                        },
                                      )
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        height: screenHeight * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).highlightColor,
                            width: 1
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).highlightColor,
                                  )
                                )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "Task",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "Purchase Order Number",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "Client",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "Date",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "Hours",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 10,
                                        top: 5,
                                        bottom: 5
                                      ),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.bodySmall?.color,
                                        ),
                                      )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var task in timesheetTaskList)
                                    TimeTaskListItem(
                                      id: task['id'], 
                                      task: task['task_fk'], 
                                      pos: task['pos_fk'], 
                                      client: task['client_fk'], 
                                      date: task['date'], 
                                      hours: task['hours'].toString(), 
                                      invoiced: task['invoiced'], 
                                      rowColor: Theme.of(context).primaryColor, 
                                      deleteFunc: activateDelete,
                                      editFunc: activateEdit,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Visibility(
        visible: addTask,
        child: Positioned(
          child: Container(
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
                              addTask = false;
                            });
                            clearControllers();
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: Text(
                            "New Task",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Task",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _taskListController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Task",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var task in taskList)
                                DropdownMenuEntry(
                                  label: task["task"],
                                  value: task,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: IconButton(
                            onPressed: () {
                              addTasks(_taskListController.text);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Client",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _clientController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Client",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var client in clientList)
                                DropdownMenuEntry(
                                  label: client["client_bus_name"],
                                  value: client["id"],
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Purchase Order Number",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _posController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Purchase Order Number",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var pos in posList)
                                DropdownMenuEntry(
                                  label: pos["pos"],
                                  value: pos,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: IconButton(
                            onPressed: () {
                              addPos(_posController.text);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextInput(labelName: "Date", hintText: "Date...", password: false, inputController: _dateController),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextInput(labelName: "Hours Spent", hintText: "Hours Spent...", password: false, inputController: _hoursController),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              addNewTimeTask(
                                _taskListController.text,
                                _posController.text,
                                _clientController.text,
                                _dateController.text.replaceAll("/", "-"),
                                int.parse(_hoursController.text)
                              );
                              clearControllers();
                              setState(() {
                                addTask = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorLight,
                              foregroundColor: Theme.of(context).primaryColorDark,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30
                              )
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
      Visibility(
          visible: deleteBool,
          child: Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ),
              padding: EdgeInsets.only(
                top: screenHeight * 0.35,
                bottom: screenHeight * 0.35,
                left: screenWidth * 0.33,
                right: screenWidth * 0.33,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: const Color.fromARGB(255, 216, 19, 5),
                    width: 2
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 5) 
                    )
                  ]
                ),
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 50
                      ),
                      child: Text(
                        "Are you sure you want to delete this Task?",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 35,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deleteTimeTask(selectedClientID);
                            deleteBool = false;
                            selectedClientID = 0;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 218, 29, 15),
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Delete",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              deleteBool = false;
                              selectedClientID = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColorLight,
                            foregroundColor: Theme.of(context).primaryColorDark,
                            elevation: 5,
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 30
                            )
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ),
        ),
        Visibility(
        visible: editTask,
        child: Positioned(
          child: Container(
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
                              addTask = false;
                            });
                            clearControllers();
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: Text(
                            "Edit Task",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                              fontSize: 26,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Task",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _taskListController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Task",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var task in taskList)
                                DropdownMenuEntry(
                                  label: task["task"],
                                  value: task,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: IconButton(
                            onPressed: () {
                              addTasks(_taskListController.text);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Client",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _clientController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Client",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var client in clientList)
                                DropdownMenuEntry(
                                  label: client["client_bus_name"],
                                  value: client["id"],
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 20
                          ),
                          child: DropdownMenu(
                            label: Text(
                              "Purchase Order Number",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            controller: _posController,
                            width: screenWidth * 0.25,
                            hintText: "Select a Purchase Order Number",
                            trailingIcon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            selectedTrailingIcon: Icon(
                              Icons.keyboard_arrow_up_sharp,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            menuStyle: MenuStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor
                              ),
                            ),
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).highlightColor,
                                  width: 1
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20)
                                )
                              )
                            ),
                            textStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                            dropdownMenuEntries: [
                              for (var pos in posList)
                                DropdownMenuEntry(
                                  label: pos["pos"],
                                  value: pos,
                                  style: MenuItemButton.styleFrom(
                                    foregroundColor: Theme.of(context).highlightColor,
                                  ),
                                )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: IconButton(
                            onPressed: () {
                              addPos(_posController.text);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextInput(labelName: "Date", hintText: "Date...", password: false, inputController: _dateController),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextInput(labelName: "Hours Spent", hintText: "Hours Spent...", password: false, inputController: _hoursController),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            right: 20
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              editTimeTask(
                                selectedClientID,
                                _taskListController.text,
                                _posController.text,
                                _clientController.text,
                                _dateController.text.replaceAll("/", "-"),
                                int.parse(_hoursController.text)
                              );
                              clearControllers();
                              setState(() {
                                editTask = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColorLight,
                              foregroundColor: Theme.of(context).primaryColorDark,
                              elevation: 5,
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30
                              )
                            ),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                fontWeight: Theme.of(context).textTheme.bodySmall?.fontWeight,
                                fontSize: 18
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
      ]
    );
  }
}