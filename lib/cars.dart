import 'package:flutter/material.dart';
import 'package:pieno/add_car_form.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:provider/provider.dart';

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
    var state = context.watch<UserState>();
    cars = await state.getCars(context);
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
        backgroundColor: const Color.fromARGB(255, 6, 17, 63),
        title: const Text(
          "Active car confirmation",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to set your ${cars![index].name} as your active car?",
          style: const TextStyle(color: Colors.blueGrey),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<UserState>(context, listen: false).activeCar =
                    cars![index];
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.blueGrey),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.blueGrey),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 17, 63),
      body: cars == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3b75b2),
                        Colors.indigo,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 0.5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () => setAsActive(i),
                    title: Text(
                      cars![i].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      cars![i].fuelType.string,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: cars!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCarForm(),
            ),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(
          Icons.add,
          color: Colors.grey,
        ),
      ),
    );
  }
}
