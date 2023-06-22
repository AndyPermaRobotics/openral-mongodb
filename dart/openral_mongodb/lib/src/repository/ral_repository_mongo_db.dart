import 'package:mongo_dart/mongo_dart.dart';
import 'package:openral_core/src/model/ral_object.dart';
import 'package:openral_core/src/model/specific_properties.dart';
import 'package:openral_core/src/repository/ral_object_repository.dart';

class RalObjectRepositoryMongoDb extends RalObjectRepository {
  final String collectionName;

  ///The MongoDB database. Use [MongoDBConnection] to create a connection to a MongoDB database.
  final Db mongoDb;

  RalObjectRepositoryMongoDb({
    required this.collectionName,
    required this.mongoDb,
  });

  @override
  Future<void> create(RalObject<SpecificProperties> ralObject, {required bool overrideIfExists}) async {
    final collection = mongoDb.collection(collectionName);

    final result = await collection.insert(ralObject.toMap());

    print("create result: $result");
  }

  @override
  Future<List<RalObject<SpecificProperties>>> getByContainerId(String containerId) async {
    final selector = where.eq("currentGeolocation.container.UID", containerId);

    final ralObjects = _getObjectsBySelector(selector);

    return ralObjects;
  }

  @override
  Future<List<RalObject<SpecificProperties>>> getByRalType(String ralType) {
    final selector = where.eq("template.RALType", ralType);

    final ralObjects = _getObjectsBySelector(selector);

    return ralObjects;
  }

  ///returns all [RalObjects] in the MongoDB that match the given [selectorBuilder]
  Future<List<RalObject<SpecificProperties>>> _getObjectsBySelector(SelectorBuilder selectorBuilder) async {
    final collection = mongoDb.collection(collectionName);

    final docs = await collection.find(selectorBuilder).toList();

    List<RalObject<SpecificProperties>> ralObjects = [];

    for (final doc in docs) {
      final parsingResult = RalObject.fromMap(doc);

      if (parsingResult.isRight) {
        throw Exception(parsingResult.right);
      }

      final ralObject = parsingResult.left;
      ralObjects.add(ralObject);
    }

    return ralObjects;
  }

  @override
  Future<RalObject<SpecificProperties>> getByUid(String uid, {SpecificPropertiesTransform<SpecificProperties>? specificPropertiesTransform}) async {
    final collection = mongoDb.collection(collectionName);

    final doc = await collection.findOne(where.eq("identity.UID", uid));

    if (doc == null) {
      throw Exception("No RalObject found for uid '$uid'");
    }

    final parsingResult = RalObject.fromMap(
      doc,
      specificPropertiesTransform: specificPropertiesTransform,
    );

    if (parsingResult.isRight) {
      throw Exception(parsingResult.right);
    }

    final ralObject = parsingResult.left;
    return ralObject;
  }
}
