// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class AuthTokenStruct extends FFFirebaseStruct {
  AuthTokenStruct({
    String? token,
    String? expireToken,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _token = token,
        _expireToken = expireToken,
        super(firestoreUtilData);

  // "Token" field.
  String? _token;
  String get token => _token ?? '';
  set token(String? val) => _token = val;

  bool hasToken() => _token != null;

  // "expireToken" field.
  String? _expireToken;
  String get expireToken => _expireToken ?? '';
  set expireToken(String? val) => _expireToken = val;

  bool hasExpireToken() => _expireToken != null;

  static AuthTokenStruct fromMap(Map<String, dynamic> data) => AuthTokenStruct(
        token: data['Token'] as String?,
        expireToken: data['expireToken'] as String?,
      );

  static AuthTokenStruct? maybeFromMap(dynamic data) => data is Map
      ? AuthTokenStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'Token': _token,
        'expireToken': _expireToken,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'Token': serializeParam(
          _token,
          ParamType.String,
        ),
        'expireToken': serializeParam(
          _expireToken,
          ParamType.String,
        ),
      }.withoutNulls;

  static AuthTokenStruct fromSerializableMap(Map<String, dynamic> data) =>
      AuthTokenStruct(
        token: deserializeParam(
          data['Token'],
          ParamType.String,
          false,
        ),
        expireToken: deserializeParam(
          data['expireToken'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AuthTokenStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AuthTokenStruct &&
        token == other.token &&
        expireToken == other.expireToken;
  }

  @override
  int get hashCode => const ListEquality().hash([token, expireToken]);
}

AuthTokenStruct createAuthTokenStruct({
  String? token,
  String? expireToken,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    AuthTokenStruct(
      token: token,
      expireToken: expireToken,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

AuthTokenStruct? updateAuthTokenStruct(
  AuthTokenStruct? authToken, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    authToken
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addAuthTokenStructData(
  Map<String, dynamic> firestoreData,
  AuthTokenStruct? authToken,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (authToken == null) {
    return;
  }
  if (authToken.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && authToken.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final authTokenData = getAuthTokenFirestoreData(authToken, forFieldValue);
  final nestedData = authTokenData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = authToken.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getAuthTokenFirestoreData(
  AuthTokenStruct? authToken, [
  bool forFieldValue = false,
]) {
  if (authToken == null) {
    return {};
  }
  final firestoreData = mapToFirestore(authToken.toMap());

  // Add any Firestore field values
  mapToFirestore(authToken.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getAuthTokenListFirestoreData(
  List<AuthTokenStruct>? authTokens,
) =>
    authTokens?.map((e) => getAuthTokenFirestoreData(e, true)).toList() ?? [];
