import 'dart:io';

import 'package:contact_app/constant/common_validation.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:contact_app/services/user_service.dart';
import 'package:contact_app/widget/common_circular_indicator.dart';
import 'package:contact_app/widget/common_text_form_field.dart';
import 'package:contact_app/constant/app_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  final bool? isData;
  final ContactModel? contact;

  ContactScreen({
    Key? key,
    this.isData = false,
    this.contact,
  }) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  GlobalKey<FormState> _formContactState = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _address = TextEditingController();
  DateTime _date = DateTime.now();
  bool isAdded = false;
  bool isVisible = false;
  bool isImageSelected = false;
  bool isImageError = false;
  int year = 0;
  int month = 0;
  int day = 0;

  final ImagePicker _picker = ImagePicker();
  XFile? imagePath;

  UserService _userService = UserService();
  ContactModel contactModel = ContactModel();
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  String uri = '';
  String networkUri = '';

  @override
  void initState() {
    if (widget.isData!) {
      _firstName.text = widget.contact!.firstName!;
      _lastName.text = widget.contact!.lastName!;
      _dob.text = widget.contact!.dob!;
      _contact.text = widget.contact!.contact!;
      _address.text = widget.contact!.address!;
      networkUri = widget.contact!.imageUri!;

      setState(() {});
    } else {
      print('ELSE -> ${widget.isData!}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        if (!isVisible) {
          Navigator.pop(context, false);
        }
        return !isVisible;
      },
      child: Scaffold(
        /*appBar: AppBar(
          title: Text(widget.isData! ? AppString.update : AppString.contact),
          actions: [
            widget.isData!
                ? IconButton(
                    onPressed: () {
                      deleteData(context);
                    },
                    icon: Icon(Icons.delete))
                : SizedBox.shrink(),
          ],
        ),*/
        body: Stack(
          alignment: Alignment.center,
          children: [
            contactForm(),
            isVisible ? CommonCircularIndicator() : Container(),
          ],
        ),
      ),
    ));
  }

  Widget contactForm() => Form(
        key: _formContactState,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                            )),
                      ),
                      widget.isData!
                          ? GestureDetector(
                              onTap: () {
                                deleteData(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.isData! ? AppString.update : AppString.contact,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      requestPermission(Permission.storage);
                    },
                    child: networkUri.isNotEmpty && imagePath == null
                        ? Container(
                            width: 120,
                            height: 120,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
                            child: Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xDBE2F3FF),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    onError: (exception, stackTrace) =>
                                        Icon(Icons.add_a_photo),
                                    image: NetworkImage(networkUri),
                                  )),
                            ),
                          )
                        : imagePath != null
                            ? Container(
                                width: 120,
                                height: 120,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xDBE2F3FF),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        onError: (exception, stackTrace) =>
                                            Icon(Icons.add_a_photo),
                                        image: FileImage(File(imagePath!.path)),
                                      )),
                                ),
                              )
                            : Container(
                                width: 120,
                                height: 120,
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xDBE2F3FF),
                                  ),
                                ),
                              ),
                  ),
                  Visibility(
                      visible: isImageError,
                      child: Text(
                        'Please select image',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  CommonTextFormField(
                    controller: _firstName,
                    labelText: AppString.firstName,
                    hintText: AppString.enterFirstName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: (value) =>
                        CommonValidation.firstNameValidation(value!),
                    obscureText: false,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonTextFormField(
                    controller: _lastName,
                    labelText: AppString.lastName,
                    hintText: AppString.enterLastName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    validator: (value) =>
                        CommonValidation.lastNameValidation(value!),
                    obscureText: false,
                    prefixIcon: Icon(Icons.person),
                    suffixIcon: SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonTextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                    controller: _dob,
                    labelText: AppString.dob,
                    hintText: _date != DateTime.now()
                        ? '${_date.day}-${_date.month}-${_date.year}'
                        : AppString.enterDob,
                    readOnly: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(20),
                    ],
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (_dob.text.isEmpty) {
                        return AppString.selectDob;
                      }
                      return null;
                    },
                    obscureText: false,
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonTextFormField(
                    controller: _contact,
                    labelText: AppString.contactNo,
                    hintText: AppString.enterContact,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (value) =>
                        CommonValidation.contactValidation(value!),
                    obscureText: false,
                    prefixIcon: Icon(Icons.phone),
                    suffixIcon: SizedBox.shrink(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CommonTextFormField(
                    controller: _address,
                    labelText: AppString.address,
                    hintText: AppString.enterAddress,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(80),
                    ],
                    validator: (value) =>
                        CommonValidation.addressValidation(value!),
                    obscureText: false,
                    prefixIcon: Icon(Icons.home),
                    suffixIcon: SizedBox.shrink(),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        DateTime today = DateTime.now();

                        int yearDiff = today.year - year;
                        int monthDiff = today.month - month;
                        int dayDiff = today.day - year;

                        if (yearDiff > 18 ||
                            yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0) {
                          if (widget.isData!) {
                            updateData();
                          } else {
                            insertData();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('You are 18 years below')));
                        }
                      },
                      icon: SizedBox.shrink(),
                      label: Text(
                        widget.isData!
                            ? AppString.update
                            : AppString.addContact,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> requestPermission(Permission permission) async {
    var result = await permission.request();
    print(result);
    if (result.isGranted) {
      _galleryPicker();
    } else if (result.isDenied) {
      await permission.request();
    } else if (result.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await permission.request();
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
    );

    year = _datePicker!.year;
    month = _datePicker.month;
    day = _datePicker.day;

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        var formatter = DateFormat('dd-MM-yyyy');
        _dob.text = formatter.format(_date);
        print('dob text :- ${_dob.text}');
      });
    } else {
      setState(() {
        _date = DateTime.now();
      });
    }
  }

  _galleryPicker() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (image != null) {
        imagePath = image;
        setState(() {
          isImageSelected = true;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppString.imageNotSelected)));
      }
    });
  }

  void insertData() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (imagePath == null && !isImageSelected) {
      isImageError = true;
    } else {
      isImageError = false;
    }

    if (_formContactState.currentState!.validate() && !isImageError) {
      setState(() {
        isVisible = true;
      });

      uri = await _userService.uploadFile(imagePath!.path);

      SharedPreferences pref = await _userService.getAllPrefData();

      if (uri.isNotEmpty) {
        contactModel.firstName = _firstName.text;
        contactModel.lastName = _lastName.text;
        contactModel.dob = _dob.text;
        contactModel.contact = _contact.text;
        contactModel.address = _address.text;
        contactModel.imageUri = uri;
        contactModel.userId = pref.getString(AppString.isUserId);
        contactModel.id = DateTime.now().millisecondsSinceEpoch.toString();

        bool result = await _userService.insertRecord(contactModel, isAdded);

        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppString.userAdded),
            behavior: SnackBarBehavior.floating,
          ));

          setState(() {
            isVisible = false;
          });

          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(uri),
            behavior: SnackBarBehavior.floating,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppString.pleaseSelectImage),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
    setState(() {});
  }

  void updateData() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!isImageSelected && networkUri.isEmpty) {
      isImageError = true;
    } else {
      isImageError = false;
    }

    if (_formContactState.currentState!.validate() && !isImageError) {
      setState(() {
        isVisible = true;
      });

      if (imagePath == null) {
        uri = networkUri;
      } else {
        await _firebaseStorage.refFromURL(widget.contact!.imageUri!).delete();
        uri = await _userService.uploadFile(imagePath!.path);
      }

      if (uri.isNotEmpty) {
        contactModel.firstName = _firstName.text;
        contactModel.lastName = _lastName.text;
        contactModel.dob = _dob.text;
        contactModel.contact = _contact.text;
        contactModel.address = _address.text;
        contactModel.imageUri = uri;
        contactModel.userId = widget.contact!.userId!;
        contactModel.id = widget.contact!.id!;

        bool result = await _userService.updateUser(contactModel, isAdded);

        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppString.userUpdated),
            behavior: SnackBarBehavior.floating,
          ));

          setState(() {
            isVisible = false;
          });

          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppString.userNotUpdated),
            behavior: SnackBarBehavior.floating,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppString.pleaseSelectImage),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
    setState(() {});
  }

  void deleteData(BuildContext context) {
    if (widget.isData!) {
      setState(() {
        isVisible = true;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(AppString.delete,
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(AppString.deleteConfirmation),
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            actions: [
              TextButton(
                  onPressed: () async {
                    await _firebaseStorage
                        .refFromURL(widget.contact!.imageUri!)
                        .delete();

                    bool result = await _userService.deleteUser(
                        widget.contact!.userId!, widget.contact!.id!, isAdded);

                    Navigator.pop(context);
                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User delete'),
                        behavior: SnackBarBehavior.floating,
                      ));

                      setState(() {
                        isVisible = false;
                      });

                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User not deleted'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    setState(() {
                      isVisible = false;
                    });
                  },
                  child: Text("No")),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong...!'),
        behavior: SnackBarBehavior.floating,
      ));

      setState(() {
        isVisible = true;
      });
    }
  }
}
