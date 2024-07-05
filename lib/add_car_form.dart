import 'package:flutter/material.dart';
import 'package:pieno/models.dart';

class AddCarForm extends StatefulWidget {
  const AddCarForm({super.key});

  @override
  State<AddCarForm> createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  String? dropDownCarSizeValue;
  FuelType? dropDownFuelTypeValue;
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name",
                  ),
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Plate Number",
                  ),
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
            child: const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Tank Size",
                  ),
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
                      value: "Small",
                      child: Text("Small"),
                    ),
                    DropdownMenuItem(
                      value: "Medium",
                      child: Text("Medium"),
                    ),
                    DropdownMenuItem(
                      value: "Large",
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
                      child: Text("Petrol"),
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
                    DropdownMenuItem(
                      value: FuelType.balls,
                      child: Text("Little Balls"),
                    )
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
              onPressed: () {},
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
