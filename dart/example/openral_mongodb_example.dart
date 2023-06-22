import 'package:mongo_dart/mongo_dart.dart';
import 'package:openral_mongodb/openral_mongodb.dart';

import 'test_objects.dart';

Future<void> main() async {
  //! Start the mongoDB Test Instance first. $> ./start_mongo_test_instance.sh

  final repo = await _createRepository();

  // Create some RalObjects
  await repo.create(A, overrideIfExists: true);
  await repo.create(B, overrideIfExists: true);

  final objectsByContainerId = await repo.getByContainerId("C");
  print("Objects by container id 'C': ${objectsByContainerId.map((e) => e.identity.uid).toList()}"); //should be A and B

  final objectsByRalType = await repo.getByRalType("A_Type");
  print("Objects by ral type 'A_Type': ${objectsByRalType.map((e) => e.identity.uid).toList()}"); //should be A

  final objectByUid = await repo.getByUid("B");
  print("Object by uid: ${objectByUid.identity.uid}"); //should be B
}

///creates a [RalObjectRepositoryMongoDb] with a connection to a local mongoDB instance.
Future<RalObjectRepositoryMongoDb> _createRepository() async {
  const connectionString = "mongodb://localhost:27017/mydb";
  const collectionName = "ral_objects";

  final mongoDBConnection = MongoDBConnection(connectionString);

  final connectionResult = await mongoDBConnection.connect();

  if (connectionResult != null) {
    throw Exception("Failed to connect to MongoDB: $connectionResult");
  }

  print("Successfully connected to MongoDB");

  final database = mongoDBConnection.database;

  await database.createCollection(
    collectionName,
    createCollectionOptions: CreateCollectionOptions(),
  );

  final repo = RalObjectRepositoryMongoDb(
    mongoDb: database,
    collectionName: collectionName,
  );

  return repo;
}
