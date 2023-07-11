import 'package:mongo_dart/mongo_dart.dart';
import 'package:openral_mongodb/openral_mongodb.dart';

import 'test_methods.dart';
import 'test_objects.dart';

Future<void> main() async {
  //! Start the mongoDB Test Instance first. $> ./start_mongodb_test_instance.sh

  final database = (await _getMongoDBConnection()).database;

  await _testObjectRepository(database);

  await _testMethodRepository(database);
}

Future<void> _testObjectRepository(Db database) async {
  final repo = await _createObjectRepository(database);

  // Create some RalObjects
  await repo.create(objectA, overrideIfExists: true);
  await repo.create(objectB, overrideIfExists: true);

  final objectsByContainerId = await repo.getByContainerId("C");
  print("Objects by container id 'C' (expected [A,B]): ${objectsByContainerId.map((e) => e.identity.uid).toList()}"); //should be A and B

  final objectsByRalType = await repo.getByRalType("A_Type");
  print("Objects by ral type 'A_Type' (expected [A]): ${objectsByRalType.map((e) => e.identity.uid).toList()}"); //should be A

  final objectByUid = await repo.getByUid("B");
  print("Object by uid (expected B): ${objectByUid.identity.uid}"); //should be B
}

Future<void> _testMethodRepository(Db database) async {
  final repo = await _createMethodRepository(database);

  repo.getStreamOfNewMethods().listen((newRalMethod) {
    print("New RalMethod detected: ${newRalMethod.identity.uid}");
  });

  // Create some RalMethods
  await repo.create(methodA, overrideIfExists: true);
  await repo.create(methodB, overrideIfExists: true);

  final byRalType = await repo.getByRalType("exampleMethod");
  print("Methods by ral type 'exampleMethod' (expected [methodA, methodB]): ${byRalType.map((e) => e.identity.uid).toList()}");

  final byUid = await repo.getByUid("methodB");
  print("Method by uid (expected methodB): ${byUid.identity.uid}");
}

///creates a [RalObjectRepositoryMongoDb] with a connection to a local mongoDB instance.
Future<RalObjectRepositoryMongoDb> _createObjectRepository(Db database) async {
  const collectionName = "ral_objects";

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

///creates a [RalMethodRepositoryMongoDb] with a connection to a local mongoDB instance.
Future<RalMethodRepositoryMongoDb> _createMethodRepository(Db database) async {
  const collectionName = "ral_methods";

  await database.createCollection(
    collectionName,
    createCollectionOptions: CreateCollectionOptions(),
  );

  final repo = RalMethodRepositoryMongoDb(
    mongoDb: database,
    collectionName: collectionName,
  );

  return repo;
}

Future<MongoDBConnection> _getMongoDBConnection() async {
  const connectionString = "mongodb://localhost:27017/mydb";

  final mongoDBConnection = MongoDBConnection(connectionString);

  final connectionResult = await mongoDBConnection.connect();

  if (connectionResult != null) {
    throw Exception("Failed to connect to MongoDB: $connectionResult");
  }

  print("Successfully connected to MongoDB");

  return mongoDBConnection;
}
