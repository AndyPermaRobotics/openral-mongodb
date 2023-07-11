import 'package:openral_core/openral_core.dart';

final objectA = RalObject(
  identity: Identity(
    uid: "A",
  ),
  definition: Definition(),
  template: ObjectTemplate(
    ralType: "A_Type",
    version: "1.0",
  ),
  specificProperties: SpecificProperties({}),
  currentGeoLocation: CurrentGeoLocation(
    container: Container(
      uid: "C",
    ),
  ),
);

final objectB = RalObject(
  identity: Identity(
    uid: "B",
  ),
  definition: Definition(),
  template: ObjectTemplate(
    ralType: "B_Type",
    version: "1.0",
  ),
  specificProperties: SpecificProperties({}),
  currentGeoLocation: CurrentGeoLocation(
    container: Container(
      uid: "C",
    ),
  ),
);
