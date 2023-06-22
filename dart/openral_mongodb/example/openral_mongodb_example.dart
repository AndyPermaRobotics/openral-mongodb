import 'package:openral_mongodb/openral_mongodb.dart';

Future<void> main() async {
  //! Start the mongoDB Test Instance first. $> ./start_mongo_test_instance.sh

  final connectionString = "mongodb://localhost:27017/mydb";

  final mongoDBConnection = MongoDBConnection(connectionString);

  final connectionResult = await mongoDBConnection.connect();

  if (connectionResult != null) {
    print("Failed to connect to MongoDB: $connectionResult");
    return;
  }

  print("Successfully connected to MongoDB");

  final database = mongoDBConnection.database;
}
