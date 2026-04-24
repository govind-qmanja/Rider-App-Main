import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'order_history_widget.dart' show OrderHistoryWidget;
import 'package:flutter/material.dart';

class OrderHistoryModel extends FlutterFlowModel<OrderHistoryWidget> {
  ///  Local state fields for this page.

  dynamic completedOrdersListView;

  bool loading = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (GetOrderHISTORY)] action in orderHistory widget.
  ApiCallResponse? orderHistory;
  // Stores action output result for [Backend Call - API (DeclineRequest)] action in Button widget.
  ApiCallResponse? declinerequest;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
