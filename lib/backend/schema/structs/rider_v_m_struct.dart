// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RiderVMStruct extends FFFirebaseStruct {
  RiderVMStruct({
    int? riderId,
    String? username,
    String? passsword,
    String? name,
    String? phone,
    String? address,
    List<int>? businessid,
    String? adharcardimagepath,
    String? dlimagepath,
    bool? isVerified,
    bool? isActive,
    String? adharcardnumber,
    String? drivinglicensenumber,
    String? riderLat,
    String? riderLong,
    String? updatedOn,
    String? lastLocationUpdatedOn,
    bool? isLocationEnable,
    bool? onDuty,
    String? token,
    String? expireToken,
    int? onboardedBusinessId,
    int? newOTP,
    String? expireOTP,
    int? oldOTP,
    String? resetOTP,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _riderId = riderId,
        _username = username,
        _passsword = passsword,
        _name = name,
        _phone = phone,
        _address = address,
        _businessid = businessid,
        _adharcardimagepath = adharcardimagepath,
        _dlimagepath = dlimagepath,
        _isVerified = isVerified,
        _isActive = isActive,
        _adharcardnumber = adharcardnumber,
        _drivinglicensenumber = drivinglicensenumber,
        _riderLat = riderLat,
        _riderLong = riderLong,
        _updatedOn = updatedOn,
        _lastLocationUpdatedOn = lastLocationUpdatedOn,
        _isLocationEnable = isLocationEnable,
        _onDuty = onDuty,
        _token = token,
        _expireToken = expireToken,
        _onboardedBusinessId = onboardedBusinessId,
        _newOTP = newOTP,
        _expireOTP = expireOTP,
        _oldOTP = oldOTP,
        _resetOTP = resetOTP,
        super(firestoreUtilData);

  // "RiderId" field.
  int? _riderId;
  int get riderId => _riderId ?? 0;
  set riderId(int? val) => _riderId = val;

  void incrementRiderId(int amount) => riderId = riderId + amount;

  bool hasRiderId() => _riderId != null;

  // "Username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

  // "Passsword" field.
  String? _passsword;
  String get passsword => _passsword ?? '';
  set passsword(String? val) => _passsword = val;

  bool hasPasssword() => _passsword != null;

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "Phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "Address" field.
  String? _address;
  String get address => _address ?? '';
  set address(String? val) => _address = val;

  bool hasAddress() => _address != null;

  // "Businessid" field.
  List<int>? _businessid;
  List<int> get businessid => _businessid ?? const [];
  set businessid(List<int>? val) => _businessid = val;

  void updateBusinessid(Function(List<int>) updateFn) {
    updateFn(_businessid ??= []);
  }

  bool hasBusinessid() => _businessid != null;

  // "Adharcardimagepath" field.
  String? _adharcardimagepath;
  String get adharcardimagepath => _adharcardimagepath ?? '';
  set adharcardimagepath(String? val) => _adharcardimagepath = val;

  bool hasAdharcardimagepath() => _adharcardimagepath != null;

  // "Dlimagepath" field.
  String? _dlimagepath;
  String get dlimagepath => _dlimagepath ?? '';
  set dlimagepath(String? val) => _dlimagepath = val;

  bool hasDlimagepath() => _dlimagepath != null;

  // "IsVerified" field.
  bool? _isVerified;
  bool get isVerified => _isVerified ?? false;
  set isVerified(bool? val) => _isVerified = val;

  bool hasIsVerified() => _isVerified != null;

  // "IsActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "Adharcardnumber" field.
  String? _adharcardnumber;
  String get adharcardnumber => _adharcardnumber ?? '';
  set adharcardnumber(String? val) => _adharcardnumber = val;

  bool hasAdharcardnumber() => _adharcardnumber != null;

  // "Drivinglicensenumber" field.
  String? _drivinglicensenumber;
  String get drivinglicensenumber => _drivinglicensenumber ?? '';
  set drivinglicensenumber(String? val) => _drivinglicensenumber = val;

  bool hasDrivinglicensenumber() => _drivinglicensenumber != null;

  // "RiderLat" field.
  String? _riderLat;
  String get riderLat => _riderLat ?? '';
  set riderLat(String? val) => _riderLat = val;

  bool hasRiderLat() => _riderLat != null;

  // "RiderLong" field.
  String? _riderLong;
  String get riderLong => _riderLong ?? '';
  set riderLong(String? val) => _riderLong = val;

  bool hasRiderLong() => _riderLong != null;

  // "UpdatedOn" field.
  String? _updatedOn;
  String get updatedOn => _updatedOn ?? '';
  set updatedOn(String? val) => _updatedOn = val;

  bool hasUpdatedOn() => _updatedOn != null;

  // "LastLocationUpdatedOn" field.
  String? _lastLocationUpdatedOn;
  String get lastLocationUpdatedOn => _lastLocationUpdatedOn ?? '';
  set lastLocationUpdatedOn(String? val) => _lastLocationUpdatedOn = val;

  bool hasLastLocationUpdatedOn() => _lastLocationUpdatedOn != null;

  // "IsLocationEnable" field.
  bool? _isLocationEnable;
  bool get isLocationEnable => _isLocationEnable ?? false;
  set isLocationEnable(bool? val) => _isLocationEnable = val;

  bool hasIsLocationEnable() => _isLocationEnable != null;

  // "OnDuty" field.
  bool? _onDuty;
  bool get onDuty => _onDuty ?? false;
  set onDuty(bool? val) => _onDuty = val;

  bool hasOnDuty() => _onDuty != null;

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

  // "OnboardedBusinessId" field.
  int? _onboardedBusinessId;
  int get onboardedBusinessId => _onboardedBusinessId ?? 0;
  set onboardedBusinessId(int? val) => _onboardedBusinessId = val;

  void incrementOnboardedBusinessId(int amount) =>
      onboardedBusinessId = onboardedBusinessId + amount;

  bool hasOnboardedBusinessId() => _onboardedBusinessId != null;

  // "newOTP" field.
  int? _newOTP;
  int get newOTP => _newOTP ?? 0;
  set newOTP(int? val) => _newOTP = val;

  void incrementNewOTP(int amount) => newOTP = newOTP + amount;

  bool hasNewOTP() => _newOTP != null;

  // "expireOTP" field.
  String? _expireOTP;
  String get expireOTP => _expireOTP ?? '';
  set expireOTP(String? val) => _expireOTP = val;

  bool hasExpireOTP() => _expireOTP != null;

  // "oldOTP" field.
  int? _oldOTP;
  int get oldOTP => _oldOTP ?? 0;
  set oldOTP(int? val) => _oldOTP = val;

  void incrementOldOTP(int amount) => oldOTP = oldOTP + amount;

  bool hasOldOTP() => _oldOTP != null;

  // "resetOTP" field.
  String? _resetOTP;
  String get resetOTP => _resetOTP ?? '';
  set resetOTP(String? val) => _resetOTP = val;

  bool hasResetOTP() => _resetOTP != null;

  static RiderVMStruct fromMap(Map<String, dynamic> data) => RiderVMStruct(
        riderId: castToType<int>(data['RiderId']),
        username: data['Username'] as String?,
        passsword: data['Passsword'] as String?,
        name: data['Name'] as String?,
        phone: data['Phone'] as String?,
        address: data['Address'] as String?,
        businessid: getDataList(data['Businessid']),
        adharcardimagepath: data['Adharcardimagepath'] as String?,
        dlimagepath: data['Dlimagepath'] as String?,
        isVerified: data['IsVerified'] as bool?,
        isActive: data['IsActive'] as bool?,
        adharcardnumber: data['Adharcardnumber'] as String?,
        drivinglicensenumber: data['Drivinglicensenumber'] as String?,
        riderLat: data['RiderLat'] as String?,
        riderLong: data['RiderLong'] as String?,
        updatedOn: data['UpdatedOn'] as String?,
        lastLocationUpdatedOn: data['LastLocationUpdatedOn'] as String?,
        isLocationEnable: data['IsLocationEnable'] as bool?,
        onDuty: data['OnDuty'] as bool?,
        token: data['Token'] as String?,
        expireToken: data['expireToken'] as String?,
        onboardedBusinessId: castToType<int>(data['OnboardedBusinessId']),
        newOTP: castToType<int>(data['newOTP']),
        expireOTP: data['expireOTP'] as String?,
        oldOTP: castToType<int>(data['oldOTP']),
        resetOTP: data['resetOTP'] as String?,
      );

  static RiderVMStruct? maybeFromMap(dynamic data) =>
      data is Map ? RiderVMStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RiderId': _riderId,
        'Username': _username,
        'Passsword': _passsword,
        'Name': _name,
        'Phone': _phone,
        'Address': _address,
        'Businessid': _businessid,
        'Adharcardimagepath': _adharcardimagepath,
        'Dlimagepath': _dlimagepath,
        'IsVerified': _isVerified,
        'IsActive': _isActive,
        'Adharcardnumber': _adharcardnumber,
        'Drivinglicensenumber': _drivinglicensenumber,
        'RiderLat': _riderLat,
        'RiderLong': _riderLong,
        'UpdatedOn': _updatedOn,
        'LastLocationUpdatedOn': _lastLocationUpdatedOn,
        'IsLocationEnable': _isLocationEnable,
        'OnDuty': _onDuty,
        'Token': _token,
        'expireToken': _expireToken,
        'OnboardedBusinessId': _onboardedBusinessId,
        'newOTP': _newOTP,
        'expireOTP': _expireOTP,
        'oldOTP': _oldOTP,
        'resetOTP': _resetOTP,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RiderId': serializeParam(
          _riderId,
          ParamType.int,
        ),
        'Username': serializeParam(
          _username,
          ParamType.String,
        ),
        'Passsword': serializeParam(
          _passsword,
          ParamType.String,
        ),
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
        'Phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'Address': serializeParam(
          _address,
          ParamType.String,
        ),
        'Businessid': serializeParam(
          _businessid,
          ParamType.int,
          isList: true,
        ),
        'Adharcardimagepath': serializeParam(
          _adharcardimagepath,
          ParamType.String,
        ),
        'Dlimagepath': serializeParam(
          _dlimagepath,
          ParamType.String,
        ),
        'IsVerified': serializeParam(
          _isVerified,
          ParamType.bool,
        ),
        'IsActive': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'Adharcardnumber': serializeParam(
          _adharcardnumber,
          ParamType.String,
        ),
        'Drivinglicensenumber': serializeParam(
          _drivinglicensenumber,
          ParamType.String,
        ),
        'RiderLat': serializeParam(
          _riderLat,
          ParamType.String,
        ),
        'RiderLong': serializeParam(
          _riderLong,
          ParamType.String,
        ),
        'UpdatedOn': serializeParam(
          _updatedOn,
          ParamType.String,
        ),
        'LastLocationUpdatedOn': serializeParam(
          _lastLocationUpdatedOn,
          ParamType.String,
        ),
        'IsLocationEnable': serializeParam(
          _isLocationEnable,
          ParamType.bool,
        ),
        'OnDuty': serializeParam(
          _onDuty,
          ParamType.bool,
        ),
        'Token': serializeParam(
          _token,
          ParamType.String,
        ),
        'expireToken': serializeParam(
          _expireToken,
          ParamType.String,
        ),
        'OnboardedBusinessId': serializeParam(
          _onboardedBusinessId,
          ParamType.int,
        ),
        'newOTP': serializeParam(
          _newOTP,
          ParamType.int,
        ),
        'expireOTP': serializeParam(
          _expireOTP,
          ParamType.String,
        ),
        'oldOTP': serializeParam(
          _oldOTP,
          ParamType.int,
        ),
        'resetOTP': serializeParam(
          _resetOTP,
          ParamType.String,
        ),
      }.withoutNulls;

  static RiderVMStruct fromSerializableMap(Map<String, dynamic> data) =>
      RiderVMStruct(
        riderId: deserializeParam(
          data['RiderId'],
          ParamType.int,
          false,
        ),
        username: deserializeParam(
          data['Username'],
          ParamType.String,
          false,
        ),
        passsword: deserializeParam(
          data['Passsword'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['Phone'],
          ParamType.String,
          false,
        ),
        address: deserializeParam(
          data['Address'],
          ParamType.String,
          false,
        ),
        businessid: deserializeParam<int>(
          data['Businessid'],
          ParamType.int,
          true,
        ),
        adharcardimagepath: deserializeParam(
          data['Adharcardimagepath'],
          ParamType.String,
          false,
        ),
        dlimagepath: deserializeParam(
          data['Dlimagepath'],
          ParamType.String,
          false,
        ),
        isVerified: deserializeParam(
          data['IsVerified'],
          ParamType.bool,
          false,
        ),
        isActive: deserializeParam(
          data['IsActive'],
          ParamType.bool,
          false,
        ),
        adharcardnumber: deserializeParam(
          data['Adharcardnumber'],
          ParamType.String,
          false,
        ),
        drivinglicensenumber: deserializeParam(
          data['Drivinglicensenumber'],
          ParamType.String,
          false,
        ),
        riderLat: deserializeParam(
          data['RiderLat'],
          ParamType.String,
          false,
        ),
        riderLong: deserializeParam(
          data['RiderLong'],
          ParamType.String,
          false,
        ),
        updatedOn: deserializeParam(
          data['UpdatedOn'],
          ParamType.String,
          false,
        ),
        lastLocationUpdatedOn: deserializeParam(
          data['LastLocationUpdatedOn'],
          ParamType.String,
          false,
        ),
        isLocationEnable: deserializeParam(
          data['IsLocationEnable'],
          ParamType.bool,
          false,
        ),
        onDuty: deserializeParam(
          data['OnDuty'],
          ParamType.bool,
          false,
        ),
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
        onboardedBusinessId: deserializeParam(
          data['OnboardedBusinessId'],
          ParamType.int,
          false,
        ),
        newOTP: deserializeParam(
          data['newOTP'],
          ParamType.int,
          false,
        ),
        expireOTP: deserializeParam(
          data['expireOTP'],
          ParamType.String,
          false,
        ),
        oldOTP: deserializeParam(
          data['oldOTP'],
          ParamType.int,
          false,
        ),
        resetOTP: deserializeParam(
          data['resetOTP'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RiderVMStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RiderVMStruct &&
        riderId == other.riderId &&
        username == other.username &&
        passsword == other.passsword &&
        name == other.name &&
        phone == other.phone &&
        address == other.address &&
        listEquality.equals(businessid, other.businessid) &&
        adharcardimagepath == other.adharcardimagepath &&
        dlimagepath == other.dlimagepath &&
        isVerified == other.isVerified &&
        isActive == other.isActive &&
        adharcardnumber == other.adharcardnumber &&
        drivinglicensenumber == other.drivinglicensenumber &&
        riderLat == other.riderLat &&
        riderLong == other.riderLong &&
        updatedOn == other.updatedOn &&
        lastLocationUpdatedOn == other.lastLocationUpdatedOn &&
        isLocationEnable == other.isLocationEnable &&
        onDuty == other.onDuty &&
        token == other.token &&
        expireToken == other.expireToken &&
        onboardedBusinessId == other.onboardedBusinessId &&
        newOTP == other.newOTP &&
        expireOTP == other.expireOTP &&
        oldOTP == other.oldOTP &&
        resetOTP == other.resetOTP;
  }

  @override
  int get hashCode => const ListEquality().hash([
        riderId,
        username,
        passsword,
        name,
        phone,
        address,
        businessid,
        adharcardimagepath,
        dlimagepath,
        isVerified,
        isActive,
        adharcardnumber,
        drivinglicensenumber,
        riderLat,
        riderLong,
        updatedOn,
        lastLocationUpdatedOn,
        isLocationEnable,
        onDuty,
        token,
        expireToken,
        onboardedBusinessId,
        newOTP,
        expireOTP,
        oldOTP,
        resetOTP
      ]);
}

RiderVMStruct createRiderVMStruct({
  int? riderId,
  String? username,
  String? passsword,
  String? name,
  String? phone,
  String? address,
  String? adharcardimagepath,
  String? dlimagepath,
  bool? isVerified,
  bool? isActive,
  String? adharcardnumber,
  String? drivinglicensenumber,
  String? riderLat,
  String? riderLong,
  String? updatedOn,
  String? lastLocationUpdatedOn,
  bool? isLocationEnable,
  bool? onDuty,
  String? token,
  String? expireToken,
  int? onboardedBusinessId,
  int? newOTP,
  String? expireOTP,
  int? oldOTP,
  String? resetOTP,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    RiderVMStruct(
      riderId: riderId,
      username: username,
      passsword: passsword,
      name: name,
      phone: phone,
      address: address,
      adharcardimagepath: adharcardimagepath,
      dlimagepath: dlimagepath,
      isVerified: isVerified,
      isActive: isActive,
      adharcardnumber: adharcardnumber,
      drivinglicensenumber: drivinglicensenumber,
      riderLat: riderLat,
      riderLong: riderLong,
      updatedOn: updatedOn,
      lastLocationUpdatedOn: lastLocationUpdatedOn,
      isLocationEnable: isLocationEnable,
      onDuty: onDuty,
      token: token,
      expireToken: expireToken,
      onboardedBusinessId: onboardedBusinessId,
      newOTP: newOTP,
      expireOTP: expireOTP,
      oldOTP: oldOTP,
      resetOTP: resetOTP,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

RiderVMStruct? updateRiderVMStruct(
  RiderVMStruct? riderVM, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    riderVM
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addRiderVMStructData(
  Map<String, dynamic> firestoreData,
  RiderVMStruct? riderVM,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (riderVM == null) {
    return;
  }
  if (riderVM.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && riderVM.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final riderVMData = getRiderVMFirestoreData(riderVM, forFieldValue);
  final nestedData = riderVMData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = riderVM.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getRiderVMFirestoreData(
  RiderVMStruct? riderVM, [
  bool forFieldValue = false,
]) {
  if (riderVM == null) {
    return {};
  }
  final firestoreData = mapToFirestore(riderVM.toMap());

  // Add any Firestore field values
  mapToFirestore(riderVM.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getRiderVMListFirestoreData(
  List<RiderVMStruct>? riderVMs,
) =>
    riderVMs?.map((e) => getRiderVMFirestoreData(e, true)).toList() ?? [];
