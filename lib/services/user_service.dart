import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/constant/app_string.dart';
import 'package:contact_app/model/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> insertRecord(ContactModel contactModel, bool isAdded) async {
    CollectionReference users = fireStore.collection('users');

    await users
        .doc(contactModel.userId)
        .collection('contact_list')
        .doc(contactModel.id)
        .set({
          'first_name': contactModel.firstName,
          'last_name': contactModel.lastName,
          'dob': contactModel.dob,
          'contact': contactModel.contact,
          'address': contactModel.address,
          'image_uri': contactModel.imageUri,
          'user_id': contactModel.userId,
          'id': contactModel.id
        })
        .then((value) => isAdded = true)
        .catchError((error) => isAdded = false);

    return isAdded;
  }

  Future<List<ContactModel>> displayData(String? userId) async {
    List<ContactModel> contactList = [];

    QuerySnapshot data = await fireStore
        .collection("users")
        .doc(userId)
        .collection('contact_list')
        .get();

    data.docs.forEach((element) {
      var contactData = element.data() as Map<String, dynamic>;

      contactList.add(ContactModel.fromJson(contactData));
    });

    return contactList;
  }

  Future<String> uploadFile(String filePath) async {
    File file = File(filePath);
    String _uri = '';
    try {
      String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
      var filePath = 'images/images_$dateTime';
      Reference reference = storage.ref(filePath);
      TaskSnapshot taskSnapshot = await reference.putFile(file);
      _uri = await taskSnapshot.ref.getDownloadURL();
      return _uri;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  Future<bool> updateUser(ContactModel contactModel, bool isAdded) async {
    CollectionReference users = fireStore
        .collection('users')
        .doc(contactModel.userId)
        .collection('contact_list');

    await users
        .doc(contactModel.id)
        .update({
          'first_name': contactModel.firstName,
          'last_name': contactModel.lastName,
          'dob': contactModel.dob,
          'contact': contactModel.contact,
          'address': contactModel.address,
          'image_uri': contactModel.imageUri
        })
        .then((value) => isAdded = true)
        .catchError((error) => isAdded = true);

    return isAdded;
  }

  Future<bool> deleteUser(String userId, String id, bool isAdded) async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contact_list');

    await users
        .doc(id)
        .delete()
        .then((value) => isAdded = true)
        .catchError((error) => isAdded = false);

    return isAdded;
  }

  Future<bool> saveData(
      bool isLogin, String email, String password, String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppString.isLoggedIn, isLogin);
    pref.setString(AppString.isEmail, email);
    pref.setString(AppString.isPassword, password);
    pref.setString(AppString.isUserId, uid);
    return isLogin;
  }

  Future<bool?> getData() async {
    bool? status = false;
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(AppString.isLoggedIn)) {
      status = pref.getBool(AppString.isLoggedIn);
    } else {
      status = false;
    }
    return status;
  }

  Future<SharedPreferences> getAllPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString(AppString.isEmail);
    pref.getString(AppString.isPassword);
    pref.getString(AppString.isUserId);
    return pref;
  }

  Future clearPrefData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}
