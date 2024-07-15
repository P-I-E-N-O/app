import 'package:flutter/material.dart';
import 'package:pieno/add_car_form.dart';
import 'package:pieno/io/storage.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:provider/provider.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({super.key});

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  List<Car>? cars;

  void initCars() async {
    cars =
        await Provider.of<UserState>(context, listen: false).getCars(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCars();
    });
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
                writeIndexToFile(index.toString());
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
            ),
          ),
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
