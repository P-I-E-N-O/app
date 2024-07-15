import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pieno/main.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:pieno/widgets/snackbars.dart';
import 'package:provider/provider.dart';
import 'package:pieno/io/http.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isSamePassword = true;

  Map<String, TextEditingController> data = {
    "name": TextEditingController(),
    "surname": TextEditingController(),
    "username": TextEditingController(),
    "email": TextEditingController(),
    "password": TextEditingController(),
    "confirmPassword": TextEditingController(),
  };

  Future<void> register() async {
    if (data["name"]!.text.isEmpty ||
        data["surname"]!.text.isEmpty ||
        data["email"]!.text.isEmpty ||
        data["password"]!.text.isEmpty ||
        data["confirmPassword"]!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(allFieldsRequired);
      return;
    }

    String name = data["name"]!.text;
    String surname = data["surname"]!.text;
    String email = data["email"]!.text;
    String password = data["password"]!.text;
    String confirmPassword = data["confirmPassword"]!.text;

    if (password != confirmPassword) {
      setState(() {
        isSamePassword = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(passwordsDoNotMatch);
      return;
    } else {
      setState(() {
        isSamePassword = true;
      });
      try {
        final response =
            await Provider.of<Api>(context, listen: false).addUser(User(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ));
        if (response.statusCode == 200) {
          Provider.of<Api>(context, listen: false)
              .setToken(response.data["token"]);
          Provider.of<UserState>(context, listen: false).token =
              response.data["token"];

          await const FlutterSecureStorage().write(
            key: "token",
            value: response.data["token"],
          );
          User? user =
              await Provider.of<Api>(context, listen: false).getLoggedInUser();

          Provider.of<UserState>(context, listen: false).username = user!.name;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else if (response.statusCode == 409) {
          ScaffoldMessenger.of(context).showSnackBar(userAlreadyExist);
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(invalidEmailOrPassword);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 17, 63),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: SizedBox()),
          const Center(
            child: Text(
              "Insert your data",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name*",
                  ),
                  controller: data["name"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Surname*",
                  ),
                  controller: data["surname"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email*",
                  ),
                  controller: data["email"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(
                color: isSamePassword ? Colors.transparent : Colors.red,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password*",
                  ),
                  controller: data["password"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
              border: Border.all(
                color: isSamePassword ? Colors.transparent : Colors.red,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirm password*",
                  ),
                  controller: data["confirmPassword"],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: MaterialButton(
              onPressed: () {
                register();
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
          const Expanded(child: SizedBox())
        ],
      ),
    );
  }
}
