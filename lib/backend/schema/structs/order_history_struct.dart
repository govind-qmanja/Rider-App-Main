// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OrderHistoryStruct extends FFFirebaseStruct {
  OrderHistoryStruct({
    int? status,
    List<CompletedOrdersStruct>? completedOrders,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _status = status,
        _completedOrders = completedOrders,
        super(firestoreUtilData);

  // "Status" field.
  int? _status;
  int get status => _status ?? 0;
  set status(int? val) => _status = val;

  void incrementStatus(int amount) => status = status + amount;

  bool hasStatus() => _status != null;

  // "CompletedOrders" field.
  List<CompletedOrdersStruct>? _completedOrders;
  List<CompletedOrdersStruct> get completedOrders =>
      _completedOrders ?? const [];
  set completedOrders(List<CompletedOrdersStruct>? val) =>
      _completedOrders = val;

  void updateCompletedOrders(Function(List<CompletedOrdersStruct>) updateFn) {
    updateFn(_completedOrders ??= []);
  }

  bool hasCompletedOrders() => _completedOrders != null;

  static OrderHistoryStruct fromMap(Map<String, dynamic> data) =>
      OrderHistoryStruct(
        status: castToType<int>(data['Status']),
        completedOrders: getStructList(
          data['CompletedOrders'],
          CompletedOrdersStruct.fromMap,
        ),
      );

  static OrderHistoryStruct? maybeFromMap(dynamic data) => data is Map
      ? OrderHistoryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Status': _status,
        'CompletedOrders': _completedOrders?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Status': serializeParam(
          _status,
          ParamType.int,
        ),
        'CompletedOrders': serializeParam(
          _completedOrders,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static OrderHistoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      OrderHistoryStruct(
        status: deserializeParam(
          data['Status'],
          ParamType.int,
          false,
        ),
        completedOrders: deserializeStructParam<CompletedOrdersStruct>(
          data['CompletedOrders'],
          ParamType.DataStruct,
          true,
          structBuilder: CompletedOrdersStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'OrderHistoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is OrderHistoryStruct &&
        status == other.status &&
        listEquality.equals(completedOrders, other.completedOrders);
  }

  @override
  int get hashCode => const ListEquality().hash([status, completedOrders]);
}

OrderHistoryStruct createOrderHistoryStruct({
  int? status,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    OrderHistoryStruct(
      status: status,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

OrderHistoryStruct? updateOrderHistoryStruct(
  OrderHistoryStruct? orderHistory, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    orderHistory
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addOrderHistoryStructData(
  Map<String, dynamic> firestoreData,
  OrderHistoryStruct? orderHistory,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (orderHistory == null) {
    return;
  }
  if (orderHistory.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && orderHistory.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final orderHistoryData =
      getOrderHistoryFirestoreData(orderHistory, forFieldValue);
  final nestedData =
      orderHistoryData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = orderHistory.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getOrderHistoryFirestoreData(
  OrderHistoryStruct? orderHistory, [
  bool forFieldValue = false,
]) {
  if (orderHistory == null) {
    return {};
  }
  final firestoreData = mapToFirestore(orderHistory.toMap());

  // Add any Firestore field values
  mapToFirestore(orderHistory.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getOrderHistoryListFirestoreData(
  List<OrderHistoryStruct>? orderHistorys,
) =>
    orderHistorys?.map((e) => getOrderHistoryFirestoreData(e, true)).toList() ??
    [];
