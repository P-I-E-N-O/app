import 'package:flutter/material.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:provider/provider.dart';
import 'package:pieno/io/http.dart' as http;

void main() {
  runApp(MultiProvider(
      providers: [
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
      ],
      child: const MaterialApp(
        home: CarsPage(),
      )));
}

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  List<Car>? cars;

  void initCars() async {
    cars = await http.getUserCars();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initCars();
  }

  void setAsActive(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Active car confirmation"),
        content: Text(
            "Are you sure you want to set your ${cars![index].name} as your active car?"),
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<UserState>(context, listen: false).activeCar =
                    cars![index];
                Navigator.pop(context);
              },
              child: const Text("OK")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cars == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  child: ListTile(
                    onTap: () => setAsActive(i),
                    title: Text(cars![i].name),
                    subtitle: Text(cars![i].fuelType.string),
                    trailing: const Icon(Icons.delete),
                  ),
                ),
              ),
              itemCount: cars!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
