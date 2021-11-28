import 'package:contact_app/constant/app_string.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/pages/contact_screen.dart';
import 'package:contact_app/pages/login_screen.dart';
import 'package:contact_app/services/user_service.dart';
import 'package:contact_app/widget/common_circular_indicator.dart';
import 'package:contact_app/widget/listtile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ContactModel> contactList = [];
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserService _userService = UserService();
  bool isVisible = false;

  @override
  void initState() {
    getContactData();
    super.initState();
  }

  getContactData() async {
    print('getContactData');
    SharedPreferences pref = await _userService.getAllPrefData();
    String? userId = pref.getString(AppString.isUserId);
    contactList = await UserService().displayData(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print('Runtime type -> $runtimeType');
    return WillPopScope(
      onWillPop: () async {
        /*await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                AppString.exit,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(AppString.exitConfirmation),
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Yes",
                    )),
                TextButton(
                    onPressed: () {
                    },
                    child: Text("No")),
              ],
            );
          },
        );*/
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backwardsCompatibility: false,
            leading: Container(
              padding: EdgeInsets.zero,
            ),
            leadingWidth: 0,
            title: Text(AppString.appName),
            actions: [
              IconButton(
                  onPressed: () {
                    initLogout();
                  },
                  icon: Icon(Icons.logout)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              bool result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (builder) => ContactScreen()));

              if (result) {
                getContactData();
                print("Calling");
              }
            },
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
          body: Stack(
            children: [
              userData(),
              isVisible ? CommonCircularIndicator() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userData() => Center(
          child: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ContactScreen(
                          isData: true, contact: contactList[index])));

              if (result) {
                getContactData();
              }

              print(contactList[index]);
            },
            child: ListTileWidget(
              contactList[index].firstName!,
              contactList[index].lastName!,
              contactList[index].dob!,
              contactList[index].contact!,
              contactList[index].address!,
              contactList[index].imageUri!,
            ),
          );
        },
      ));

  void initLogout() async {
    try {
      setState(() {
        isVisible = true;
      });
      await _userService.clearPrefData();
      await _firebaseAuth.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => LoginScreen()),
          (route) => false);
      setState(() {
        isVisible = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
