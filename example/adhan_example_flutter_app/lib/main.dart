import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final location = Location();
  String? locationError;
  PrayerTimes? prayerTimes;

  @override
  void initState() {
    getLocationData().then((LocationData? locationData) {
      if (!mounted) {
        return;
      }
      if (locationData != null) {
        setState(() {
          prayerTimes = PrayerTimes(
              Coordinates(locationData.latitude!, locationData.longitude!),
              DateComponents.from(DateTime.now()),
              CalculationMethod.karachi.getParameters());
        });
      } else {
        setState(() {
          locationError = "Couldn't Get Your Location!";
        });
      }
    });

    super.initState();
  }

  Future<LocationData?> getLocationData() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    var _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(
              builder: (BuildContext context) {
                if (prayerTimes != null) {
                  return Column(
                    children: [
                      const Text('Prayer Times for Today', textAlign: TextAlign.center,),
                      Text('Fajr Time: ${DateFormat.jm().format(prayerTimes!.fajr!)}'),
                      Text('Sunrise Time: ${DateFormat.jm().format(prayerTimes!.sunrise!)}'),
                      Text('Dhuhr Time: ${DateFormat.jm().format(prayerTimes!.dhuhr!)}'),
                      Text('Asr Time: ${DateFormat.jm().format(prayerTimes!.asr!)}'),
                      Text('Maghrib Time: ${DateFormat.jm().format(prayerTimes!.maghrib!)}'),
                      Text('Isha Time: ${DateFormat.jm().format(prayerTimes!.isha!)}'),
                    ],
                  );
                }
                if (locationError != null) {
                  return Text(locationError!);
                }
                return const Text('Waiting for Your Location...');
              },
            )
          ],
        ),
      ),
    );
  }
}
