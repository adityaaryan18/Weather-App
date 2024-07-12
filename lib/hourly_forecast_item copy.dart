import "package:flutter/material.dart";

//Hourly forecast item cards
class HourlyForecastItem extends StatelessWidget {
  final String timeZ;
  final Image icon;
  final String weather;
  const HourlyForecastItem({super.key,
  required this.timeZ,
  required this.icon,
  required this.weather
  
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            Text(
              timeZ,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            icon,
            Text(
              weather,
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
