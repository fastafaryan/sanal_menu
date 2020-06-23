import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanal_menu/controllers/waiter/waiter_payments_controller.dart';
import 'package:sanal_menu/views/waiter/widgets/waiter_all_payments.dart';
import 'package:sanal_menu/views/waiter/widgets/waiter_assigned_payments.dart';

class WaiterPayments extends StatelessWidget {
  final AsyncSnapshot paymentsSnapshot; // presents Order model
  final AsyncSnapshot assignedPaymentsSnapshot; // presents Order model
  WaiterPayments({this.paymentsSnapshot, this.assignedPaymentsSnapshot});

  @override
  Widget build(BuildContext context) {
    List<Payment> payments = Provider.of<WaiterPaymentsController>(context).payments;
    List<Payment> assignedPayments = Provider.of<WaiterPaymentsController>(context).assignedPayments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WaiterPaymentsController>(context, listen: false).setPayments(paymentsSnapshot.data);
      Provider.of<WaiterPaymentsController>(context, listen: false).setAssignedPayments(assignedPaymentsSnapshot.data);
    });

    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  WaiterAssignedPayments(assignedPayments: assignedPayments),
                  WaiterAllPayments(payments: payments),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
