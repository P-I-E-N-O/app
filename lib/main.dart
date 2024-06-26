import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => UserState(
        "ciao",
        "Boss",
        Car(
          name: "R4",
          plateNo: "AA000AA",
          tankSize: 100,
          size: "piccola",
          ownerId: "Boss",
          id: "R4",
          fuelLevel: 78,
          fuelType: FuelType.balls,
        ),
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var state = context.watch<UserState>();

    if (state.token != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var state = context.watch<UserState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Salve ${state.username}"),
        centerTitle: true,
      ),
      endDrawer: const Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("Bono er Burger"),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            state.activeCar!.name,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(
            width: 300.0,
            child: Lottie.asset("assets/red_car.json"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300.0,
                height: 20.0,
                child: LinearProgressIndicator(
                  value: state.activeCar!.fuelLevel / 100,
                ),
              ),
              Text("${state.activeCar!.fuelLevel}")
            ],
          ),
          const SizedBox(
            height: 60.0,
          ),
          Container(
            color: Colors.red,
            width: 300,
            height: 100,
          ),
          const SizedBox(
            height: 60.0,
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset("assets/pump.png"),
            ),
          )
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
