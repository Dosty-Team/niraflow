import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'dart:developer' as dev; // Dart's built-in logging library

class DatabaseService {
 
// Assuming you have these variables defined globally:
late mongo.Db db;
late mongo.DbCollection coll;

Future<void> connect() async {
  db = await mongo.Db.create(
      "mongodb+srv://giver_kdk:giverdb123@cluster0.lfo9ghw.mongodb.net/flowmi_db?retryWrites=true&w=majority&appName=Cluster0");
  await db.open();
  coll = db.collection('latest_lat_long_collection'); // Replace with your collection name
}



Future<void> insertCoordinates(double latitude, double longitude) async {
  try {
    await connect(); // Call the connect function to establish connection
    var document = {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': DateTime.now().toIso8601String()
    }; // Use a regular map instead of mongo.Map.from()
    await coll.insertOne(document);
    // dev.log('Coordinates inserted: $document'); // Assuming dev.log is your logging function
    print('Coordinates inserted: $document');
  } catch (e) {
    // dev.log('Error inserting coordinates: $e');
    print('Error inserting coordinates: $e');
    rethrow;
  } finally {
    await db.close();
    // dev.log('Database connection closed after insert');
    print('Database connection closed after insert');
  }
}

// for response from database
List<Map<String, dynamic>> _data = [];
 Future<List<Map<String, dynamic>>> fetchData() async {
   
    try {
      var db = await mongo.Db.create(
          "mongodb+srv://giver_kdk:giverdb123@cluster0.lfo9ghw.mongodb.net/flowmi_db?retryWrites=true&w=majority&appName=Cluster0");
      await db.open();
      var collection = db.collection('latest_lat_long_collection');
      await collection.find().forEach((v) {
        _data.add(v);
      });
      await db.close();
      // Log the data
      print(_data);
      return _data;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
