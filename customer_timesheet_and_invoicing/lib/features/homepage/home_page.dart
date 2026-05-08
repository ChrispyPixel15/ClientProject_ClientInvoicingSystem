import 'package:customer_timesheet_and_invoicing/core/theme_controller.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/client_profile_page.dart';
import 'package:customer_timesheet_and_invoicing/features/clients/clients_list_page.dart';
import 'package:customer_timesheet_and_invoicing/features/settings/edit_settings_page.dart';
import 'package:customer_timesheet_and_invoicing/features/settings/settings_page.dart';
import 'package:customer_timesheet_and_invoicing/features/timesheet/timesheet_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final ThemeController themeController;
  const HomePage({super.key, required this.themeController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  String pageTitle = "Timesheet";

  String clickedClientID = '';

  void changePage(int pageNum, String pageName, String clientid, bool drawerClosed) {
    setState(() {
      pageIndex = pageNum;
      pageTitle = pageName;
      clickedClientID = clientid;
    });   
    if (!drawerClosed) {
      Navigator.pop(context); 
    }     
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = Timesheet();        
        break;
      case 1:
        page = Clients(onClientPressed: changePage);
        break;
      case 2: 
        page = Settings(onEditPressed: changePage, themeController: widget.themeController);        
        break;
      case 3: 
        page = ClientProfile(clientID: clickedClientID);
        break;
      case 4:
        page = EditSettings(onEditPressed: changePage);
      default:
        throw UnimplementedError('No page for selected index.');
    }
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(pageTitle),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 30,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        shape: Border(
          top: BorderSide.none,
          left: BorderSide.none,
          right: BorderSide.none,
          bottom: BorderSide.none
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () => changePage(0, "Timesheet", "", false),
              textColor: Theme.of(context).textTheme.bodySmall?.color,
              hoverColor: Theme.of(context).primaryColorDark,
            ),
            ListTile(
              title: const Text('Clients'),
              onTap: () => changePage(1, "Clients", "", false),
              textColor: Theme.of(context).textTheme.bodySmall?.color,
              hoverColor: Theme.of(context).primaryColorDark,
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => changePage(2, "Settings", "", false),
              textColor: Theme.of(context).textTheme.bodySmall?.color,
              hoverColor: Theme.of(context).primaryColorDark,
            ),              
          ]
        ),
      ),
      body: page,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}