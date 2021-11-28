import 'package:contact_app/constant/common_validation.dart';
import 'package:contact_app/pages/home_screen.dart';
import 'package:contact_app/services/auth_service.dart';
import 'package:contact_app/services/user_service.dart';
import 'package:contact_app/widget/common_circular_indicator.dart';
import 'package:contact_app/widget/common_text_form_field.dart';
import 'package:contact_app/constant/app_string.dart';
import 'package:contact_app/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isVisible = false;
  bool _obscureText = true;

  AuthService _authService = AuthService();
  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          signIn(),
          isVisible ? CommonCircularIndicator() : Container(),
        ],
      ),
    ));
  }

  Widget signIn() => Form(
        key: _formState,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppString.register,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 20,
                ),
                CommonTextFormField(
                  controller: _email,
                  labelText: AppString.email,
                  hintText: AppString.enterEmail,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => CommonValidation.emailValidate(value!),
                  obscureText: false,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(50),
                  ],
                  prefixIcon: Icon(Icons.mail),
                  suffixIcon: SizedBox.shrink(),
                ),
                SizedBox(
                  height: 10,
                ),
                CommonTextFormField(
                  controller: _password,
                  labelText: AppString.password,
                  hintText: AppString.enterPassword,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      CommonValidation.passwordValidate(value!),
                  obscureText: _obscureText,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _obscureText = !_obscureText;
                        setState(() {});
                      },
                      icon: _obscureText
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off)),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        register();
                      }
                    },
                    icon: SizedBox.shrink(),
                    label: Text(
                      "Register",
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You have already account? ",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (builder) => LoginScreen()));
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  register() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());

      setState(() {
        isVisible = true;
      });

      User? user = await _authService.registerUser(_email.text, _password.text);

      if (user != null) {
        await _userService.saveData(
            true, _email.text, _password.text, user.uid);

        setState(() {
          isVisible = false;
        });

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => HomeScreen()),
            (route) => false);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Register successfully..!')));
        _email.clear();
        _password.clear();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Something went wrong..!')));
        setState(() {
          isVisible = false;
        });
      }
    } catch (e) {
      setState(() {
        isVisible = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
