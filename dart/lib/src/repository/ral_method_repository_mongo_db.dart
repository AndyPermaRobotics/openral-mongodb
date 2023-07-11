import 'package:mongo_dart/mongo_dart.dart';
import 'package:openral_core/openral_core.dart';

class RalMethodRepositoryMongoDb extends RalMethodRepository {
  final String collectionName;

  ///The MongoDB database. Use [MongoDBConnection] to create a connection to a MongoDB database.
  final Db mongoDb;

  RalMethodRepositoryMongoDb({
    required this.collectionName,
    required this.mongoDb,
  });

  @override
  Future<void> create(RalMethod ralMethod, {required bool overrideIfExists}) async {
    final collection = mongoDb.collection(collectionName);

    if (overrideIfExists) {
      final result = await collection.replaceOne(where.eq("identity.UID", ralMethod.identity.uid), ralMethod.toMap());

      if (result.isFailure) {
        print("Failed to remove existing RalMethod with uid '${ralMethod.identity.uid}': ${result.errmsg}");
      }
    } else {
      final result = await collection.insertOne(ralMethod.toMap());

      if (result.isFailure) {
        throw Exception("Failed to insert RalMethod '${ralMethod.identity.uid}': $result");
      }
    }
  }

  @override
  Future<List<RalMethod>> getByRalType(String ralType) async {
    final selector = where.eq("template.RALType", ralType);

    final ralMethods = await _getElementsBySelector(selector);

    return ralMethods;
  }

  ///returns all [RalMethod] in the MongoDB that match the given [selectorBuilder]
  Future<List<RalMethod>> _getElementsBySelector(SelectorBuilder selectorBuilder) async {
    final collection = mongoDb.collection(collectionName);

    final docs = await collection.find(selectorBuilder).toList();

    List<RalMethod> ralMethods = [];

    for (final doc in docs) {
      final ralMethod = RalMethod.fromMap(doc);

      ralMethods.add(ralMethod);
    }

    return ralMethods;
  }

  @override
  Future<RalMethod> getByUid(String uid) async {
    final collection = mongoDb.collection(collectionName);

    final doc = await collection.findOne(where.eq("identity.UID", uid));

    if (doc == null) {
      throw Exception("No RalMethod found for uid '$uid'");
    }

    final ralMethod = RalMethod.fromMap(
      doc,
    );

    return ralMethod;
  }

  ///Returns a stream of newly created RalMethods in the repository.
  ///Every newly created RalMethod will be added to this stream.
  // Stream<RalMethod> getStreamOfNewMethods() {
  //   return mongoDb.collection(collectionName).watch().map((event) {
  //     final doc = event.fullDocument;

  //     final ralMethod = RalMethod.fromMap(doc);

  //     return ralMethod;
  //   });
  // }
}
