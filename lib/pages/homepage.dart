import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/widgets/city_search_bar.dart';
import '../functions/functions.dart';
import '../widgets/forecast_cards.dart';
import '../widgets/info_cards.dart';
import '../widgets/spacing.dart';
import '../widgets/tabbar.dart';
import 'errorpage.dart';
import 'forecastdays.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> theWeather;
  final TextEditingController citySearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    theWeather = getWeather("Chennai");
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 15,
          backgroundColor: const Color.fromARGB(255, 76, 0, 51),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )),
          bottom: myTabs(),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: theWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (snapshot.hasError) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Errorpage(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              theWeather = getWeather("Chennai");
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 4,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 76, 0, 51),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              "Try Again",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        )
                      ]);
                }

                final data = snapshot.data!;
                final currentWetData = data["list"][0];
                final currentTemp = currentWetData["main"]["temp"];
                final currentSky = currentWetData["weather"][0]["main"];
                final currentDescription =
                    currentWetData["weather"][0]["description"];
                final pressure = currentWetData["main"]["pressure"];
                final windSpeed = currentWetData["wind"]["speed"];
                final humidity = currentWetData["main"]["humidity"];
                final wIcon = Uri.parse(
                    "https://openweathermap.org/img/w/${currentWetData["weather"][0]["icon"]}");

                String ftime(int index) {
                  final time = DateTime.parse(data["list"][index]["dt_txt"]);
                  return DateFormat.jm().format(time);
                }

                num fval(int index) {
                  return data["list"][index]["main"]["temp"];
                }

                String ficon(int index) {
                  final fIcon =
                      "https://openweathermap.org/img/w/${data["list"][index]["weather"][0]["icon"]}.png";
                  return fIcon;
                }

                String fdescribe(int index) {
                  return data["list"][index]["weather"][0]["description"];
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 35),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CitySearchBar(
                          citySearchController: citySearchController,
                          onSend: (text) {
                            setState(() {
                              theWeather = getWeather(
                                  citySearchController.text.isEmpty
                                      ? "Chennai"
                                      : citySearchController.text.trim());
                            });
                          },
                        ),
                        //main card
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          width: w,
                          child: Card(
                            elevation: 10,
                            child: Column(
                              children: [
                                const Verticalspace(value: 25),
                                Text(
                                  "${data["city"]["name"].toString().toUpperCase()} - ${data["city"]["country"]}",
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                                Text(
                                  "${convertTemp(currentTemp)}°C",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 76, 0, 51),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Verticalspace(value: 5),
                                Image.network(
                                  "$wIcon.png",
                                  width: 70,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                const Verticalspace(value: 5),
                                Text(
                                  textAlign: TextAlign.center,
                                  "$currentSky - $currentDescription",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 76, 0, 51),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Verticalspace(value: 25),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: const Color.fromARGB(255, 76, 0, 51),
                          elevation: 5,
                          child: Container(
                              alignment: Alignment.center,
                              width: w - 40,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                currentSky == 'Rain' || currentSky == 'Clouds'
                                    ? "RECOMMENDATION - FOR NOW, USE AN UMBRELLA"
                                    : "RECOMMENDATION  - FOR NOW, NO NEED FOR AN UMBRELLA",
                                style:
                                    const TextStyle(fontSize: 9, color: Colors.white),
                              )),
                        ),
                        const Verticalspace(value: 30),

                        //forecast cards
                        const Text(
                          "Forecasts",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 76, 0, 51)),
                        ),
                        const Verticalspace(value: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ForecastCards(
                              time: ftime(1),
                              temp: "${convertTemp(fval(1))}°C",
                              iconImage: Image.network(
                                ficon(1),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(1),
                            ),
                            //Horizontalspace(value: 5),
                            ForecastCards(
                              time: ftime(2),
                              temp: "${convertTemp(fval(2))}°C",
                              iconImage: Image.network(
                                ficon(2),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(2),
                            ),
                            // Horizontalspace(value: 5),
                            ForecastCards(
                              time: ftime(3),
                              temp: "${convertTemp(fval(3))}°C",
                              iconImage: Image.network(
                                ficon(3),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(3),
                            ),
                            // Horizontalspace(value: 5),
                          ],
                        ),
                        const Verticalspace(value: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ForecastCards(
                              time: ftime(4),
                              temp: "${convertTemp(fval(4))}°C",
                              iconImage: Image.network(
                                ficon(4),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(4),
                            ),
                            // Horizontalspace(value: 5),
                            ForecastCards(
                              time: ftime(5),
                              temp: "${convertTemp(fval(5))}°C",
                              iconImage: Image.network(
                                ficon(5),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(5),
                            ),
                            // Horizontalspace(value: 5),
                            ForecastCards(
                              time: ftime(6),
                              temp: "${convertTemp(fval(6))}°C",
                              iconImage: Image.network(
                                ficon(6),
                                width: 40,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                              describe: fdescribe(6),
                            ),
                          ],
                        ),
                        const Verticalspace(value: 30),
                        const Text(
                          "Additional Information",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 76, 0, 51)),
                        ),
                        const Verticalspace(value: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 1,
                              child: InfoCards(
                                icon: const Icon(
                                  Icons.water_drop,
                                  color: Color.fromARGB(255, 76, 0, 51),
                                ),
                                text: const Text(
                                  "Humidity",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                                value: Text(
                                  humidity.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InfoCards(
                                icon: const Icon(Icons.wind_power_outlined,
                                    color: Color.fromARGB(255, 76, 0, 51)),
                                text: const Text(
                                  "Wind Speed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                                value: Text(
                                  windSpeed.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InfoCards(
                                icon: const Icon(Icons.beach_access,
                                    color: Color.fromARGB(255, 76, 0, 51)),
                                text: const Text(
                                  "Pressure",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                                value: Text(
                                  pressure.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 76, 0, 51)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            //17 DAYS FORECAST
            FutureBuilder(
              future: theWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Errorpage(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            theWeather = getWeather("Chennai");
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 4,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 76, 0, 51),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Try Again",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final data = snapshot.data!;
                String fdday(int index) {
                  final day = DateTime.parse(data["list"][index]["dt_txt"]);
                  return DateFormat('EEE d').format(day);
                }

                String fdtime(int index) {
                  final time = DateTime.parse(data["list"][index]["dt_txt"]);
                  return DateFormat.jm().format(time);
                }

                num fval(int index) {
                  return data["list"][index]["main"]["temp"];
                }

                String ficon(int index) {
                  final fIcon =
                      "https://openweathermap.org/img/w/${data["list"][index]["weather"][0]["icon"]}.png";
                  return fIcon;
                }

                String fdescribe(int index) {
                  return data["list"][index]["weather"][0]["description"];
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "${data["city"]["name"].toString().toUpperCase()} - ${data["city"]["country"]}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 76, 0, 51),
                              fontWeight: FontWeight.bold),
                        ),
                        const Verticalspace(value: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ForecastdaysCards(
                                day: fdday(7),
                                temp: "${convertTemp(fval(7))}°C",
                                time: fdtime(7),
                                iconImage: Image.network(
                                  ficon(7),
                                  width: 80,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                describe: fdescribe(7),
                              ),
                              const Verticalspace(value: 20),
                              ForecastdaysCards(
                                day: fdday(15),
                                temp: "${convertTemp(fval(15))}°C",
                                time: fdtime(15),
                                iconImage: Image.network(
                                  ficon(15),
                                  width: 80,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                describe: fdescribe(15),
                              ),
                              const Verticalspace(value: 20),
                              ForecastdaysCards(
                                day: fdday(23),
                                temp: "${convertTemp(fval(23))}°C",
                                time: fdtime(23),
                                iconImage: Image.network(
                                  ficon(23),
                                  width: 80,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                describe: fdescribe(23),
                              ),
                              const Verticalspace(value: 20),
                              ForecastdaysCards(
                                day: fdday(31),
                                temp: "${convertTemp(fval(31))}°C",
                                time: fdtime(31),
                                iconImage: Image.network(
                                  ficon(31),
                                  width: 80,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                describe: fdescribe(31),
                              ),
                              const Verticalspace(value: 20),
                              ForecastdaysCards(
                                day: fdday(39),
                                temp: "${convertTemp(fval(39))}°C",
                                time: fdtime(39),
                                iconImage: Image.network(
                                  ficon(39),
                                  width: 80,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                describe: fdescribe(36),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
