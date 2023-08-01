import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_qr/providers/user_provider.dart';
import 'package:store_qr/screens/home/home_screen.dart';

import 'auth/screens/login.dart';
import 'auth/services/auth_service.dart';

import 'constants.dart';
import 'constants/global_variables.dart';
import 'constants/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const String routeName = '/main-screen';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            shape: StadiumBorder(),
            backgroundColor: primaryColor,
          ),
        ),
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while checking authentication status
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data!) {
              return FutureBuilder<String?>(
                future: getType(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while fetching the user type
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    if (snapshot.hasData) {
                      String? userType = snapshot.data;
                      if (userType == 'seller') {
                        return HomeScreen();
                      } else if (userType == 'customer') {
                        return HomeScreen();
                      }
                    }
                    // User is not logged in or userType is not 'seller' or 'customer',
                    // navigate to the login screen
                    return Login();
                  }
                },
              );
            } else {
              // User is not logged in, navigate to the login screen
              return Login();
            }
          }
        },
      ),
    );
  }

  Future<bool> checkLoggedIn() async {
    final AuthService authService = AuthService();
    bool isLoggedIn = await authService.isLogged();
    return isLoggedIn;
  }

  Future<String?> getType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? action = prefs.getString('user-type');
    return action;
  }
}
