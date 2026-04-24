// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RiderDetailsStruct extends FFFirebaseStruct {
  RiderDetailsStruct({
    int? status,
    AuthTokenStruct? authToken,
    MasterRiderStruct? masterRider,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _status = status,
        _authToken = authToken,
        _masterRider = masterRider,
        super(firestoreUtilData);

  // "Status" field.
  int? _status;
  int get status => _status ?? 0;
  set status(int? val) => _status = val;

  void incrementStatus(int amount) => status = status + amount;

  bool hasStatus() => _status != null;

  // "AuthToken" field.
  AuthTokenStruct? _authToken;
  AuthTokenStruct get authToken => _authToken ?? AuthTokenStruct();
  set authToken(AuthTokenStruct? val) => _authToken = val;

  void updateAuthToken(Function(AuthTokenStruct) updateFn) {
    updateFn(_authToken ??= AuthTokenStruct());
  }

  bool hasAuthToken() => _authToken != null;

  // "MasterRider" field.
  MasterRiderStruct? _masterRider;
  MasterRiderStruct get masterRider => _masterRider ?? MasterRiderStruct();
  set masterRider(MasterRiderStruct? val) => _masterRider = val;

  void updateMasterRider(Function(MasterRiderStruct) updateFn) {
    updateFn(_masterRider ??= MasterRiderStruct());
  }

  bool hasMasterRider() => _masterRider != null;

  static RiderDetailsStruct fromMap(Map<String, dynamic> data) =>
      RiderDetailsStruct(
        status: castToType<int>(data['Status']),
        authToken: data['AuthToken'] is AuthTokenStruct
            ? data['AuthToken']
            : AuthTokenStruct.maybeFromMap(data['AuthToken']),
        masterRider: data['MasterRider'] is MasterRiderStruct
            ? data['MasterRider']
            : MasterRiderStruct.maybeFromMap(data['MasterRider']),
      );

  static RiderDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? RiderDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Status': _status,
        'AuthToken': _authToken?.toMap(),
        'MasterRider': _masterRider?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Status': serializeParam(
          _status,
          ParamType.int,
        ),
        'AuthToken': serializeParam(
          _authToken,
          ParamType.DataStruct,
        ),
        'MasterRider': serializeParam(
          _masterRider,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static RiderDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      RiderDetailsStruct(
        status: deserializeParam(
          data['Status'],
          ParamType.int,
          false,
        ),
        authToken: deserializeStructParam(
          data['AuthToken'],
          ParamType.DataStruct,
          false,
          structBuilder: AuthTokenStruct.fromSerializableMap,
        ),
        masterRider: deserializeStructParam(
          data['MasterRider'],
          ParamType.DataStruct,
          false,
          structBuilder: MasterRiderStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RiderDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RiderDetailsStruct &&
        status == other.status &&
        authToken == other.authToken &&
        masterRider == other.masterRider;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([status, authToken, masterRider]);
}

RiderDetailsStruct createRiderDetailsStruct({
  int? status,
  AuthTokenStruct? authToken,
  MasterRiderStruct? masterRider,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RiderDetailsStruct(
      status: status,
      authToken: authToken ?? (clearUnsetFields ? AuthTokenStruct() : null),
      masterRider:
          masterRider ?? (clearUnsetFields ? MasterRiderStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RiderDetailsStruct? updateRiderDetailsStruct(
  RiderDetailsStruct? riderDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    riderDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRiderDetailsStructData(
  Map<String, dynamic> firestoreData,
  RiderDetailsStruct? riderDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (riderDetails == null) {
    return;
  }
  if (riderDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && riderDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final riderDetailsData =
      getRiderDetailsFirestoreData(riderDetails, forFieldValue);
  final nestedData =
      riderDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = riderDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRiderDetailsFirestoreData(
  RiderDetailsStruct? riderDetails, [
  bool forFieldValue = false,
]) {
  if (riderDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(riderDetails.toMap());

  // Handle nested data for "AuthToken" field.
  addAuthTokenStructData(
    firestoreData,
    riderDetails.hasAuthToken() ? riderDetails.authToken : null,
    'AuthToken',
    forFieldValue,
  );

  // Handle nested data for "MasterRider" field.
  addMasterRiderStructData(
    firestoreData,
    riderDetails.hasMasterRider() ? riderDetails.masterRider : null,
    'MasterRider',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(riderDetails.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRiderDetailsListFirestoreData(
  List<RiderDetailsStruct>? riderDetailss,
) =>
    riderDetailss?.map((e) => getRiderDetailsFirestoreData(e, true)).toList() ??
    [];
