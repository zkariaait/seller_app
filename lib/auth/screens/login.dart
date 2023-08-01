import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_qr/auth/primary_buttons/primary_button.dart';
import 'package:store_qr/auth/screens/signup.dart';
import 'package:store_qr/auth/services/auth_service.dart';
import 'package:store_qr/auth/top_titles/top_titles.dart';

import '../../../main.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const String routeName = '/auth-screen';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  final AuthService authService = AuthService();
  TextEditingController password = TextEditingController();
  void signInUser() {
    authService.signInUser(
      context: context,
      mobileNo: email.value.text,
      password: password.value.text,
    );
  }

  @override
  void initState() {
    _checkUserLoggedIn();

    super.initState();
  }

  Future<void> _checkUserLoggedIn() async {
    final authService = AuthService();
    String action = await getToken();
    bool isLoggedIn = await authService.checkTokenLoggedIn(action.toString());

    bool actions = await authService.isLogged();
    print(actions.toString());
    if (isLoggedIn) {
      print(":0 ");
      Navigator.pushNamed(context, '/actual-home');
    }
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? action = prefs.getString('x-auth-token');
    if (action == null) {
      action = '';
    }
    return action;
  }

  bool isShowPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopTitles(subtitle: "", title: "Login"),
              const SizedBox(
                height: 46.0,
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  hintText: "E-mail",
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(
                    Icons.password_sharp,
                  ),
                  suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      padding: EdgeInsets.zero,
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      )),
                ),
              ),
              const SizedBox(
                height: 36.0,
              ),
              PrimaryButton(
                title: "Login",
                onPressed: () async {
                  signInUser();
                  authService.getUserData(context);

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final String? action = prefs.getString('x-auth-token');

                  print('CCCCC$action');
                  bool isLoggedIn =
                      await authService.checkTokenLoggedIn(action.toString());
                  print('BB$isLoggedIn');
                  Widget w;
                  if (isLoggedIn == true) {
                    authService.toHomeScreen(context);

                    print('TRUE');
                  } else {
                    //Navigator.pushNamed(context, '/auth-screen');
                  }
                  Navigator.pushNamed(context, '/auth-screen');

                  //authService.toHomeScreen(context);
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Center(child: Text("Don't have an account?")),
              const SizedBox(
                height: 12.0,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    // Routes.instance
                    // .push(widget: const SignUp(), context: context);
                    //Navigator.pushNamed(context, '/signup-screen');
                    Navigator.pushNamed(
                      context,
                      SignUp.routeName,
                    );
                  },
                  child: Text(
                    "Create an account",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
