import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additonal_info_item.dart';
import 'package:weather_app/hourly_forecast_item%20copy.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  String cityName = "London";
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$APPID"));

      final data = jsonDecode(res.body);
      if (data["cod"] != '200') {
        throw "Whoops!! Looks like Internet needs a coffee break";
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }
  
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WeatherApp",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              
            });
          }, icon: const Icon(Icons.refresh))
        ],
      ),

      // Body of code

      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Text("oops!! Maybe Internet needs some coffee break");
          }

          //variables values

          final dataZ = snapshot.data!;
          final currentTemp = dataZ['list'][0]['main']['temp'] - 273.16;
          final roundedTemp = double.parse((currentTemp).toStringAsFixed(2));
          final currentSky = dataZ['list'][0]['weather'][0]['main'];
          final currentIconCode = dataZ['list'][0]['weather'][0]['icon'];
          final iconUrl =
              "https://openweathermap.org/img/wn/$currentIconCode@2x.png";
          final pressure =
              dataZ['list'][0]['main']['pressure'].toString(); // in hPa
          final windSpeed = dataZ['list'][0]['wind']['speed']
              .toString(); // in m/s (default) or mph (if units=imperial)
          final humidity =
              dataZ['list'][0]['main']['humidity'].toString(); // in %
          final feelsLike = dataZ['list'][0]['main']['feels_like'] - 273.16;
          final roundedFeelsTemp = double.parse((feelsLike).toStringAsFixed(2));

          //User-Interface

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // search box

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              hintText: "Search your desired location",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            cityName = textEditingController.text;
                          });
                        },
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  
                  const SizedBox(
                    height: 10,
                  ),
                  //main card
                  SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: Card(
                        elevation: 7,
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(33)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(33),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "$roundedTemp °C",
                                      style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Image.network(
                                    iconUrl,
                                    width: 110,
                                    height: 110,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Text(
                                      currentSky,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
              
                  //weatherforecastcard
                  const SizedBox(
                    height: 10,
                  ),
              
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Weather Forecast",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      )),
              
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final hourlyTemp = dataZ['list'][index]['main']['temp'] -
                            273.16; // Convert from Kelvin to Celsius
                        final roundedHourlyTemp = hourlyTemp
                            .toStringAsFixed(2); // Round to 2 decimal places
                        final hourlyCurrentIconCode = dataZ['list'][index]
                            ['weather'][0]['icon']; // Corrected index here
                        final hourlyIconUrl =
                            "https://openweathermap.org/img/wn/$hourlyCurrentIconCode@2x.png"; // Corrected variable name
                        
                        final time= DateTime.parse(dataZ['list'][index]['dt_txt']); 
                        return HourlyForecastItem(
                          icon: Image.network(
                            hourlyIconUrl, // Corrected variable name
                            height: 50,
                            width: 50,
                          ),
                          weather: "$roundedHourlyTemp °C", // Use roundedHourlyTemp
                          timeZ: DateFormat.Hm().format(time),
                        );  
                      },
                    ),
                  ),
                  // Additional information
                  const SizedBox(
                    height: 10,
                  ),
              
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Live information",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: AdditionalInfoItems(
                              icon: Icons.water_drop,
                              label: "Humidity",
                              value: "$humidity %"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: AdditionalInfoItems(
                              icon: Icons.air,
                              label: "Windspeed",
                              value: "$windSpeed m/s"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: AdditionalInfoItems(
                              icon: Icons.arrow_circle_down,
                              label: "Pressure",
                              value: "$pressure hPa"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: AdditionalInfoItems(
                              icon: Icons.thermostat,
                              label: "Feels like",
                              value: "$roundedFeelsTemp °C"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
