import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:withoutmap/recommend/Databaseclass.dart';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
class RoutePlanner extends StatefulWidget {
  @override
  _RoutePlannerState createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  final String PLACES_API_KEY = "AIzaSyBB1JHlFe7Yo9UnBfijwXeHi4yxLhRnoXE"; // Replace with your actual API key
  List<String> _fromPlaceList = [];
  List<String> _toPlaceList = [];
  Map<String, String> _fromPlaceIds = {};
  Map<String, String> _toPlaceIds = {};
  final DatabaseService dbService = DatabaseService();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _getPlaceSuggestions(String input, bool isFrom) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$PLACES_API_KEY';

    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        List<dynamic> predictions = data['predictions'];
        List<String> placeNames = [];
        Map<String, String> placeIds = {};
        for (var prediction in predictions) {
          placeNames.add(prediction['description']);
          placeIds[prediction['description']] = prediction['place_id'];
        }
        setState(() {
          if (isFrom) {
            _fromPlaceList = placeNames;
            _fromPlaceIds = placeIds;
          } else {
            _toPlaceList = placeNames;
            _toPlaceIds = placeIds;
          }
        });
      } else {
        print("Failed to fetch predictions. Status code: ${response.statusCode}");
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print("Error fetching place suggestions: $e");
    }
  }

  Future<Map<String, double>> _getLatLngFromPlaceId(String placeId) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request = '$baseURL?place_id=$placeId&key=$PLACES_API_KEY';
    try {
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var location = data['result']['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      } else {
        print("Failed to fetch place details. Status code: ${response.statusCode}");
        throw Exception('Failed to load coordinates');
      }
    } catch (e) {
      print("Error fetching coordinates: $e");
      throw Exception("Error fetching coordinates: $e");
    }
  }

  void _handleCoordinatesLogging() async {
    bool startcondition = false;  // Consider revising your logic for toggling this

    if (startcondition) {
      try {
        var fromCoordinates = await _getLatLngFromPlaceId(_fromPlaceIds[_fromController.text]!);
        var toCoordinates = await _getLatLngFromPlaceId(_toPlaceIds[_toController.text]!);

        double fromLat = fromCoordinates['latitude'] ?? 0.0;
        double fromLng = fromCoordinates['longitude'] ?? 0.0;
        double toLat = toCoordinates['latitude'] ?? 0.0;
        double toLng = toCoordinates['longitude'] ?? 0.0;

        await dbService.insertCoordinates(fromLat, fromLng);
        await dbService.insertCoordinates(toLat, toLng);
      } catch (e) {
        print("Error in inserting coordinates: $e");
      }
    } else {
        print('outer Attempting to fetch coordinates');
       List<Map<String, dynamic>> listlog =  await dbService.fetchData();
        print('the list of logged value for coordinates are : $listlog');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Route Planner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fromController,
                decoration: InputDecoration(labelText: "From"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a starting point';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _getPlaceSuggestions(value, true);
                  }
                },
              ),
              if (_fromPlaceList.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: _fromPlaceList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_fromPlaceList[index]),
                        onTap: () {
                          setState(() {
                            _fromController.text = _fromPlaceList[index];
                            _fromPlaceList = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              TextFormField(
                controller: _toController,
                decoration: InputDecoration(labelText: "To"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _getPlaceSuggestions(value, false);
                  }
                },
              ),
              if (_toPlaceList.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: _toPlaceList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_toPlaceList[index]),
                        onTap: () {
                          setState(() {
                            _toController.text = _toPlaceList[index];
                            _toPlaceList = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleCoordinatesLogging,
                child: Text("Log Coordinates"),
              ),
              SizedBox(height: 20),
              // Expanded(
              //   child: FutureBuilder<List<Map<String, dynamic>>>(
              //     future: dbService.fetchAllCoordinates(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       } else if (snapshot.hasError) {
              //         return Text('Error fetching data: ${snapshot.error}');
              //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //         return Text('No coordinates found.');
              //       }

              //       final data = snapshot.data!;

              //       return ListView.builder(
              //         itemCount: data.length,
              //         itemBuilder: (context, index) {
              //           final item = data[index];
              //           return ListTile(
              //             title: Text('Latitude: ${item['latitude']?.toString() ?? 'No latitude'}'),
              //             subtitle: Text('Longitude: ${item['longitude']?.toString() ?? 'No longitude'}'),
              //             trailing: Text('Timestamp: ${item['timestamp'] ?? 'No timestamp'}'),
              //           );
              //         },
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
