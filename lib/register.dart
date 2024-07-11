import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pieno/main.dart';
import 'package:pieno/models.dart';
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
    String name = data["name"]!.text;
    String surname = data["surname"]!.text;
    String email = data["email"]!.text;
    String password = data["password"]!.text;
    String confirmPassword = data["confirmPassword"]!.text;

    if (password != confirmPassword) {
      isSamePassword = false;
      return;
    } else {
      try {
        final response =
            await Provider.of<Api>(context, listen: false).addUser(User(
          name: name,
          surname: surname,
          email: email,
          password: password,
        ));
        if (response.data["success"] as bool) {
          Provider.of<Api>(context, listen: false).setToken(
            response.data["token"],
          );
          await const FlutterSecureStorage().write(
            key: "token",
            value: response.data["token"],
          );
          Provider.of<Api>(context, listen: false).getLoggedInUser();
        }
      } catch (e) {
        SnackBar snackBar = const SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Passwords do not match",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 100,
              color: Colors.white,
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name*",
                  ),
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Surname*",
                  ),
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email*",
                  ),
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
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password*",
                  ),
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
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirm password*",
                  ),
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
