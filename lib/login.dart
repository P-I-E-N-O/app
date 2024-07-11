import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pieno/main.dart';
import 'package:pieno/register.dart';
import 'package:pieno/io/http.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = false;
  bool redBorder = false;
  Map<String, TextEditingController> credentials = {
    "email": TextEditingController(),
    "password": TextEditingController(),
  };

  void toggleShowPassword() => setState(() {
        showPassword = !showPassword;
      });
  void toggleRedBorder() => setState(() {
        redBorder = true;
      });

  Future<void> checkLogin() async {
    String email = credentials["email"]!.text;
    String password = credentials["password"]!.text;

    try {
      final token =
          await Provider.of<Api>(context, listen: false).logIn(email, password);

      await const FlutterSecureStorage().write(
        key: "token",
        value: token,
      );
      Provider.of<Api>(context, listen: false).setToken(token);
      Provider.of<Api>(context, listen: false).getLoggedInUser();
    } catch (e) {
      toggleRedBorder();
      SnackBar snackBar = const SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          "Invalid email or password",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 17, 63),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          const Center(
            child: Text(
              "Welcome to P.I.E.N.O.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(
                  color: redBorder ? Colors.red : Colors.transparent),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                  controller: credentials["email"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(
                  color: redBorder ? Colors.red : Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 6,
              ),
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      bottom: 6,
                    ),
                    child: IconButton(
                      onPressed: toggleShowPassword,
                      icon: !showPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    fontFamily: 'futura',
                  ),
                ),
                style: TextStyle(
                  fontFamily: showPassword ? "Futura" : 'roboto',
                ),
                obscureText: !showPassword,
                enableSuggestions: false,
                autocorrect: false,
                controller: credentials["password"],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: MaterialButton(
              onPressed: () {
                checkLogin();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              height: MediaQuery.of(context).size.height * 0.06,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              color: const Color(0xFF367980),
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              height: MediaQuery.of(context).size.height * 0.06,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              color: const Color(0XFF34329F),
              child: const Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
