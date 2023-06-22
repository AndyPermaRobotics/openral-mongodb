import 'package:mongo_dart/mongo_dart.dart';

Future<String?> mongoDbCreateMockData({
  required Db mongoDatabase,
  required String collectionName,
}) async {
  final docs = [
    {
      "identity": {
        "UID": "A",
        "name": "This is A",
        "siteTag": "",
      },
      "definition": {
        "definitionText": "",
        "definitionURL": "",
      },
      "objectState": "undefined",
      "template": {
        "RALType": "A Type",
        "version": "1",
        "objectStateTemplates": "",
      },
      "specificProperties": [],
      "currentGeolocation": {
        "container": {"UID": "B"}
      },
      "locationHistoryRef": [],
      "ownerHistoryRef": [],
      "methodHistoryRef": [],
      "linkedObjectRef": []
    },
    {
      "identity": {
        "UID": "B",
        "name": "This is B",
        "siteTag": "",
      },
      "definition": {
        "definitionText": "",
        "definitionURL": "",
      },
      "objectState": "undefined",
      "template": {"RALType": "mqtt_broker_service", "version": "1", "objectStateTemplates": ""},
      "specificProperties": [],
      "currentGeolocation": {},
      "locationHistoryRef": [],
      "ownerHistoryRef": [],
      "methodHistoryRef": [],
      "linkedObjectRef": []
    },
  ];

  await mongoDatabase.dropCollection(collectionName);

  final collectionResult = await mongoDatabase.createCollection(
    collectionName,
    createCollectionOptions: CreateCollectionOptions(),
  );

  print("create Collection Result: $collectionResult");

  final insertResult = await mongoDatabase.collection(collectionName).insertMany(docs);

  print("insertResult: ${insertResult.hasWriteErrors}");

  if (insertResult.hasWriteErrors) {
    print("insertResult: ${insertResult.writeErrors.map((e) => e.errmsg).toList().join("\n")}");
  }

  return null;
}
