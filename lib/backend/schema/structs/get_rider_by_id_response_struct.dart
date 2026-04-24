// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GetRiderByIdResponseStruct extends FFFirebaseStruct {
  GetRiderByIdResponseStruct({
    int? status,
    RiderVMStruct? riderVM,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _status = status,
        _riderVM = riderVM,
        super(firestoreUtilData);

  // "Status" field.
  int? _status;
  int get status => _status ?? 0;
  set status(int? val) => _status = val;

  void incrementStatus(int amount) => status = status + amount;

  bool hasStatus() => _status != null;

  // "RiderVM" field.
  RiderVMStruct? _riderVM;
  RiderVMStruct get riderVM => _riderVM ?? RiderVMStruct();
  set riderVM(RiderVMStruct? val) => _riderVM = val;

  void updateRiderVM(Function(RiderVMStruct) updateFn) {
    updateFn(_riderVM ??= RiderVMStruct());
  }

  bool hasRiderVM() => _riderVM != null;

  static GetRiderByIdResponseStruct fromMap(Map<String, dynamic> data) =>
      GetRiderByIdResponseStruct(
        status: castToType<int>(data['Status']),
        riderVM: data['RiderVM'] is RiderVMStruct
            ? data['RiderVM']
            : RiderVMStruct.maybeFromMap(data['RiderVM']),
      );

  static GetRiderByIdResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? GetRiderByIdResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Status': _status,
        'RiderVM': _riderVM?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Status': serializeParam(
          _status,
          ParamType.int,
        ),
        'RiderVM': serializeParam(
          _riderVM,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static GetRiderByIdResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      GetRiderByIdResponseStruct(
        status: deserializeParam(
          data['Status'],
          ParamType.int,
          false,
        ),
        riderVM: deserializeStructParam(
          data['RiderVM'],
          ParamType.DataStruct,
          false,
          structBuilder: RiderVMStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'GetRiderByIdResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GetRiderByIdResponseStruct &&
        status == other.status &&
        riderVM == other.riderVM;
  }

  @override
  int get hashCode => const ListEquality().hash([status, riderVM]);
}

GetRiderByIdResponseStruct createGetRiderByIdResponseStruct({
  int? status,
  RiderVMStruct? riderVM,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GetRiderByIdResponseStruct(
      status: status,
      riderVM: riderVM ?? (clearUnsetFields ? RiderVMStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GetRiderByIdResponseStruct? updateGetRiderByIdResponseStruct(
  GetRiderByIdResponseStruct? getRiderByIdResponse, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    getRiderByIdResponse
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGetRiderByIdResponseStructData(
  Map<String, dynamic> firestoreData,
  GetRiderByIdResponseStruct? getRiderByIdResponse,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (getRiderByIdResponse == null) {
    return;
  }
  if (getRiderByIdResponse.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && getRiderByIdResponse.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final getRiderByIdResponseData =
      getGetRiderByIdResponseFirestoreData(getRiderByIdResponse, forFieldValue);
  final nestedData =
      getRiderByIdResponseData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      getRiderByIdResponse.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGetRiderByIdResponseFirestoreData(
  GetRiderByIdResponseStruct? getRiderByIdResponse, [
  bool forFieldValue = false,
]) {
  if (getRiderByIdResponse == null) {
    return {};
  }
  final firestoreData = mapToFirestore(getRiderByIdResponse.toMap());

  // Handle nested data for "RiderVM" field.
  addRiderVMStructData(
    firestoreData,
    getRiderByIdResponse.hasRiderVM() ? getRiderByIdResponse.riderVM : null,
    'RiderVM',
    forFieldValue,
  );

  // Add any Firestore field values
  mapToFirestore(getRiderByIdResponse.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGetRiderByIdResponseListFirestoreData(
  List<GetRiderByIdResponseStruct>? getRiderByIdResponses,
) =>
    getRiderByIdResponses
        ?.map((e) => getGetRiderByIdResponseFirestoreData(e, true))
        .toList() ??
    [];
