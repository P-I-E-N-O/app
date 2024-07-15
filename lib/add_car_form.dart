import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pieno/io/http.dart';
import 'package:pieno/io/storage.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:pieno/widgets/snackbars.dart';
import 'package:provider/provider.dart';

class AddCarForm extends StatefulWidget {
  const AddCarForm({super.key});

  @override
  State<AddCarForm> createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  String? dropDownCarSizeValue;
  FuelType? dropDownFuelTypeValue;
  late var state = context.read<UserState>();

  Map<String, TextEditingController> data = {
    "name": TextEditingController(),
    "plateNo": TextEditingController(),
    "tankSize": TextEditingController(),
  };

  Future<void> addCar() async {
    if (data["name"]!.text.isEmpty ||
        data["plateNo"]!.text.isEmpty ||
        data["tankSize"]!.text.isEmpty ||
        dropDownFuelTypeValue == null ||
        dropDownCarSizeValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(allFieldsRequired);
      return;
    }

    String name = data["name"]!.text;
    String plateNo = data["plateNo"]!.text;
    int tankSize = int.parse(data["tankSize"]!.text);
    String size = dropDownCarSizeValue!;
    FuelType fuelType = dropDownFuelTypeValue!;
    Car car = Car(
      name: name,
      plateNo: plateNo,
      tankSize: tankSize,
      size: size,
      fuelType: fuelType,
      fuelLevel: 0,
      ownerId: state.username!,
      id: '',
    );

    try {
      final response =
          await Provider.of<Api>(context, listen: false).addCar(car);
      car.id = response.carId;
      car.token = response.carToken;
      state.getCars(context);
      if (state.activeCar == null) {
        state.activeCar = car;
        writeIndexToFile("0");
      }
      Navigator.pop(context);
    } on DioException catch (e) {
      e.response?.statusCode == 409
          ? ScaffoldMessenger.of(context).showSnackBar(carAlreadyExists)
          : ScaffoldMessenger.of(context).showSnackBar(networkError);
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
          const Expanded(
            child: SizedBox(),
          ),
          const Center(
            child: Text(
              "Add your car",
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
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
                  controller: data['name'],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Plate Number",
                  ),
                  controller: data['plateNo'],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tank Size",
                  ),
                  controller: data['tankSize'],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text("Car Size"),
                  value: dropDownCarSizeValue,
                  items: const [
                    DropdownMenuItem(
                      value: "small",
                      child: Text("Small"),
                    ),
                    DropdownMenuItem(
                      value: "medium",
                      child: Text("Medium"),
                    ),
                    DropdownMenuItem(
                      value: "large",
                      child: Text("Large"),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(
                      () {
                        dropDownCarSizeValue = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FuelType>(
                  hint: const Text("Fuel Type"),
                  value: dropDownFuelTypeValue,
                  items: const [
                    DropdownMenuItem(
                      value: FuelType.petrol,
                      child: Text("Gasoline"),
                    ),
                    DropdownMenuItem(
                      value: FuelType.diesel,
                      child: Text("Diesel"),
                    ),
                    DropdownMenuItem(
                      value: FuelType.electric,
                      child: Text("Electric"),
                    ),
                    DropdownMenuItem(
                      value: FuelType.lpg,
                      child: Text("LPG"),
                    ),
                    DropdownMenuItem(
                      value: FuelType.cng,
                      child: Text("CNG"),
                    ),
                  ],
                  onChanged: (FuelType? value) {
                    setState(
                      () {
                        dropDownFuelTypeValue = value;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: MaterialButton(
              onPressed: () {
                addCar();
              },
              minWidth: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              color: const Color(0xFF367980),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
