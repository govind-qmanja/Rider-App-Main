// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class CompletedOrdersStruct extends FFFirebaseStruct {
  CompletedOrdersStruct({
    int? id,
    int? appVersion,
    String? creationDate,
    String? orderDate,
    String? deliveryType,
    String? deliveryTime,
    String? paymentType,
    double? subTotal,
    double? shippingFee,
    double? orderTotal,
    String? sessionId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? postalCode,
    String? notes,
    int? printerId,
    String? responceFromPrinter,
    String? cancelledBy,
    String? cancelledReason,
    bool? cancelled,
    String? acknowledged,
    bool? outForDelivery,
    double? voucherCodeDiscount,
    String? voucherCode,
    String? printed,
    double? discount,
    int? discountID,
    String? cardFee,
    double? serviceCharge,
    int? businessDetailID,
    int? customerID,
    String? status,
    String? clientIP,
    String? validForLoyality,
    String? orderText,
    String? discountPercentage,
    String? sagePayAuth,
    String? supportAcknowledged,
    String? allResolved,
    String? supportAcknowledgedAt,
    String? allResolvedAt,
    String? appType,
    String? supportAgentId,
    String? printerStatus,
    double? riderLongitude,
    double? riderLatitude,
    int? riderId,
    double? totalTax,
    String? orderotp,
    String? cancelledDate,
    String? acknowledgedDate,
    String? acceptedOn,
    String? riderAcceptedOn,
    String? orderDeliveredOn,
    String? riderLocationLastUpdated,
    String? orderCompletedOn,
    String? completed,
    String? readyInKitchenTime,
    bool? trackingDisable,
    String? tracking,
    String? payoutStatus,
    String? payoutId,
    String? payoutAmountToOutlet,
    String? qmanjaFee,
    String? invoiceId,
    String? riderstatredAt,
    String? markAsPaidAt,
    String? markAsPaidBy,
    String? ppresponseText,
    String? ppresponse,
    String? businessName,
    int? packageCharges,
    String? isOrderSentToThirdParty,
    String? isPreorder,
    String? preorderTime,
    String? businessDetail,
    String? riderDeclineHistory,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _id = id,
        _appVersion = appVersion,
        _creationDate = creationDate,
        _orderDate = orderDate,
        _deliveryType = deliveryType,
        _deliveryTime = deliveryTime,
        _paymentType = paymentType,
        _subTotal = subTotal,
        _shippingFee = shippingFee,
        _orderTotal = orderTotal,
        _sessionId = sessionId,
        _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _phone = phone,
        _address = address,
        _postalCode = postalCode,
        _notes = notes,
        _printerId = printerId,
        _responceFromPrinter = responceFromPrinter,
        _cancelledBy = cancelledBy,
        _cancelledReason = cancelledReason,
        _cancelled = cancelled,
        _acknowledged = acknowledged,
        _outForDelivery = outForDelivery,
        _voucherCodeDiscount = voucherCodeDiscount,
        _voucherCode = voucherCode,
        _printed = printed,
        _discount = discount,
        _discountID = discountID,
        _cardFee = cardFee,
        _serviceCharge = serviceCharge,
        _businessDetailID = businessDetailID,
        _customerID = customerID,
        _status = status,
        _clientIP = clientIP,
        _validForLoyality = validForLoyality,
        _orderText = orderText,
        _discountPercentage = discountPercentage,
        _sagePayAuth = sagePayAuth,
        _supportAcknowledged = supportAcknowledged,
        _allResolved = allResolved,
        _supportAcknowledgedAt = supportAcknowledgedAt,
        _allResolvedAt = allResolvedAt,
        _appType = appType,
        _supportAgentId = supportAgentId,
        _printerStatus = printerStatus,
        _riderLongitude = riderLongitude,
        _riderLatitude = riderLatitude,
        _riderId = riderId,
        _totalTax = totalTax,
        _orderotp = orderotp,
        _cancelledDate = cancelledDate,
        _acknowledgedDate = acknowledgedDate,
        _acceptedOn = acceptedOn,
        _riderAcceptedOn = riderAcceptedOn,
        _orderDeliveredOn = orderDeliveredOn,
        _riderLocationLastUpdated = riderLocationLastUpdated,
        _orderCompletedOn = orderCompletedOn,
        _completed = completed,
        _readyInKitchenTime = readyInKitchenTime,
        _trackingDisable = trackingDisable,
        _tracking = tracking,
        _payoutStatus = payoutStatus,
        _payoutId = payoutId,
        _payoutAmountToOutlet = payoutAmountToOutlet,
        _qmanjaFee = qmanjaFee,
        _invoiceId = invoiceId,
        _riderstatredAt = riderstatredAt,
        _markAsPaidAt = markAsPaidAt,
        _markAsPaidBy = markAsPaidBy,
        _ppresponseText = ppresponseText,
        _ppresponse = ppresponse,
        _businessName = businessName,
        _packageCharges = packageCharges,
        _isOrderSentToThirdParty = isOrderSentToThirdParty,
        _isPreorder = isPreorder,
        _preorderTime = preorderTime,
        _businessDetail = businessDetail,
        _riderDeclineHistory = riderDeclineHistory,
        super(firestoreUtilData);

  // "ID" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "AppVersion" field.
  int? _appVersion;
  int get appVersion => _appVersion ?? 0;
  set appVersion(int? val) => _appVersion = val;

  void incrementAppVersion(int amount) => appVersion = appVersion + amount;

  bool hasAppVersion() => _appVersion != null;

  // "CreationDate" field.
  String? _creationDate;
  String get creationDate => _creationDate ?? '';
  set creationDate(String? val) => _creationDate = val;

  bool hasCreationDate() => _creationDate != null;

  // "OrderDate" field.
  String? _orderDate;
  String get orderDate => _orderDate ?? '';
  set orderDate(String? val) => _orderDate = val;

  bool hasOrderDate() => _orderDate != null;

  // "DeliveryType" field.
  String? _deliveryType;
  String get deliveryType => _deliveryType ?? '';
  set deliveryType(String? val) => _deliveryType = val;

  bool hasDeliveryType() => _deliveryType != null;

  // "DeliveryTime" field.
  String? _deliveryTime;
  String get deliveryTime => _deliveryTime ?? '';
  set deliveryTime(String? val) => _deliveryTime = val;

  bool hasDeliveryTime() => _deliveryTime != null;

  // "PaymentType" field.
  String? _paymentType;
  String get paymentType => _paymentType ?? '';
  set paymentType(String? val) => _paymentType = val;

  bool hasPaymentType() => _paymentType != null;

  // "SubTotal" field.
  double? _subTotal;
  double get subTotal => _subTotal ?? 0.0;
  set subTotal(double? val) => _subTotal = val;

  void incrementSubTotal(double amount) => subTotal = subTotal + amount;

  bool hasSubTotal() => _subTotal != null;

  // "ShippingFee" field.
  double? _shippingFee;
  double get shippingFee => _shippingFee ?? 0.0;
  set shippingFee(double? val) => _shippingFee = val;

  void incrementShippingFee(double amount) =>
      shippingFee = shippingFee + amount;

  bool hasShippingFee() => _shippingFee != null;

  // "OrderTotal" field.
  double? _orderTotal;
  double get orderTotal => _orderTotal ?? 0.0;
  set orderTotal(double? val) => _orderTotal = val;

  void incrementOrderTotal(double amount) => orderTotal = orderTotal + amount;

  bool hasOrderTotal() => _orderTotal != null;

  // "SessionId" field.
  String? _sessionId;
  String get sessionId => _sessionId ?? '';
  set sessionId(String? val) => _sessionId = val;

  bool hasSessionId() => _sessionId != null;

  // "FirstName" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  // "LastName" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "Email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

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

  // "PostalCode" field.
  String? _postalCode;
  String get postalCode => _postalCode ?? '';
  set postalCode(String? val) => _postalCode = val;

  bool hasPostalCode() => _postalCode != null;

  // "Notes" field.
  String? _notes;
  String get notes => _notes ?? '';
  set notes(String? val) => _notes = val;

  bool hasNotes() => _notes != null;

  // "PrinterId" field.
  int? _printerId;
  int get printerId => _printerId ?? 0;
  set printerId(int? val) => _printerId = val;

  void incrementPrinterId(int amount) => printerId = printerId + amount;

  bool hasPrinterId() => _printerId != null;

  // "ResponceFromPrinter" field.
  String? _responceFromPrinter;
  String get responceFromPrinter => _responceFromPrinter ?? '';
  set responceFromPrinter(String? val) => _responceFromPrinter = val;

  bool hasResponceFromPrinter() => _responceFromPrinter != null;

  // "CancelledBy" field.
  String? _cancelledBy;
  String get cancelledBy => _cancelledBy ?? '';
  set cancelledBy(String? val) => _cancelledBy = val;

  bool hasCancelledBy() => _cancelledBy != null;

  // "CancelledReason" field.
  String? _cancelledReason;
  String get cancelledReason => _cancelledReason ?? '';
  set cancelledReason(String? val) => _cancelledReason = val;

  bool hasCancelledReason() => _cancelledReason != null;

  // "Cancelled" field.
  bool? _cancelled;
  bool get cancelled => _cancelled ?? false;
  set cancelled(bool? val) => _cancelled = val;

  bool hasCancelled() => _cancelled != null;

  // "Acknowledged" field.
  String? _acknowledged;
  String get acknowledged => _acknowledged ?? '';
  set acknowledged(String? val) => _acknowledged = val;

  bool hasAcknowledged() => _acknowledged != null;

  // "OutForDelivery" field.
  bool? _outForDelivery;
  bool get outForDelivery => _outForDelivery ?? false;
  set outForDelivery(bool? val) => _outForDelivery = val;

  bool hasOutForDelivery() => _outForDelivery != null;

  // "VoucherCodeDiscount" field.
  double? _voucherCodeDiscount;
  double get voucherCodeDiscount => _voucherCodeDiscount ?? 0.0;
  set voucherCodeDiscount(double? val) => _voucherCodeDiscount = val;

  void incrementVoucherCodeDiscount(double amount) =>
      voucherCodeDiscount = voucherCodeDiscount + amount;

  bool hasVoucherCodeDiscount() => _voucherCodeDiscount != null;

  // "VoucherCode" field.
  String? _voucherCode;
  String get voucherCode => _voucherCode ?? '';
  set voucherCode(String? val) => _voucherCode = val;

  bool hasVoucherCode() => _voucherCode != null;

  // "Printed" field.
  String? _printed;
  String get printed => _printed ?? '';
  set printed(String? val) => _printed = val;

  bool hasPrinted() => _printed != null;

  // "Discount" field.
  double? _discount;
  double get discount => _discount ?? 0.0;
  set discount(double? val) => _discount = val;

  void incrementDiscount(double amount) => discount = discount + amount;

  bool hasDiscount() => _discount != null;

  // "DiscountID" field.
  int? _discountID;
  int get discountID => _discountID ?? 0;
  set discountID(int? val) => _discountID = val;

  void incrementDiscountID(int amount) => discountID = discountID + amount;

  bool hasDiscountID() => _discountID != null;

  // "CardFee" field.
  String? _cardFee;
  String get cardFee => _cardFee ?? '';
  set cardFee(String? val) => _cardFee = val;

  bool hasCardFee() => _cardFee != null;

  // "ServiceCharge" field.
  double? _serviceCharge;
  double get serviceCharge => _serviceCharge ?? 0.0;
  set serviceCharge(double? val) => _serviceCharge = val;

  void incrementServiceCharge(double amount) =>
      serviceCharge = serviceCharge + amount;

  bool hasServiceCharge() => _serviceCharge != null;

  // "BusinessDetailID" field.
  int? _businessDetailID;
  int get businessDetailID => _businessDetailID ?? 0;
  set businessDetailID(int? val) => _businessDetailID = val;

  void incrementBusinessDetailID(int amount) =>
      businessDetailID = businessDetailID + amount;

  bool hasBusinessDetailID() => _businessDetailID != null;

  // "CustomerID" field.
  int? _customerID;
  int get customerID => _customerID ?? 0;
  set customerID(int? val) => _customerID = val;

  void incrementCustomerID(int amount) => customerID = customerID + amount;

  bool hasCustomerID() => _customerID != null;

  // "Status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "ClientIP" field.
  String? _clientIP;
  String get clientIP => _clientIP ?? '';
  set clientIP(String? val) => _clientIP = val;

  bool hasClientIP() => _clientIP != null;

  // "ValidForLoyality" field.
  String? _validForLoyality;
  String get validForLoyality => _validForLoyality ?? '';
  set validForLoyality(String? val) => _validForLoyality = val;

  bool hasValidForLoyality() => _validForLoyality != null;

  // "OrderText" field.
  String? _orderText;
  String get orderText => _orderText ?? '';
  set orderText(String? val) => _orderText = val;

  bool hasOrderText() => _orderText != null;

  // "DiscountPercentage" field.
  String? _discountPercentage;
  String get discountPercentage => _discountPercentage ?? '';
  set discountPercentage(String? val) => _discountPercentage = val;

  bool hasDiscountPercentage() => _discountPercentage != null;

  // "SagePayAuth" field.
  String? _sagePayAuth;
  String get sagePayAuth => _sagePayAuth ?? '';
  set sagePayAuth(String? val) => _sagePayAuth = val;

  bool hasSagePayAuth() => _sagePayAuth != null;

  // "SupportAcknowledged" field.
  String? _supportAcknowledged;
  String get supportAcknowledged => _supportAcknowledged ?? '';
  set supportAcknowledged(String? val) => _supportAcknowledged = val;

  bool hasSupportAcknowledged() => _supportAcknowledged != null;

  // "AllResolved" field.
  String? _allResolved;
  String get allResolved => _allResolved ?? '';
  set allResolved(String? val) => _allResolved = val;

  bool hasAllResolved() => _allResolved != null;

  // "SupportAcknowledgedAt" field.
  String? _supportAcknowledgedAt;
  String get supportAcknowledgedAt => _supportAcknowledgedAt ?? '';
  set supportAcknowledgedAt(String? val) => _supportAcknowledgedAt = val;

  bool hasSupportAcknowledgedAt() => _supportAcknowledgedAt != null;

  // "AllResolvedAt" field.
  String? _allResolvedAt;
  String get allResolvedAt => _allResolvedAt ?? '';
  set allResolvedAt(String? val) => _allResolvedAt = val;

  bool hasAllResolvedAt() => _allResolvedAt != null;

  // "AppType" field.
  String? _appType;
  String get appType => _appType ?? '';
  set appType(String? val) => _appType = val;

  bool hasAppType() => _appType != null;

  // "SupportAgentId" field.
  String? _supportAgentId;
  String get supportAgentId => _supportAgentId ?? '';
  set supportAgentId(String? val) => _supportAgentId = val;

  bool hasSupportAgentId() => _supportAgentId != null;

  // "PrinterStatus" field.
  String? _printerStatus;
  String get printerStatus => _printerStatus ?? '';
  set printerStatus(String? val) => _printerStatus = val;

  bool hasPrinterStatus() => _printerStatus != null;

  // "RiderLongitude" field.
  double? _riderLongitude;
  double get riderLongitude => _riderLongitude ?? 0.0;
  set riderLongitude(double? val) => _riderLongitude = val;

  void incrementRiderLongitude(double amount) =>
      riderLongitude = riderLongitude + amount;

  bool hasRiderLongitude() => _riderLongitude != null;

  // "RiderLatitude" field.
  double? _riderLatitude;
  double get riderLatitude => _riderLatitude ?? 0.0;
  set riderLatitude(double? val) => _riderLatitude = val;

  void incrementRiderLatitude(double amount) =>
      riderLatitude = riderLatitude + amount;

  bool hasRiderLatitude() => _riderLatitude != null;

  // "RiderId" field.
  int? _riderId;
  int get riderId => _riderId ?? 0;
  set riderId(int? val) => _riderId = val;

  void incrementRiderId(int amount) => riderId = riderId + amount;

  bool hasRiderId() => _riderId != null;

  // "TotalTax" field.
  double? _totalTax;
  double get totalTax => _totalTax ?? 0.0;
  set totalTax(double? val) => _totalTax = val;

  void incrementTotalTax(double amount) => totalTax = totalTax + amount;

  bool hasTotalTax() => _totalTax != null;

  // "Orderotp" field.
  String? _orderotp;
  String get orderotp => _orderotp ?? '';
  set orderotp(String? val) => _orderotp = val;

  bool hasOrderotp() => _orderotp != null;

  // "CancelledDate" field.
  String? _cancelledDate;
  String get cancelledDate => _cancelledDate ?? '';
  set cancelledDate(String? val) => _cancelledDate = val;

  bool hasCancelledDate() => _cancelledDate != null;

  // "AcknowledgedDate" field.
  String? _acknowledgedDate;
  String get acknowledgedDate => _acknowledgedDate ?? '';
  set acknowledgedDate(String? val) => _acknowledgedDate = val;

  bool hasAcknowledgedDate() => _acknowledgedDate != null;

  // "AcceptedOn" field.
  String? _acceptedOn;
  String get acceptedOn => _acceptedOn ?? '';
  set acceptedOn(String? val) => _acceptedOn = val;

  bool hasAcceptedOn() => _acceptedOn != null;

  // "RiderAcceptedOn" field.
  String? _riderAcceptedOn;
  String get riderAcceptedOn => _riderAcceptedOn ?? '';
  set riderAcceptedOn(String? val) => _riderAcceptedOn = val;

  bool hasRiderAcceptedOn() => _riderAcceptedOn != null;

  // "OrderDeliveredOn" field.
  String? _orderDeliveredOn;
  String get orderDeliveredOn => _orderDeliveredOn ?? '';
  set orderDeliveredOn(String? val) => _orderDeliveredOn = val;

  bool hasOrderDeliveredOn() => _orderDeliveredOn != null;

  // "RiderLocationLastUpdated" field.
  String? _riderLocationLastUpdated;
  String get riderLocationLastUpdated => _riderLocationLastUpdated ?? '';
  set riderLocationLastUpdated(String? val) => _riderLocationLastUpdated = val;

  bool hasRiderLocationLastUpdated() => _riderLocationLastUpdated != null;

  // "OrderCompletedOn" field.
  String? _orderCompletedOn;
  String get orderCompletedOn => _orderCompletedOn ?? '';
  set orderCompletedOn(String? val) => _orderCompletedOn = val;

  bool hasOrderCompletedOn() => _orderCompletedOn != null;

  // "Completed" field.
  String? _completed;
  String get completed => _completed ?? '';
  set completed(String? val) => _completed = val;

  bool hasCompleted() => _completed != null;

  // "ReadyInKitchenTime" field.
  String? _readyInKitchenTime;
  String get readyInKitchenTime => _readyInKitchenTime ?? '';
  set readyInKitchenTime(String? val) => _readyInKitchenTime = val;

  bool hasReadyInKitchenTime() => _readyInKitchenTime != null;

  // "TrackingDisable" field.
  bool? _trackingDisable;
  bool get trackingDisable => _trackingDisable ?? false;
  set trackingDisable(bool? val) => _trackingDisable = val;

  bool hasTrackingDisable() => _trackingDisable != null;

  // "Tracking" field.
  String? _tracking;
  String get tracking => _tracking ?? '';
  set tracking(String? val) => _tracking = val;

  bool hasTracking() => _tracking != null;

  // "PayoutStatus" field.
  String? _payoutStatus;
  String get payoutStatus => _payoutStatus ?? '';
  set payoutStatus(String? val) => _payoutStatus = val;

  bool hasPayoutStatus() => _payoutStatus != null;

  // "PayoutId" field.
  String? _payoutId;
  String get payoutId => _payoutId ?? '';
  set payoutId(String? val) => _payoutId = val;

  bool hasPayoutId() => _payoutId != null;

  // "PayoutAmountToOutlet" field.
  String? _payoutAmountToOutlet;
  String get payoutAmountToOutlet => _payoutAmountToOutlet ?? '';
  set payoutAmountToOutlet(String? val) => _payoutAmountToOutlet = val;

  bool hasPayoutAmountToOutlet() => _payoutAmountToOutlet != null;

  // "QmanjaFee" field.
  String? _qmanjaFee;
  String get qmanjaFee => _qmanjaFee ?? '';
  set qmanjaFee(String? val) => _qmanjaFee = val;

  bool hasQmanjaFee() => _qmanjaFee != null;

  // "InvoiceId" field.
  String? _invoiceId;
  String get invoiceId => _invoiceId ?? '';
  set invoiceId(String? val) => _invoiceId = val;

  bool hasInvoiceId() => _invoiceId != null;

  // "RiderstatredAt" field.
  String? _riderstatredAt;
  String get riderstatredAt => _riderstatredAt ?? '';
  set riderstatredAt(String? val) => _riderstatredAt = val;

  bool hasRiderstatredAt() => _riderstatredAt != null;

  // "MarkAsPaidAt" field.
  String? _markAsPaidAt;
  String get markAsPaidAt => _markAsPaidAt ?? '';
  set markAsPaidAt(String? val) => _markAsPaidAt = val;

  bool hasMarkAsPaidAt() => _markAsPaidAt != null;

  // "MarkAsPaidBy" field.
  String? _markAsPaidBy;
  String get markAsPaidBy => _markAsPaidBy ?? '';
  set markAsPaidBy(String? val) => _markAsPaidBy = val;

  bool hasMarkAsPaidBy() => _markAsPaidBy != null;

  // "PpresponseText" field.
  String? _ppresponseText;
  String get ppresponseText => _ppresponseText ?? '';
  set ppresponseText(String? val) => _ppresponseText = val;

  bool hasPpresponseText() => _ppresponseText != null;

  // "Ppresponse" field.
  String? _ppresponse;
  String get ppresponse => _ppresponse ?? '';
  set ppresponse(String? val) => _ppresponse = val;

  bool hasPpresponse() => _ppresponse != null;

  // "BusinessName" field.
  String? _businessName;
  String get businessName => _businessName ?? '';
  set businessName(String? val) => _businessName = val;

  bool hasBusinessName() => _businessName != null;

  // "PackageCharges" field.
  int? _packageCharges;
  int get packageCharges => _packageCharges ?? 0;
  set packageCharges(int? val) => _packageCharges = val;

  void incrementPackageCharges(int amount) =>
      packageCharges = packageCharges + amount;

  bool hasPackageCharges() => _packageCharges != null;

  // "IsOrderSentToThirdParty" field.
  String? _isOrderSentToThirdParty;
  String get isOrderSentToThirdParty => _isOrderSentToThirdParty ?? '';
  set isOrderSentToThirdParty(String? val) => _isOrderSentToThirdParty = val;

  bool hasIsOrderSentToThirdParty() => _isOrderSentToThirdParty != null;

  // "IsPreorder" field.
  String? _isPreorder;
  String get isPreorder => _isPreorder ?? '';
  set isPreorder(String? val) => _isPreorder = val;

  bool hasIsPreorder() => _isPreorder != null;

  // "PreorderTime" field.
  String? _preorderTime;
  String get preorderTime => _preorderTime ?? '';
  set preorderTime(String? val) => _preorderTime = val;

  bool hasPreorderTime() => _preorderTime != null;

  // "businessDetail" field.
  String? _businessDetail;
  String get businessDetail => _businessDetail ?? '';
  set businessDetail(String? val) => _businessDetail = val;

  bool hasBusinessDetail() => _businessDetail != null;

  // "RiderDeclineHistory" field.
  String? _riderDeclineHistory;
  String get riderDeclineHistory => _riderDeclineHistory ?? '';
  set riderDeclineHistory(String? val) => _riderDeclineHistory = val;

  bool hasRiderDeclineHistory() => _riderDeclineHistory != null;

  static CompletedOrdersStruct fromMap(Map<String, dynamic> data) =>
      CompletedOrdersStruct(
        id: castToType<int>(data['ID']),
        appVersion: castToType<int>(data['AppVersion']),
        creationDate: data['CreationDate'] as String?,
        orderDate: data['OrderDate'] as String?,
        deliveryType: data['DeliveryType'] as String?,
        deliveryTime: data['DeliveryTime'] as String?,
        paymentType: data['PaymentType'] as String?,
        subTotal: castToType<double>(data['SubTotal']),
        shippingFee: castToType<double>(data['ShippingFee']),
        orderTotal: castToType<double>(data['OrderTotal']),
        sessionId: data['SessionId'] as String?,
        firstName: data['FirstName'] as String?,
        lastName: data['LastName'] as String?,
        email: data['Email'] as String?,
        phone: data['Phone'] as String?,
        address: data['Address'] as String?,
        postalCode: data['PostalCode'] as String?,
        notes: data['Notes'] as String?,
        printerId: castToType<int>(data['PrinterId']),
        responceFromPrinter: data['ResponceFromPrinter'] as String?,
        cancelledBy: data['CancelledBy'] as String?,
        cancelledReason: data['CancelledReason'] as String?,
        cancelled: data['Cancelled'] as bool?,
        acknowledged: data['Acknowledged'] as String?,
        outForDelivery: data['OutForDelivery'] as bool?,
        voucherCodeDiscount: castToType<double>(data['VoucherCodeDiscount']),
        voucherCode: data['VoucherCode'] as String?,
        printed: data['Printed'] as String?,
        discount: castToType<double>(data['Discount']),
        discountID: castToType<int>(data['DiscountID']),
        cardFee: data['CardFee'] as String?,
        serviceCharge: castToType<double>(data['ServiceCharge']),
        businessDetailID: castToType<int>(data['BusinessDetailID']),
        customerID: castToType<int>(data['CustomerID']),
        status: data['Status'] as String?,
        clientIP: data['ClientIP'] as String?,
        validForLoyality: data['ValidForLoyality'] as String?,
        orderText: data['OrderText'] as String?,
        discountPercentage: data['DiscountPercentage'] as String?,
        sagePayAuth: data['SagePayAuth'] as String?,
        supportAcknowledged: data['SupportAcknowledged'] as String?,
        allResolved: data['AllResolved'] as String?,
        supportAcknowledgedAt: data['SupportAcknowledgedAt'] as String?,
        allResolvedAt: data['AllResolvedAt'] as String?,
        appType: data['AppType'] as String?,
        supportAgentId: data['SupportAgentId'] as String?,
        printerStatus: data['PrinterStatus'] as String?,
        riderLongitude: castToType<double>(data['RiderLongitude']),
        riderLatitude: castToType<double>(data['RiderLatitude']),
        riderId: castToType<int>(data['RiderId']),
        totalTax: castToType<double>(data['TotalTax']),
        orderotp: data['Orderotp'] as String?,
        cancelledDate: data['CancelledDate'] as String?,
        acknowledgedDate: data['AcknowledgedDate'] as String?,
        acceptedOn: data['AcceptedOn'] as String?,
        riderAcceptedOn: data['RiderAcceptedOn'] as String?,
        orderDeliveredOn: data['OrderDeliveredOn'] as String?,
        riderLocationLastUpdated: data['RiderLocationLastUpdated'] as String?,
        orderCompletedOn: data['OrderCompletedOn'] as String?,
        completed: data['Completed'] as String?,
        readyInKitchenTime: data['ReadyInKitchenTime'] as String?,
        trackingDisable: data['TrackingDisable'] as bool?,
        tracking: data['Tracking'] as String?,
        payoutStatus: data['PayoutStatus'] as String?,
        payoutId: data['PayoutId'] as String?,
        payoutAmountToOutlet: data['PayoutAmountToOutlet'] as String?,
        qmanjaFee: data['QmanjaFee'] as String?,
        invoiceId: data['InvoiceId'] as String?,
        riderstatredAt: data['RiderstatredAt'] as String?,
        markAsPaidAt: data['MarkAsPaidAt'] as String?,
        markAsPaidBy: data['MarkAsPaidBy'] as String?,
        ppresponseText: data['PpresponseText'] as String?,
        ppresponse: data['Ppresponse'] as String?,
        businessName: data['BusinessName'] as String?,
        packageCharges: castToType<int>(data['PackageCharges']),
        isOrderSentToThirdParty: data['IsOrderSentToThirdParty'] as String?,
        isPreorder: data['IsPreorder'] as String?,
        preorderTime: data['PreorderTime'] as String?,
        businessDetail: data['businessDetail'] as String?,
        riderDeclineHistory: data['RiderDeclineHistory'] as String?,
      );

  static CompletedOrdersStruct? maybeFromMap(dynamic data) => data is Map
      ? CompletedOrdersStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'ID': _id,
        'AppVersion': _appVersion,
        'CreationDate': _creationDate,
        'OrderDate': _orderDate,
        'DeliveryType': _deliveryType,
        'DeliveryTime': _deliveryTime,
        'PaymentType': _paymentType,
        'SubTotal': _subTotal,
        'ShippingFee': _shippingFee,
        'OrderTotal': _orderTotal,
        'SessionId': _sessionId,
        'FirstName': _firstName,
        'LastName': _lastName,
        'Email': _email,
        'Phone': _phone,
        'Address': _address,
        'PostalCode': _postalCode,
        'Notes': _notes,
        'PrinterId': _printerId,
        'ResponceFromPrinter': _responceFromPrinter,
        'CancelledBy': _cancelledBy,
        'CancelledReason': _cancelledReason,
        'Cancelled': _cancelled,
        'Acknowledged': _acknowledged,
        'OutForDelivery': _outForDelivery,
        'VoucherCodeDiscount': _voucherCodeDiscount,
        'VoucherCode': _voucherCode,
        'Printed': _printed,
        'Discount': _discount,
        'DiscountID': _discountID,
        'CardFee': _cardFee,
        'ServiceCharge': _serviceCharge,
        'BusinessDetailID': _businessDetailID,
        'CustomerID': _customerID,
        'Status': _status,
        'ClientIP': _clientIP,
        'ValidForLoyality': _validForLoyality,
        'OrderText': _orderText,
        'DiscountPercentage': _discountPercentage,
        'SagePayAuth': _sagePayAuth,
        'SupportAcknowledged': _supportAcknowledged,
        'AllResolved': _allResolved,
        'SupportAcknowledgedAt': _supportAcknowledgedAt,
        'AllResolvedAt': _allResolvedAt,
        'AppType': _appType,
        'SupportAgentId': _supportAgentId,
        'PrinterStatus': _printerStatus,
        'RiderLongitude': _riderLongitude,
        'RiderLatitude': _riderLatitude,
        'RiderId': _riderId,
        'TotalTax': _totalTax,
        'Orderotp': _orderotp,
        'CancelledDate': _cancelledDate,
        'AcknowledgedDate': _acknowledgedDate,
        'AcceptedOn': _acceptedOn,
        'RiderAcceptedOn': _riderAcceptedOn,
        'OrderDeliveredOn': _orderDeliveredOn,
        'RiderLocationLastUpdated': _riderLocationLastUpdated,
        'OrderCompletedOn': _orderCompletedOn,
        'Completed': _completed,
        'ReadyInKitchenTime': _readyInKitchenTime,
        'TrackingDisable': _trackingDisable,
        'Tracking': _tracking,
        'PayoutStatus': _payoutStatus,
        'PayoutId': _payoutId,
        'PayoutAmountToOutlet': _payoutAmountToOutlet,
        'QmanjaFee': _qmanjaFee,
        'InvoiceId': _invoiceId,
        'RiderstatredAt': _riderstatredAt,
        'MarkAsPaidAt': _markAsPaidAt,
        'MarkAsPaidBy': _markAsPaidBy,
        'PpresponseText': _ppresponseText,
        'Ppresponse': _ppresponse,
        'BusinessName': _businessName,
        'PackageCharges': _packageCharges,
        'IsOrderSentToThirdParty': _isOrderSentToThirdParty,
        'IsPreorder': _isPreorder,
        'PreorderTime': _preorderTime,
        'businessDetail': _businessDetail,
        'RiderDeclineHistory': _riderDeclineHistory,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'ID': serializeParam(
          _id,
          ParamType.int,
        ),
        'AppVersion': serializeParam(
          _appVersion,
          ParamType.int,
        ),
        'CreationDate': serializeParam(
          _creationDate,
          ParamType.String,
        ),
        'OrderDate': serializeParam(
          _orderDate,
          ParamType.String,
        ),
        'DeliveryType': serializeParam(
          _deliveryType,
          ParamType.String,
        ),
        'DeliveryTime': serializeParam(
          _deliveryTime,
          ParamType.String,
        ),
        'PaymentType': serializeParam(
          _paymentType,
          ParamType.String,
        ),
        'SubTotal': serializeParam(
          _subTotal,
          ParamType.double,
        ),
        'ShippingFee': serializeParam(
          _shippingFee,
          ParamType.double,
        ),
        'OrderTotal': serializeParam(
          _orderTotal,
          ParamType.double,
        ),
        'SessionId': serializeParam(
          _sessionId,
          ParamType.String,
        ),
        'FirstName': serializeParam(
          _firstName,
          ParamType.String,
        ),
        'LastName': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'Email': serializeParam(
          _email,
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
        'PostalCode': serializeParam(
          _postalCode,
          ParamType.String,
        ),
        'Notes': serializeParam(
          _notes,
          ParamType.String,
        ),
        'PrinterId': serializeParam(
          _printerId,
          ParamType.int,
        ),
        'ResponceFromPrinter': serializeParam(
          _responceFromPrinter,
          ParamType.String,
        ),
        'CancelledBy': serializeParam(
          _cancelledBy,
          ParamType.String,
        ),
        'CancelledReason': serializeParam(
          _cancelledReason,
          ParamType.String,
        ),
        'Cancelled': serializeParam(
          _cancelled,
          ParamType.bool,
        ),
        'Acknowledged': serializeParam(
          _acknowledged,
          ParamType.String,
        ),
        'OutForDelivery': serializeParam(
          _outForDelivery,
          ParamType.bool,
        ),
        'VoucherCodeDiscount': serializeParam(
          _voucherCodeDiscount,
          ParamType.double,
        ),
        'VoucherCode': serializeParam(
          _voucherCode,
          ParamType.String,
        ),
        'Printed': serializeParam(
          _printed,
          ParamType.String,
        ),
        'Discount': serializeParam(
          _discount,
          ParamType.double,
        ),
        'DiscountID': serializeParam(
          _discountID,
          ParamType.int,
        ),
        'CardFee': serializeParam(
          _cardFee,
          ParamType.String,
        ),
        'ServiceCharge': serializeParam(
          _serviceCharge,
          ParamType.double,
        ),
        'BusinessDetailID': serializeParam(
          _businessDetailID,
          ParamType.int,
        ),
        'CustomerID': serializeParam(
          _customerID,
          ParamType.int,
        ),
        'Status': serializeParam(
          _status,
          ParamType.String,
        ),
        'ClientIP': serializeParam(
          _clientIP,
          ParamType.String,
        ),
        'ValidForLoyality': serializeParam(
          _validForLoyality,
          ParamType.String,
        ),
        'OrderText': serializeParam(
          _orderText,
          ParamType.String,
        ),
        'DiscountPercentage': serializeParam(
          _discountPercentage,
          ParamType.String,
        ),
        'SagePayAuth': serializeParam(
          _sagePayAuth,
          ParamType.String,
        ),
        'SupportAcknowledged': serializeParam(
          _supportAcknowledged,
          ParamType.String,
        ),
        'AllResolved': serializeParam(
          _allResolved,
          ParamType.String,
        ),
        'SupportAcknowledgedAt': serializeParam(
          _supportAcknowledgedAt,
          ParamType.String,
        ),
        'AllResolvedAt': serializeParam(
          _allResolvedAt,
          ParamType.String,
        ),
        'AppType': serializeParam(
          _appType,
          ParamType.String,
        ),
        'SupportAgentId': serializeParam(
          _supportAgentId,
          ParamType.String,
        ),
        'PrinterStatus': serializeParam(
          _printerStatus,
          ParamType.String,
        ),
        'RiderLongitude': serializeParam(
          _riderLongitude,
          ParamType.double,
        ),
        'RiderLatitude': serializeParam(
          _riderLatitude,
          ParamType.double,
        ),
        'RiderId': serializeParam(
          _riderId,
          ParamType.int,
        ),
        'TotalTax': serializeParam(
          _totalTax,
          ParamType.double,
        ),
        'Orderotp': serializeParam(
          _orderotp,
          ParamType.String,
        ),
        'CancelledDate': serializeParam(
          _cancelledDate,
          ParamType.String,
        ),
        'AcknowledgedDate': serializeParam(
          _acknowledgedDate,
          ParamType.String,
        ),
        'AcceptedOn': serializeParam(
          _acceptedOn,
          ParamType.String,
        ),
        'RiderAcceptedOn': serializeParam(
          _riderAcceptedOn,
          ParamType.String,
        ),
        'OrderDeliveredOn': serializeParam(
          _orderDeliveredOn,
          ParamType.String,
        ),
        'RiderLocationLastUpdated': serializeParam(
          _riderLocationLastUpdated,
          ParamType.String,
        ),
        'OrderCompletedOn': serializeParam(
          _orderCompletedOn,
          ParamType.String,
        ),
        'Completed': serializeParam(
          _completed,
          ParamType.String,
        ),
        'ReadyInKitchenTime': serializeParam(
          _readyInKitchenTime,
          ParamType.String,
        ),
        'TrackingDisable': serializeParam(
          _trackingDisable,
          ParamType.bool,
        ),
        'Tracking': serializeParam(
          _tracking,
          ParamType.String,
        ),
        'PayoutStatus': serializeParam(
          _payoutStatus,
          ParamType.String,
        ),
        'PayoutId': serializeParam(
          _payoutId,
          ParamType.String,
        ),
        'PayoutAmountToOutlet': serializeParam(
          _payoutAmountToOutlet,
          ParamType.String,
        ),
        'QmanjaFee': serializeParam(
          _qmanjaFee,
          ParamType.String,
        ),
        'InvoiceId': serializeParam(
          _invoiceId,
          ParamType.String,
        ),
        'RiderstatredAt': serializeParam(
          _riderstatredAt,
          ParamType.String,
        ),
        'MarkAsPaidAt': serializeParam(
          _markAsPaidAt,
          ParamType.String,
        ),
        'MarkAsPaidBy': serializeParam(
          _markAsPaidBy,
          ParamType.String,
        ),
        'PpresponseText': serializeParam(
          _ppresponseText,
          ParamType.String,
        ),
        'Ppresponse': serializeParam(
          _ppresponse,
          ParamType.String,
        ),
        'BusinessName': serializeParam(
          _businessName,
          ParamType.String,
        ),
        'PackageCharges': serializeParam(
          _packageCharges,
          ParamType.int,
        ),
        'IsOrderSentToThirdParty': serializeParam(
          _isOrderSentToThirdParty,
          ParamType.String,
        ),
        'IsPreorder': serializeParam(
          _isPreorder,
          ParamType.String,
        ),
        'PreorderTime': serializeParam(
          _preorderTime,
          ParamType.String,
        ),
        'businessDetail': serializeParam(
          _businessDetail,
          ParamType.String,
        ),
        'RiderDeclineHistory': serializeParam(
          _riderDeclineHistory,
          ParamType.String,
        ),
      }.withoutNulls;

  static CompletedOrdersStruct fromSerializableMap(Map<String, dynamic> data) =>
      CompletedOrdersStruct(
        id: deserializeParam(
          data['ID'],
          ParamType.int,
          false,
        ),
        appVersion: deserializeParam(
          data['AppVersion'],
          ParamType.int,
          false,
        ),
        creationDate: deserializeParam(
          data['CreationDate'],
          ParamType.String,
          false,
        ),
        orderDate: deserializeParam(
          data['OrderDate'],
          ParamType.String,
          false,
        ),
        deliveryType: deserializeParam(
          data['DeliveryType'],
          ParamType.String,
          false,
        ),
        deliveryTime: deserializeParam(
          data['DeliveryTime'],
          ParamType.String,
          false,
        ),
        paymentType: deserializeParam(
          data['PaymentType'],
          ParamType.String,
          false,
        ),
        subTotal: deserializeParam(
          data['SubTotal'],
          ParamType.double,
          false,
        ),
        shippingFee: deserializeParam(
          data['ShippingFee'],
          ParamType.double,
          false,
        ),
        orderTotal: deserializeParam(
          data['OrderTotal'],
          ParamType.double,
          false,
        ),
        sessionId: deserializeParam(
          data['SessionId'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['FirstName'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['LastName'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['Email'],
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
        postalCode: deserializeParam(
          data['PostalCode'],
          ParamType.String,
          false,
        ),
        notes: deserializeParam(
          data['Notes'],
          ParamType.String,
          false,
        ),
        printerId: deserializeParam(
          data['PrinterId'],
          ParamType.int,
          false,
        ),
        responceFromPrinter: deserializeParam(
          data['ResponceFromPrinter'],
          ParamType.String,
          false,
        ),
        cancelledBy: deserializeParam(
          data['CancelledBy'],
          ParamType.String,
          false,
        ),
        cancelledReason: deserializeParam(
          data['CancelledReason'],
          ParamType.String,
          false,
        ),
        cancelled: deserializeParam(
          data['Cancelled'],
          ParamType.bool,
          false,
        ),
        acknowledged: deserializeParam(
          data['Acknowledged'],
          ParamType.String,
          false,
        ),
        outForDelivery: deserializeParam(
          data['OutForDelivery'],
          ParamType.bool,
          false,
        ),
        voucherCodeDiscount: deserializeParam(
          data['VoucherCodeDiscount'],
          ParamType.double,
          false,
        ),
        voucherCode: deserializeParam(
          data['VoucherCode'],
          ParamType.String,
          false,
        ),
        printed: deserializeParam(
          data['Printed'],
          ParamType.String,
          false,
        ),
        discount: deserializeParam(
          data['Discount'],
          ParamType.double,
          false,
        ),
        discountID: deserializeParam(
          data['DiscountID'],
          ParamType.int,
          false,
        ),
        cardFee: deserializeParam(
          data['CardFee'],
          ParamType.String,
          false,
        ),
        serviceCharge: deserializeParam(
          data['ServiceCharge'],
          ParamType.double,
          false,
        ),
        businessDetailID: deserializeParam(
          data['BusinessDetailID'],
          ParamType.int,
          false,
        ),
        customerID: deserializeParam(
          data['CustomerID'],
          ParamType.int,
          false,
        ),
        status: deserializeParam(
          data['Status'],
          ParamType.String,
          false,
        ),
        clientIP: deserializeParam(
          data['ClientIP'],
          ParamType.String,
          false,
        ),
        validForLoyality: deserializeParam(
          data['ValidForLoyality'],
          ParamType.String,
          false,
        ),
        orderText: deserializeParam(
          data['OrderText'],
          ParamType.String,
          false,
        ),
        discountPercentage: deserializeParam(
          data['DiscountPercentage'],
          ParamType.String,
          false,
        ),
        sagePayAuth: deserializeParam(
          data['SagePayAuth'],
          ParamType.String,
          false,
        ),
        supportAcknowledged: deserializeParam(
          data['SupportAcknowledged'],
          ParamType.String,
          false,
        ),
        allResolved: deserializeParam(
          data['AllResolved'],
          ParamType.String,
          false,
        ),
        supportAcknowledgedAt: deserializeParam(
          data['SupportAcknowledgedAt'],
          ParamType.String,
          false,
        ),
        allResolvedAt: deserializeParam(
          data['AllResolvedAt'],
          ParamType.String,
          false,
        ),
        appType: deserializeParam(
          data['AppType'],
          ParamType.String,
          false,
        ),
        supportAgentId: deserializeParam(
          data['SupportAgentId'],
          ParamType.String,
          false,
        ),
        printerStatus: deserializeParam(
          data['PrinterStatus'],
          ParamType.String,
          false,
        ),
        riderLongitude: deserializeParam(
          data['RiderLongitude'],
          ParamType.double,
          false,
        ),
        riderLatitude: deserializeParam(
          data['RiderLatitude'],
          ParamType.double,
          false,
        ),
        riderId: deserializeParam(
          data['RiderId'],
          ParamType.int,
          false,
        ),
        totalTax: deserializeParam(
          data['TotalTax'],
          ParamType.double,
          false,
        ),
        orderotp: deserializeParam(
          data['Orderotp'],
          ParamType.String,
          false,
        ),
        cancelledDate: deserializeParam(
          data['CancelledDate'],
          ParamType.String,
          false,
        ),
        acknowledgedDate: deserializeParam(
          data['AcknowledgedDate'],
          ParamType.String,
          false,
        ),
        acceptedOn: deserializeParam(
          data['AcceptedOn'],
          ParamType.String,
          false,
        ),
        riderAcceptedOn: deserializeParam(
          data['RiderAcceptedOn'],
          ParamType.String,
          false,
        ),
        orderDeliveredOn: deserializeParam(
          data['OrderDeliveredOn'],
          ParamType.String,
          false,
        ),
        riderLocationLastUpdated: deserializeParam(
          data['RiderLocationLastUpdated'],
          ParamType.String,
          false,
        ),
        orderCompletedOn: deserializeParam(
          data['OrderCompletedOn'],
          ParamType.String,
          false,
        ),
        completed: deserializeParam(
          data['Completed'],
          ParamType.String,
          false,
        ),
        readyInKitchenTime: deserializeParam(
          data['ReadyInKitchenTime'],
          ParamType.String,
          false,
        ),
        trackingDisable: deserializeParam(
          data['TrackingDisable'],
          ParamType.bool,
          false,
        ),
        tracking: deserializeParam(
          data['Tracking'],
          ParamType.String,
          false,
        ),
        payoutStatus: deserializeParam(
          data['PayoutStatus'],
          ParamType.String,
          false,
        ),
        payoutId: deserializeParam(
          data['PayoutId'],
          ParamType.String,
          false,
        ),
        payoutAmountToOutlet: deserializeParam(
          data['PayoutAmountToOutlet'],
          ParamType.String,
          false,
        ),
        qmanjaFee: deserializeParam(
          data['QmanjaFee'],
          ParamType.String,
          false,
        ),
        invoiceId: deserializeParam(
          data['InvoiceId'],
          ParamType.String,
          false,
        ),
        riderstatredAt: deserializeParam(
          data['RiderstatredAt'],
          ParamType.String,
          false,
        ),
        markAsPaidAt: deserializeParam(
          data['MarkAsPaidAt'],
          ParamType.String,
          false,
        ),
        markAsPaidBy: deserializeParam(
          data['MarkAsPaidBy'],
          ParamType.String,
          false,
        ),
        ppresponseText: deserializeParam(
          data['PpresponseText'],
          ParamType.String,
          false,
        ),
        ppresponse: deserializeParam(
          data['Ppresponse'],
          ParamType.String,
          false,
        ),
        businessName: deserializeParam(
          data['BusinessName'],
          ParamType.String,
          false,
        ),
        packageCharges: deserializeParam(
          data['PackageCharges'],
          ParamType.int,
          false,
        ),
        isOrderSentToThirdParty: deserializeParam(
          data['IsOrderSentToThirdParty'],
          ParamType.String,
          false,
        ),
        isPreorder: deserializeParam(
          data['IsPreorder'],
          ParamType.String,
          false,
        ),
        preorderTime: deserializeParam(
          data['PreorderTime'],
          ParamType.String,
          false,
        ),
        businessDetail: deserializeParam(
          data['businessDetail'],
          ParamType.String,
          false,
        ),
        riderDeclineHistory: deserializeParam(
          data['RiderDeclineHistory'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CompletedOrdersStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CompletedOrdersStruct &&
        id == other.id &&
        appVersion == other.appVersion &&
        creationDate == other.creationDate &&
        orderDate == other.orderDate &&
        deliveryType == other.deliveryType &&
        deliveryTime == other.deliveryTime &&
        paymentType == other.paymentType &&
        subTotal == other.subTotal &&
        shippingFee == other.shippingFee &&
        orderTotal == other.orderTotal &&
        sessionId == other.sessionId &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        email == other.email &&
        phone == other.phone &&
        address == other.address &&
        postalCode == other.postalCode &&
        notes == other.notes &&
        printerId == other.printerId &&
        responceFromPrinter == other.responceFromPrinter &&
        cancelledBy == other.cancelledBy &&
        cancelledReason == other.cancelledReason &&
        cancelled == other.cancelled &&
        acknowledged == other.acknowledged &&
        outForDelivery == other.outForDelivery &&
        voucherCodeDiscount == other.voucherCodeDiscount &&
        voucherCode == other.voucherCode &&
        printed == other.printed &&
        discount == other.discount &&
        discountID == other.discountID &&
        cardFee == other.cardFee &&
        serviceCharge == other.serviceCharge &&
        businessDetailID == other.businessDetailID &&
        customerID == other.customerID &&
        status == other.status &&
        clientIP == other.clientIP &&
        validForLoyality == other.validForLoyality &&
        orderText == other.orderText &&
        discountPercentage == other.discountPercentage &&
        sagePayAuth == other.sagePayAuth &&
        supportAcknowledged == other.supportAcknowledged &&
        allResolved == other.allResolved &&
        supportAcknowledgedAt == other.supportAcknowledgedAt &&
        allResolvedAt == other.allResolvedAt &&
        appType == other.appType &&
        supportAgentId == other.supportAgentId &&
        printerStatus == other.printerStatus &&
        riderLongitude == other.riderLongitude &&
        riderLatitude == other.riderLatitude &&
        riderId == other.riderId &&
        totalTax == other.totalTax &&
        orderotp == other.orderotp &&
        cancelledDate == other.cancelledDate &&
        acknowledgedDate == other.acknowledgedDate &&
        acceptedOn == other.acceptedOn &&
        riderAcceptedOn == other.riderAcceptedOn &&
        orderDeliveredOn == other.orderDeliveredOn &&
        riderLocationLastUpdated == other.riderLocationLastUpdated &&
        orderCompletedOn == other.orderCompletedOn &&
        completed == other.completed &&
        readyInKitchenTime == other.readyInKitchenTime &&
        trackingDisable == other.trackingDisable &&
        tracking == other.tracking &&
        payoutStatus == other.payoutStatus &&
        payoutId == other.payoutId &&
        payoutAmountToOutlet == other.payoutAmountToOutlet &&
        qmanjaFee == other.qmanjaFee &&
        invoiceId == other.invoiceId &&
        riderstatredAt == other.riderstatredAt &&
        markAsPaidAt == other.markAsPaidAt &&
        markAsPaidBy == other.markAsPaidBy &&
        ppresponseText == other.ppresponseText &&
        ppresponse == other.ppresponse &&
        businessName == other.businessName &&
        packageCharges == other.packageCharges &&
        isOrderSentToThirdParty == other.isOrderSentToThirdParty &&
        isPreorder == other.isPreorder &&
        preorderTime == other.preorderTime &&
        businessDetail == other.businessDetail &&
        riderDeclineHistory == other.riderDeclineHistory;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        appVersion,
        creationDate,
        orderDate,
        deliveryType,
        deliveryTime,
        paymentType,
        subTotal,
        shippingFee,
        orderTotal,
        sessionId,
        firstName,
        lastName,
        email,
        phone,
        address,
        postalCode,
        notes,
        printerId,
        responceFromPrinter,
        cancelledBy,
        cancelledReason,
        cancelled,
        acknowledged,
        outForDelivery,
        voucherCodeDiscount,
        voucherCode,
        printed,
        discount,
        discountID,
        cardFee,
        serviceCharge,
        businessDetailID,
        customerID,
        status,
        clientIP,
        validForLoyality,
        orderText,
        discountPercentage,
        sagePayAuth,
        supportAcknowledged,
        allResolved,
        supportAcknowledgedAt,
        allResolvedAt,
        appType,
        supportAgentId,
        printerStatus,
        riderLongitude,
        riderLatitude,
        riderId,
        totalTax,
        orderotp,
        cancelledDate,
        acknowledgedDate,
        acceptedOn,
        riderAcceptedOn,
        orderDeliveredOn,
        riderLocationLastUpdated,
        orderCompletedOn,
        completed,
        readyInKitchenTime,
        trackingDisable,
        tracking,
        payoutStatus,
        payoutId,
        payoutAmountToOutlet,
        qmanjaFee,
        invoiceId,
        riderstatredAt,
        markAsPaidAt,
        markAsPaidBy,
        ppresponseText,
        ppresponse,
        businessName,
        packageCharges,
        isOrderSentToThirdParty,
        isPreorder,
        preorderTime,
        businessDetail,
        riderDeclineHistory
      ]);
}

CompletedOrdersStruct createCompletedOrdersStruct({
  int? id,
  int? appVersion,
  String? creationDate,
  String? orderDate,
  String? deliveryType,
  String? deliveryTime,
  String? paymentType,
  double? subTotal,
  double? shippingFee,
  double? orderTotal,
  String? sessionId,
  String? firstName,
  String? lastName,
  String? email,
  String? phone,
  String? address,
  String? postalCode,
  String? notes,
  int? printerId,
  String? responceFromPrinter,
  String? cancelledBy,
  String? cancelledReason,
  bool? cancelled,
  String? acknowledged,
  bool? outForDelivery,
  double? voucherCodeDiscount,
  String? voucherCode,
  String? printed,
  double? discount,
  int? discountID,
  String? cardFee,
  double? serviceCharge,
  int? businessDetailID,
  int? customerID,
  String? status,
  String? clientIP,
  String? validForLoyality,
  String? orderText,
  String? discountPercentage,
  String? sagePayAuth,
  String? supportAcknowledged,
  String? allResolved,
  String? supportAcknowledgedAt,
  String? allResolvedAt,
  String? appType,
  String? supportAgentId,
  String? printerStatus,
  double? riderLongitude,
  double? riderLatitude,
  int? riderId,
  double? totalTax,
  String? orderotp,
  String? cancelledDate,
  String? acknowledgedDate,
  String? acceptedOn,
  String? riderAcceptedOn,
  String? orderDeliveredOn,
  String? riderLocationLastUpdated,
  String? orderCompletedOn,
  String? completed,
  String? readyInKitchenTime,
  bool? trackingDisable,
  String? tracking,
  String? payoutStatus,
  String? payoutId,
  String? payoutAmountToOutlet,
  String? qmanjaFee,
  String? invoiceId,
  String? riderstatredAt,
  String? markAsPaidAt,
  String? markAsPaidBy,
  String? ppresponseText,
  String? ppresponse,
  String? businessName,
  int? packageCharges,
  String? isOrderSentToThirdParty,
  String? isPreorder,
  String? preorderTime,
  String? businessDetail,
  String? riderDeclineHistory,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CompletedOrdersStruct(
      id: id,
      appVersion: appVersion,
      creationDate: creationDate,
      orderDate: orderDate,
      deliveryType: deliveryType,
      deliveryTime: deliveryTime,
      paymentType: paymentType,
      subTotal: subTotal,
      shippingFee: shippingFee,
      orderTotal: orderTotal,
      sessionId: sessionId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      postalCode: postalCode,
      notes: notes,
      printerId: printerId,
      responceFromPrinter: responceFromPrinter,
      cancelledBy: cancelledBy,
      cancelledReason: cancelledReason,
      cancelled: cancelled,
      acknowledged: acknowledged,
      outForDelivery: outForDelivery,
      voucherCodeDiscount: voucherCodeDiscount,
      voucherCode: voucherCode,
      printed: printed,
      discount: discount,
      discountID: discountID,
      cardFee: cardFee,
      serviceCharge: serviceCharge,
      businessDetailID: businessDetailID,
      customerID: customerID,
      status: status,
      clientIP: clientIP,
      validForLoyality: validForLoyality,
      orderText: orderText,
      discountPercentage: discountPercentage,
      sagePayAuth: sagePayAuth,
      supportAcknowledged: supportAcknowledged,
      allResolved: allResolved,
      supportAcknowledgedAt: supportAcknowledgedAt,
      allResolvedAt: allResolvedAt,
      appType: appType,
      supportAgentId: supportAgentId,
      printerStatus: printerStatus,
      riderLongitude: riderLongitude,
      riderLatitude: riderLatitude,
      riderId: riderId,
      totalTax: totalTax,
      orderotp: orderotp,
      cancelledDate: cancelledDate,
      acknowledgedDate: acknowledgedDate,
      acceptedOn: acceptedOn,
      riderAcceptedOn: riderAcceptedOn,
      orderDeliveredOn: orderDeliveredOn,
      riderLocationLastUpdated: riderLocationLastUpdated,
      orderCompletedOn: orderCompletedOn,
      completed: completed,
      readyInKitchenTime: readyInKitchenTime,
      trackingDisable: trackingDisable,
      tracking: tracking,
      payoutStatus: payoutStatus,
      payoutId: payoutId,
      payoutAmountToOutlet: payoutAmountToOutlet,
      qmanjaFee: qmanjaFee,
      invoiceId: invoiceId,
      riderstatredAt: riderstatredAt,
      markAsPaidAt: markAsPaidAt,
      markAsPaidBy: markAsPaidBy,
      ppresponseText: ppresponseText,
      ppresponse: ppresponse,
      businessName: businessName,
      packageCharges: packageCharges,
      isOrderSentToThirdParty: isOrderSentToThirdParty,
      isPreorder: isPreorder,
      preorderTime: preorderTime,
      businessDetail: businessDetail,
      riderDeclineHistory: riderDeclineHistory,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CompletedOrdersStruct? updateCompletedOrdersStruct(
  CompletedOrdersStruct? completedOrders, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    completedOrders
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCompletedOrdersStructData(
  Map<String, dynamic> firestoreData,
  CompletedOrdersStruct? completedOrders,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (completedOrders == null) {
    return;
  }
  if (completedOrders.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && completedOrders.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final completedOrdersData =
      getCompletedOrdersFirestoreData(completedOrders, forFieldValue);
  final nestedData =
      completedOrdersData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = completedOrders.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCompletedOrdersFirestoreData(
  CompletedOrdersStruct? completedOrders, [
  bool forFieldValue = false,
]) {
  if (completedOrders == null) {
    return {};
  }
  final firestoreData = mapToFirestore(completedOrders.toMap());

  // Add any Firestore field values
  mapToFirestore(completedOrders.firestoreUtilData.fieldValues)
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCompletedOrdersListFirestoreData(
  List<CompletedOrdersStruct>? completedOrderss,
) =>
    completedOrderss
        ?.map((e) => getCompletedOrdersFirestoreData(e, true))
        .toList() ??
    [];
