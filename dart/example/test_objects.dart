import 'package:openral_core/openral_core.dart';

final A = RalObject(
  identity: Identity(
    uid: "A",
  ),
  definition: Definition(),
  template: Template(
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

final B = RalObject(
  identity: Identity(
    uid: "B",
  ),
  definition: Definition(),
  template: Template(
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
