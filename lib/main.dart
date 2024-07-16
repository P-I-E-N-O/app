import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';
import 'package:pieno/add_car_form.dart';
import 'package:pieno/cars.dart';
import 'package:pieno/io/http.dart';
import 'package:pieno/login.dart';
import 'package:pieno/models.dart';
import 'package:pieno/services/bluetooth.dart';
import 'package:pieno/services/permissions.dart';
import 'package:pieno/state.dart';
import 'package:pieno/widgets/snackbars.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await initializeService();
  runApp(MultiProvider(providers: [
    Provider(
      create: (_) => Api(
          client: Dio(
        BaseOptions(
          baseUrl: "https://backend.pieno.dev/",
        ),
      )),
    ),
    ChangeNotifierProvider(
      create: (_) => UserState(),
    ),
  ], child: const MyApp()));
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      autoStartOnBoot: true,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  BluetoothService().startScanAndConnect();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    BluetoothService().startScanAndConnect();
    return MaterialApp(
      home: const SplashScreen(),
      theme: ThemeData(
        fontFamily: 'futura',
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const StartingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 17, 63),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Lottie.asset(
                "assets/red_car.json",
                fit: BoxFit.contain,
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                left: MediaQuery.of(context).size.width * 0.35,
                child: const Text(
                  "P.I.E.N.O.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StartingPage extends StatefulWidget {
  const StartingPage({super.key});

  @override
  State<StartingPage> createState() => _StartingPageState();
}

class _StartingPageState extends State<StartingPage> {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserState state;
  List<Car>? cars;

  void getPump(BuildContext context, int tankSize, int fuelLevel,
      FuelType fuelType, String size) async {
    double latitude;
    double longitude;
    Map<String, double> consPerKm = {
      "small": 0.05,
      "medium": 0.1,
      "big": 0.15,
      "large": 0.15,
    };
    Location location = Location();
    LocationData locationData = await location.getLocation();
    latitude = locationData.latitude!;
    longitude = locationData.longitude!;

    // ignore: use_build_context_synchronously
    Future<Pump> pumpFuture =
        Provider.of<Api>(context, listen: false).getBestPump(
      latitude,
      longitude,
      tankSize,
      fuelLevel,
      consPerKm[size.toLowerCase()]!,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 17, 63),
        title: const Center(
          child: Text(
            "Best pump for you!",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        content: FutureBuilder<Pump>(
          future: pumpFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              var pump = snapshot.data as Pump;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Address ${pump.indirizzo}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Prezzo al litro: ${pump.fuelPrices[fuelType]}",
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String googleMapsUrl =
                          "https://www.google.com/maps/search/?api=1&query=${pump.latitudine},${pump.longitudine}";
                      if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
                        await launchUrl(Uri.parse(googleMapsUrl));
                      } else {
                        throw 'Could not launch $googleMapsUrl';
                      }
                    },
                    child: const Text("Navigate to Google Maps"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void initCars() async {
    cars =
        await Provider.of<UserState>(context, listen: false).getCars(context);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initCars();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    state = context.watch<UserState>();
  }

  Future<List<PriceData>> getColumnData(FuelType fuelType) async {
    Map<String, double> fuelPrices =
        await Provider.of<Api>(context).getColumnDataHttp(fuelType);

    List<PriceData> columnData = [];
    double currPrice = 0.0;
    Color? forecastColor;

    DateTime? date;
    String? formattedDate;
    double? roundedPrice;
    var fuelPricesList = fuelPrices.entries;
    for (int i = 0; i < fuelPricesList.length; i++) {
      date = DateTime.parse(fuelPricesList.elementAt(i).key);
      formattedDate =
          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}";

      roundedPrice =
          double.parse(fuelPricesList.elementAt(i).value.toStringAsFixed(3));

      if (i == 0 || roundedPrice == currPrice) {
        forecastColor = const Color.fromARGB(255, 0, 132, 255);
      } else if (roundedPrice > currPrice) {
        forecastColor = Colors.red;
      } else if (roundedPrice < currPrice) {
        forecastColor = Colors.green;
      }

      columnData.add(PriceData(formattedDate, roundedPrice, forecastColor));

      currPrice = roundedPrice;
    }
    return columnData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 17, 63),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text(
          "Welcome back ${state.username!}!",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 3, 8, 31),
        shadowColor: Colors.grey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: const DrawerHeader(
                child: Text(
                  "Recap",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.006,
            ),
            Text(
              state.username!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.004,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2),
              child: MaterialButton(
                onPressed: () {},
                color: const Color(0xFF367980),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              cars != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.30,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3b75b2),
                            Colors.indigo,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 0.5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CarsPage(),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.list,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                Text(
                                  state.activeCar != null
                                      ? state.activeCar!.name
                                      : cars![0].name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 150.0,
                            child: OverflowBox(
                              maxHeight: 300,
                              child: SizedBox(
                                height: 300.0,
                                child: Lottie.asset(
                                  "assets/red_car.json",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: LiquidLinearProgressIndicator(
                                      value: state.activeCar == null
                                          ? ((cars![0].fuelLevel ?? 0) / 100)
                                          : ((state.activeCar!.fuelLevel ?? 0) /
                                              100),
                                      valueColor: const AlwaysStoppedAnimation(
                                        Color.fromARGB(255, 0, 132, 255),
                                      ),
                                      backgroundColor:
                                          const Color.fromARGB(255, 7, 45, 114),
                                      borderColor: Colors.transparent,
                                      borderWidth: 0,
                                      borderRadius: 12.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                state.activeCar != null
                                    ? "${state.activeCar!.fuelLevel}%"
                                    : "${cars![0].fuelLevel}%",
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ))
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.1),
                      child: MaterialButton(
                        color: const Color(0xFF367980),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddCarForm()));
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            Text(
                              "Add your first car!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              cars != null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3b75b2),
                            Colors.indigo,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: FutureBuilder(
                          future: getColumnData(
                            state.activeCar != null
                                ? state.activeCar!.fuelType
                                : cars![0].fuelType,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                            if (!snapshot.hasData) {
                              return const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              );
                            }
                            var data = snapshot.data as List<PriceData>;
                            return SfCartesianChart(
                              title: ChartTitle(
                                text:
                                    "${(state.activeCar?.fuelType ?? cars![0].fuelType).string} Price Trend",
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              primaryXAxis: const CategoryAxis(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              primaryYAxis: const NumericAxis(
                                isVisible: false,
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<PriceData, String>(
                                  dataSource: data,
                                  xValueMapper: (PriceData price, _) => price.x,
                                  yValueMapper: (PriceData price, _) => price.y,
                                  pointColorMapper: (PriceData price, _) =>
                                      price.color,
                                  dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                    )
                  : const SizedBox(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              GestureDetector(
                onTap: () {
                  cars != null
                      ? state.activeCar != null
                          ? getPump(
                              context,
                              state.activeCar!.tankSize,
                              state.activeCar!.fuelLevel ?? 0,
                              state.activeCar!.fuelType,
                              state.activeCar!.size)
                          : getPump(
                              context,
                              cars![0].tankSize,
                              cars![0].fuelLevel ?? 0,
                              cars![0].fuelType,
                              cars![0].size)
                      : ScaffoldMessenger.of(context)
                          .showSnackBar(noActiveCars);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.11,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF3b75b2),
                        Colors.indigo,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 0.5), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(17.0),
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Image.asset(
                      "assets/pump.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceData {
  String x;
  double y;
  Color? color;
  PriceData(this.x, this.y,
      [this.color = const Color.fromARGB(255, 0, 132, 255)]);
}
