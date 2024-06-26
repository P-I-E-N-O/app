import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pieno/models.dart';
import 'package:pieno/state.dart';
import 'package:provider/provider.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';




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
      backgroundColor: Color.fromARGB(255, 3, 8, 31),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      body: Center(
        
        child: Padding(
          padding: const EdgeInsets.all(20.0),

      child: Column(
        children: [
           SizedBox(height:  MediaQuery.of(context).size.height*0.15),   
            
            Container(
              height: MediaQuery.of(context).size.height*0.30,
               decoration: BoxDecoration(
           gradient: LinearGradient(
                                  colors: [
                                   // Color(0xFFd4f1f4),
                                   // Color(0xFF75e6da),
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
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                ),
            padding: const EdgeInsets.all(15.0),
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                                  Text(
                                        state.activeCar!.name,
                                        style: Theme.of(context).textTheme.headlineLarge,
                                      ),
                                  SizedBox(
                                      width: 300.0, height: 150.0,
                                      child: OverflowBox(
                                         maxHeight: 300,
                                        child: SizedBox(
                              height: 300.0, child: Lottie.asset("assets/red_car.json", fit: BoxFit.contain))),
                                      ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                                Expanded(
                                                  child: SizedBox(
                                                        height: 20.0,
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                          child: LiquidLinearProgressIndicator(
                                                                            value: state.activeCar!.fuelLevel / 100, // Defaults to 0.5.
                                                                            valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 2, 120, 231)), // Defaults to the current Theme's accentColor.
                                                                            backgroundColor: Color.fromARGB(255, 7, 45, 114), // Defaults to the current Theme's backgroundColor.
                                                                            borderColor: Colors.transparent,
                                                                            borderWidth: 0,
                                                                            borderRadius: 12.0,
                                                                            direction: Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                                                          ),
                                                                          
                                                        ),
                                                        ),
                                                ),
                                                Text("${state.activeCar!.fuelLevel}%")
                                              ],
                                  ),
                      ],),
            ),
            
            
            SizedBox(height:  MediaQuery.of(context).size.height*0.07),   
            
            
            Container(
              height: MediaQuery.of(context).size.height*0.20,
               decoration: BoxDecoration(
                  //color:const Color(0xFF8cd4ff),
                   gradient: LinearGradient(
                                  colors: [
                                   // Color(0xFFd4f1f4),
                                   // Color(0xFF75e6da),
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
                                    offset: Offset(0, 1), 
                                  ),
                                ],
                ),
           // padding: const EdgeInsets.all(15.0),
            child: SfCartesianChart(
                            title: ChartTitle(text: "Andamento"),
                            primaryXAxis: CategoryAxis(),
                            primaryYAxis: NumericAxis(),
                            series: <CartesianSeries>[
                                    ColumnSeries<PriceData,String>(
                                      dataSource: getColumnData(),
                                      xValueMapper: (PriceData price, _)=>price.x,
                                      yValueMapper: (PriceData price, _)=>price.y,
                                    )
                            ],
            ), 
            ),
            
            
            
            
            SizedBox(height:  MediaQuery.of(context).size.height*0.07),  
            
            
            
            
            GestureDetector(
              onTap: (){print("aaaaaaaaaaaa");},
              child: Container(
                height: MediaQuery.of(context).size.height*0.11,
                 decoration: BoxDecoration(
           gradient: LinearGradient(
                                  colors: [
                                   // Color(0xFFd4f1f4),
                                   // Color(0xFF75e6da),
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
                                    offset: Offset(0, 1),  // changes position of shadow
                                  ),
                                ],
                       
                  ),
              padding: const EdgeInsets.all(17.0),
                  child:  SizedBox(
                          height: 50,
                          width: 200,
                          child: Image.asset("assets/pump.png"),
                          ),
               ),
              ),
            SizedBox(height:  MediaQuery.of(context).size.height*0.04), 
        ],
      )
      )
      )
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


class PriceData
{
  String x;
  double y;
  PriceData(this.x, this.y);
}



dynamic getColumnData()
{
  List<PriceData> columnData=<PriceData>[
    PriceData("14-06", 1.789),
    PriceData("15-06", 1.799),
    PriceData("16-06", 1.798),
    PriceData("17-06", 1.800),
    PriceData("18-06", 1.789),
    PriceData("19-06", 1.801),
    PriceData("20-06", 1.821),
  ];

  return columnData;
}