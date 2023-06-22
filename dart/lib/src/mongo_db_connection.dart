import 'package:mongo_dart/mongo_dart.dart';

/// A connection to a MongoDB database specified by a [connectionString]
/// The connection is established by calling [connect]
/// The database can be accessed via the [database] getter
class MongoDBConnection {
  ///The connection String is expected to look like this: "mongodb://localhost:27017/mydb"
  final String connectionString;

  Db? _database;

  bool _isConnected = false;

  MongoDBConnection(this.connectionString);

  bool get isConnected => _isConnected;

  ///tries to connect to the MongoDB database specified in the [connectionString]
  ///returns null if the connection was successful, otherwise returns an error message
  Future<String?> connect() async {
    try {
      if (connectionString.startsWith("mongodb://") == false) {
        throw Exception('$MongoDBConnection: Expected a string starting with "mongodb://", but got $connectionString.');
      }

      _database = await Db.create(connectionString);
      await _database?.open();
      _isConnected = true;

      return null;
    } catch (e) {
      _isConnected = false;
      return 'FAILED TO CONNECT TO MongoDB: $e';
    }
  }

  Db get database => _database!;
}
